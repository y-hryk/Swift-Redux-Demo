//
//  ModalManager.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/07/27.
//

import SwiftUI
import UIKit

// MARK: - Modal Presentation Style
enum ModalPresentationStyle {
    case fullScreenCover
    case sheet
    
    var uiModalPresentationStyle: UIModalPresentationStyle {
        switch self {
        case .fullScreenCover:
            return .fullScreen
        case .sheet:
            return .pageSheet
        }
    }
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

// MARK: - Custom Hosting Controller
private class DismissTrackingHostingController<Content: View>: UIHostingController<Content> {
    var onDismiss: (() -> Void)?
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed || isMovingFromParent {
            onDismiss?()
        }
    }
}

// MARK: - Modal Window Manager
class ModalWindowManager: ObservableObject {
    static let shared = ModalWindowManager()
    
    // 単一のWindowとルートコントローラーを使用
    private var modalWindow: UIWindow?
    private var modalRootController: UIViewController?
    
    // モーダルコントローラーの管理
    private var modalControllers: [String: UIViewController] = [:]
    private var modalStack: [ModalItem] = []
    private var onModalDismiss: ((String) -> Void)?
    
    private init() {}
    
    func setModalStack(_ stack: [ModalItem], onDismiss: @escaping (String) -> Void) {
        self.onModalDismiss = onDismiss
        let oldStack = modalStack
        modalStack = stack
        
        // 削除されたモーダルを閉じる
        dismissRemovedModals(oldStack: oldStack, newStack: stack)
        
        // 新しいモーダルを表示
        presentNewModals(oldStack: oldStack, newStack: stack)
        
        // スタックが空になった場合の処理は、最後のモーダルが完全に閉じられた後に行う
        // （dismissModal内で処理）
    }
    
    private func dismissRemovedModals(oldStack: [ModalItem], newStack: [ModalItem]) {
        let removedItems = oldStack.filter { oldItem in
            !newStack.contains { $0.id == oldItem.id }
        }
        
        for item in removedItems {
            dismissModal(with: item.id)
        }
    }
    
    private func presentNewModals(oldStack: [ModalItem], newStack: [ModalItem]) {
        let newItems = newStack.filter { newItem in
            !oldStack.contains { $0.id == newItem.id }
        }
        
        for item in newItems {
            presentModal(item)
        }
    }
    
    private func ensureModalWindow() -> Bool {
        if modalWindow == nil {
            guard let windowScene = getActiveWindowScene() else {
                print("WindowScene not found")
                return false
            }
            
            setupModalWindow(windowScene: windowScene)
        }
        return true
    }
    
    private func getActiveWindowScene() -> UIWindowScene? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
    }
    
    private func setupModalWindow(windowScene: UIWindowScene) {
        let window = UIWindow(windowScene: windowScene)
        window.windowLevel = UIWindow.Level.alert
        window.backgroundColor = UIColor.clear
        window.isHidden = false
        
        let rootController = UIViewController()
        rootController.view.backgroundColor = UIColor.clear
        window.rootViewController = rootController
        
        modalWindow = window
        modalRootController = rootController
    }
    
    private func presentModal(_ item: ModalItem) {
        guard modalControllers[item.id] == nil else { return }
        guard ensureModalWindow() else { return }
        
        let hostingController = createHostingController(for: item)
        
        // 現在のトップコントローラーを取得
        let presenter = getTopPresentedController() ?? modalRootController
        presenter?.present(hostingController, animated: true)
        
        modalControllers[item.id] = hostingController
    }
    
    private func createHostingController(for item: ModalItem) -> DismissTrackingHostingController<some View> {
        let hostingController = DismissTrackingHostingController(rootView: item.destination())
        hostingController.modalPresentationStyle = item.presentationStyle.uiModalPresentationStyle
        hostingController.onDismiss = { [weak self] in
            self?.handleModalDismiss(itemId: item.id)
        }
        return hostingController
    }
    
    private func getTopPresentedController() -> UIViewController? {
        var topController = modalRootController
        while let presented = topController?.presentedViewController {
            topController = presented
        }
        return topController
    }
    
    private func dismissModal(with itemId: String) {
        guard let controller = modalControllers[itemId] else { return }
        
        controller.dismiss(animated: true) { [weak self] in
            self?.modalControllers.removeValue(forKey: itemId)
            
            // 全てのモーダルが閉じられた場合にWindowを非表示にする
            if self?.modalControllers.isEmpty == true && self?.modalStack.isEmpty == true {
                self?.hideModalWindow()
            }
        }
    }
    
    private func handleModalDismiss(itemId: String) {
        modalControllers.removeValue(forKey: itemId)
        onModalDismiss?(itemId)
        
        // ユーザーによる手動dismiss時も、全てのモーダルが閉じられた場合にWindowを非表示にする
        if modalControllers.isEmpty && modalStack.isEmpty {
            hideModalWindow()
        }
    }
    
    private func hideModalWindow() {
        modalWindow?.isHidden = true
        modalWindow = nil
        modalRootController = nil
        modalControllers.removeAll()
    }
    
    func dismissAll() {
        for (itemId, controller) in modalControllers {
            controller.dismiss(animated: false)
        }
        modalControllers.removeAll()
        hideModalWindow()
    }
}

// MARK: - Modal Stack ViewModifier
struct ModalStack: ViewModifier {
    @Binding var path: [ModalItem]
    @StateObject private var manager = ModalWindowManager.shared
    
    func body(content: Content) -> some View {
        content
            .onChange(of: path) { _, newValue in
                updateModalStack(newValue)
            }
            .onAppear {
                updateModalStack(path)
            }
    }
    
    private func updateModalStack(_ newPath: [ModalItem]) {
        manager.setModalStack(newPath) { dismissedItemId in
            removeModalFromPath(dismissedItemId)
        }
    }
    
    private func removeModalFromPath(_ dismissedItemId: String) {
        if let index = path.firstIndex(where: { $0.id == dismissedItemId }) {
            DispatchQueue.main.async {
                path.removeSubrange(index...)
            }
        }
    }
}

// MARK: - View Extension
extension View {
    func modalStack(path: Binding<[ModalItem]>) -> some View {
        self.modifier(ModalStack(path: path))
    }
    
    func dismissAllModals() {
        ModalWindowManager.shared.dismissAll()
    }
}
