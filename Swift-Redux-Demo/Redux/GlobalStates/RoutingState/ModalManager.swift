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
        hasher.combine(routingPath)
    }
    
    static func == (lhs: ModalItem, rhs: ModalItem) -> Bool {
        lhs.id == rhs.id && lhs.routingPath == rhs.routingPath
    }
}

// MARK: - Infinite Modal ViewModifier
struct InfiniteModalModifier: ViewModifier {
    @Binding var modalPath: [ModalItem]
    
    func body(content: Content) -> some View {
        content
            .modifier(ModalPresentationModifier(modalPath: $modalPath))
    }
}

// MARK: - Modal Presentation Modifier
struct ModalPresentationModifier: ViewModifier {
    @Binding var modalPath: [ModalItem]
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(
                item: Binding<ModalItem?>(
                    get: { modalPath.first(where: { $0.presentationStyle == .fullScreenCover }) },
                    set: { _ in handleModalDismiss(presentationStyle: .fullScreenCover) }
                )
            ) { item in
                let remainingStack = getRemainingStack(after: item.id)
                ModalStackView(item: item, remainingStack: remainingStack, modalPath: $modalPath)
            }
            .sheet(
                item: Binding<ModalItem?>(
                    get: { modalPath.first(where: { $0.presentationStyle == .sheet }) },
                    set: { _ in handleModalDismiss(presentationStyle: .sheet) }
                )
            ) { item in
                let remainingStack = getRemainingStack(after: item.id)
                ModalStackView(item: item, remainingStack: remainingStack, modalPath: $modalPath)
            }
            .onChange(of: modalPath) { _, _ in
                detectForcedDismissals()
            }
    }
    
    private func getRemainingStack(after itemId: String) -> [ModalItem] {
        guard let index = modalPath.firstIndex(where: { $0.id == itemId }) else { return [] }
        let nextIndex = index + 1
        return nextIndex < modalPath.count ? Array(modalPath[nextIndex...]) : []
    }
    
    private func handleModalDismiss(presentationStyle: ModalPresentationStyle) {
        if let index = modalPath.firstIndex(where: { $0.presentationStyle == presentationStyle }) {
            modalPath.removeSubrange(index...)
        }
    }
    
    private func detectForcedDismissals() {
        let hasSheet = modalPath.contains { $0.presentationStyle == .sheet }
        let hasFullScreenCover = modalPath.contains { $0.presentationStyle == .fullScreenCover }
        
        // sheetの上にfullScreenCoverが表示される場合、sheetが強制的に閉じられる
        if hasSheet && hasFullScreenCover {
            if let firstFullScreenIndex = modalPath.firstIndex(where: { $0.presentationStyle == .fullScreenCover }) {
                // fullScreenCoverより前のsheetを削除
                modalPath.removeAll { item in
                    if let itemIndex = modalPath.firstIndex(where: { $0.id == item.id }) {
                        return itemIndex < firstFullScreenIndex && item.presentationStyle == .sheet
                    }
                    return false
                }
            }
        }
    }
}

// MARK: - Modal Stack View
struct ModalStackView: View {
    let item: ModalItem
    let remainingStack: [ModalItem]
    @Binding var modalPath: [ModalItem]
    
    var body: some View {
        item.destination()
            .modifier(ModalStackPresentationModifier(
                remainingStack: remainingStack,
                modalPath: $modalPath,
                currentItemId: item.id
            ))
            .onDisappear {
                handleUnexpectedDismiss()
            }
    }
    
    private func handleUnexpectedDismiss() {
        if let currentIndex = modalPath.firstIndex(where: { $0.id == item.id }) {
            DispatchQueue.main.async {
                if currentIndex < modalPath.count {
                    modalPath.removeSubrange(currentIndex...)
                }
            }
        }
    }
}

// MARK: - Modal Stack Presentation Modifier
struct ModalStackPresentationModifier: ViewModifier {
    let remainingStack: [ModalItem]
    @Binding var modalPath: [ModalItem]
    let currentItemId: String
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(
                item: Binding<ModalItem?>(
                    get: { remainingStack.first(where: { $0.presentationStyle == .fullScreenCover }) },
                    set: { _ in handleNestedModalDismiss(presentationStyle: .fullScreenCover) }
                )
            ) { nextItem in
                let nextStack = getRemainingStack(after: nextItem.id)
                ModalStackView(item: nextItem, remainingStack: nextStack, modalPath: $modalPath)
            }
            .sheet(
                item: Binding<ModalItem?>(
                    get: { remainingStack.first(where: { $0.presentationStyle == .sheet }) },
                    set: { _ in handleNestedModalDismiss(presentationStyle: .sheet) }
                )
            ) { nextItem in
                let nextStack = getRemainingStack(after: nextItem.id)
                ModalStackView(item: nextItem, remainingStack: nextStack, modalPath: $modalPath)
            }
    }
    
    private func getRemainingStack(after itemId: String) -> [ModalItem] {
        guard let index = remainingStack.firstIndex(where: { $0.id == itemId }) else { return [] }
        let nextIndex = index + 1
        return nextIndex < remainingStack.count ? Array(remainingStack[nextIndex...]) : []
    }
    
    private func handleNestedModalDismiss(presentationStyle: ModalPresentationStyle) {
        guard let currentIndex = modalPath.firstIndex(where: { $0.id == currentItemId }) else { return }
        
        let searchStartIndex = currentIndex + 1
        if searchStartIndex < modalPath.count {
            let remainingItems = Array(modalPath[searchStartIndex...])
            if let targetIndex = remainingItems.firstIndex(where: { $0.presentationStyle == presentationStyle }) {
                let actualIndex = searchStartIndex + targetIndex
                modalPath.removeSubrange(actualIndex...)
            }
        }
    }
}

// MARK: - View Extension
extension View {
    func infiniteModal(path: Binding<[ModalItem]>) -> some View {
        self.modifier(InfiniteModalModifier(modalPath: path))
    }
}

/*
// MARK: - Modal Item
struct ModalItem: Identifiable {
    let id: String
    let view: AnyView
    
    init<Content: View>(id: String = UUID().uuidString, @ViewBuilder content: () -> Content) {
        self.id = id
        self.view = AnyView(content())
    }
}

// MARK: - Modal Stack Manager
final class ModalStackManager: ObservableObject {
    static let shared = ModalStackManager()
    
    @Published private(set) var modalStack: [ModalItem] = []
    
    private let stackUpdateTrigger = PassthroughSubject<[ModalItem], Never>()
    var stackPublisher: AnyPublisher<[ModalItem], Never> {
        stackUpdateTrigger.eraseToAnyPublisher()
    }
    
    private init() {}
    
    // モーダルをスタックにプッシュ
    func push<Content: View>(@ViewBuilder content: () -> Content) {
        let item = ModalItem(content: content)
        modalStack.append(item)
        stackUpdateTrigger.send(modalStack)
    }
    
    // IDを指定してプッシュ
    func push<Content: View>(id: String, @ViewBuilder content: () -> Content) {
        let item = ModalItem(id: id, content: content)
        modalStack.append(item)
        stackUpdateTrigger.send(modalStack)
    }
    
    // 最上位のモーダルをポップ
    func pop() {
        guard !modalStack.isEmpty else { return }
        modalStack.removeLast()
        stackUpdateTrigger.send(modalStack)
    }
    
    // 指定されたIDのモーダルをポップ（そのモーダルより上のモーダルもすべて閉じる）
    func popTo(id: String) {
        guard let index = modalStack.firstIndex(where: { $0.id == id }) else { return }
        modalStack = Array(modalStack.prefix(through: index))
        modalStack.removeLast() // 指定されたモーダル自体も閉じる
        stackUpdateTrigger.send(modalStack)
    }
    
    // 全てのモーダルをポップ
    func popAll() {
        modalStack.removeAll()
        stackUpdateTrigger.send(modalStack)
    }
    
    // スタックの深さを取得
    var depth: Int {
        modalStack.count
    }
    
    // 現在表示中のモーダルを取得
    var currentModal: ModalItem? {
        modalStack.last
    }
}

// MARK: - Infinite Modal ViewModifier
struct InfiniteModalModifier: ViewModifier {
    @State private var displayedStack: [ModalItem] = []
    @StateObject private var modalManager = ModalStackManager.shared
    
    func body(content: Content) -> some View {
        content
            .onReceive(modalManager.stackPublisher) { newStack in
                handleStackUpdate(newStack: newStack)
            }
            .fullScreenCover(
                item: Binding<ModalItem?>(
                    get: { displayedStack.first },
                    set: { _ in
                        // モーダルが閉じられた時の処理
                        if !displayedStack.isEmpty {
                            displayedStack.removeFirst()
                        }
                    }
                )
            ) { item in
                // 残りのスタックを渡して再帰的に表示
                let remainingStack = Array(displayedStack.dropFirst())
                ModalStackView(item: item, remainingStack: remainingStack)
            }
    }
    
    private func handleStackUpdate(newStack: [ModalItem]) {
        // 新しいスタックが現在表示中のスタックと異なる場合のみ更新
        if newStack.map(\.id) != displayedStack.map(\.id) {
            displayedStack = newStack
        }
    }
}

// MARK: - Modal Stack View
struct ModalStackView: View {
    let item: ModalItem
    let remainingStack: [ModalItem]
    
    var body: some View {
        item.view
            .fullScreenCover(
                item: Binding<ModalItem?>(
                    get: { remainingStack.first },
                    set: { _ in }
                )
            ) { nextItem in
                let nextStack = Array(remainingStack.dropFirst())
                ModalStackView(item: nextItem, remainingStack: nextStack)
            }
    }
}

// MARK: - View Extension
extension View {
    func infiniteModal() -> some View {
        self.modifier(InfiniteModalModifier())
    }
}
*/
