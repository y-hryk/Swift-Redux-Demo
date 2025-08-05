//
//  ModalManager.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/07/27.
//

import SwiftUI

// MARK: - Modal Presentation Style
enum ModalPresentationStyle {
    case fullScreenCover
    case sheet
}

// MARK: - Modal Item
struct ModalItem: Identifiable, Hashable {
    let id: String
    let routingPath: RoutingPath
    let presentationStyle: ModalPresentationStyle
    
    init(
        id: String = UUID().uuidString,
        routingPath: RoutingPath,
        presentationStyle: ModalPresentationStyle = .fullScreenCover
    ) {
        self.id = id
        self.routingPath = routingPath
        self.presentationStyle = presentationStyle
    }
    
    @ViewBuilder
    func destination() -> some View {
        routingPath.destination()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ModalItem, rhs: ModalItem) -> Bool {
        lhs.id == rhs.id && lhs.routingPath == rhs.routingPath
    }
}

// MARK: - Modal Stack
struct ModalStack: ViewModifier {
    @Binding var path: [ModalItem]
    
    func body(content: Content) -> some View {
        content
            .modifier(ModalPresentationHandler(modalPath: $path))
    }
}

// MARK: - Modal Presentation Handler
private struct ModalPresentationHandler: ViewModifier {
    @Binding var modalPath: [ModalItem]
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(
                item: currentFullScreenItem
            ) { item in
                ModalStackView(
                    item: item,
                    remainingStack: getRemainingStack(after: item.id),
                    modalPath: $modalPath
                )
            }
            .sheet(
                item: currentSheetItem
            ) { item in
                ModalStackView(
                    item: item,
                    remainingStack: getRemainingStack(after: item.id),
                    modalPath: $modalPath
                )
            }
            .onChange(of: modalPath) { _, _ in
                handleForcedDismissals()
            }
    }
    
    // MARK: - Computed Properties
    private var currentFullScreenItem: Binding<ModalItem?> {
        Binding<ModalItem?>(
            get: { modalPath.first(where: { $0.presentationStyle == .fullScreenCover }) },
            set: { _ in dismissModal(with: .fullScreenCover) }
        )
    }
    
    private var currentSheetItem: Binding<ModalItem?> {
        Binding<ModalItem?>(
            get: { modalPath.first(where: { $0.presentationStyle == .sheet }) },
            set: { _ in dismissModal(with: .sheet) }
        )
    }
    
    // MARK: - Helper Methods
    private func getRemainingStack(after itemId: String) -> [ModalItem] {
        guard let index = modalPath.firstIndex(where: { $0.id == itemId }) else {
            return []
        }
        let nextIndex = index + 1
        return nextIndex < modalPath.count ? Array(modalPath[nextIndex...]) : []
    }
    
    private func dismissModal(with presentationStyle: ModalPresentationStyle) {
        guard let index = modalPath.firstIndex(where: { $0.presentationStyle == presentationStyle }) else {
            return
        }
        modalPath.removeSubrange(index...)
    }
    
    private func handleForcedDismissals() {
        let hasSheet = modalPath.contains { $0.presentationStyle == .sheet }
        let hasFullScreenCover = modalPath.contains { $0.presentationStyle == .fullScreenCover }
        
        // fullScreenCoverがsheetの上に表示される場合、sheetが強制的に閉じられる
        if hasSheet && hasFullScreenCover {
            removeConflictingSheets()
        }
    }
    
    private func removeConflictingSheets() {
        guard let firstFullScreenIndex = modalPath.firstIndex(where: { $0.presentationStyle == .fullScreenCover }) else {
            return
        }
        
        modalPath.removeAll { item in
            guard let itemIndex = modalPath.firstIndex(where: { $0.id == item.id }) else {
                return false
            }
            return itemIndex < firstFullScreenIndex && item.presentationStyle == .sheet
        }
    }
}

// MARK: - Modal Stack View
private struct ModalStackView: View {
    let item: ModalItem
    let remainingStack: [ModalItem]
    @Binding var modalPath: [ModalItem]
    
    var body: some View {
        item.destination()
            .modifier(NestedModalHandler(
                remainingStack: remainingStack,
                modalPath: $modalPath,
                currentItemId: item.id
            ))
            .onDisappear {
                handleUnexpectedDismiss()
            }
    }
    
    private func handleUnexpectedDismiss() {
        guard let currentIndex = modalPath.firstIndex(where: { $0.id == item.id }) else {
            return
        }
        
        DispatchQueue.main.async {
            if currentIndex < modalPath.count {
                modalPath.removeSubrange(currentIndex...)
            }
        }
    }
}

// MARK: - Nested Modal Handler
private struct NestedModalHandler: ViewModifier {
    let remainingStack: [ModalItem]
    @Binding var modalPath: [ModalItem]
    let currentItemId: String
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(
                item: nextFullScreenItem
            ) { nextItem in
                ModalStackView(
                    item: nextItem,
                    remainingStack: getRemainingStack(after: nextItem.id),
                    modalPath: $modalPath
                )
            }
            .sheet(
                item: nextSheetItem
            ) { nextItem in
                ModalStackView(
                    item: nextItem,
                    remainingStack: getRemainingStack(after: nextItem.id),
                    modalPath: $modalPath
                )
            }
    }
    
    // MARK: - Computed Properties
    private var nextFullScreenItem: Binding<ModalItem?> {
        Binding<ModalItem?>(
            get: { remainingStack.first(where: { $0.presentationStyle == .fullScreenCover }) },
            set: { _ in dismissNestedModal(with: .fullScreenCover) }
        )
    }
    
    private var nextSheetItem: Binding<ModalItem?> {
        Binding<ModalItem?>(
            get: { remainingStack.first(where: { $0.presentationStyle == .sheet }) },
            set: { _ in dismissNestedModal(with: .sheet) }
        )
    }
    
    // MARK: - Helper Methods
    private func getRemainingStack(after itemId: String) -> [ModalItem] {
        guard let index = remainingStack.firstIndex(where: { $0.id == itemId }) else {
            return []
        }
        let nextIndex = index + 1
        return nextIndex < remainingStack.count ? Array(remainingStack[nextIndex...]) : []
    }
    
    private func dismissNestedModal(with presentationStyle: ModalPresentationStyle) {
        guard let currentIndex = modalPath.firstIndex(where: { $0.id == currentItemId }) else {
            return
        }
        
        let searchStartIndex = currentIndex + 1
        guard searchStartIndex < modalPath.count else {
            return
        }
        
        let remainingItems = Array(modalPath[searchStartIndex...])
        guard let targetIndex = remainingItems.firstIndex(where: { $0.presentationStyle == presentationStyle }) else {
            return
        }
        
        let actualIndex = searchStartIndex + targetIndex
        modalPath.removeSubrange(actualIndex...)
    }
}

// MARK: - View Extension
extension View {
    func modalStack(path: Binding<[ModalItem]>) -> some View {
        self.modifier(ModalStack(path: path))
    }
}
