//
//  Toast.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/02.
//

import SwiftUI

struct Toast: Equatable, Codable {
    var style: ToastStyle
    var title: String? = nil
    var message: String
    var duration: Double = 5
    var width: Double = .infinity
    var closeButtonHidden = true
}

enum ToastStyle: Codable {
    case error
    case warning
    case success
    case info
    
    var iconColor: Color {
      switch self {
      case .error: return Color.red
      case .warning: return Color.orange
      case .info: return Color.blue
      case .success: return Color.green
      }
    }
    
    var backgroundColor: Color {
      switch self {
      case .error: return Color.Toast.red
      case .warning: return Color.Toast.yellow
      case .info: return Color.Toast.blue
      case .success: return Color.Toast.green
      }
    }
    
    var iconFileName: String {
      switch self {
      case .info: return "info.circle.fill"
      case .warning: return "exclamationmark.triangle.fill"
      case .success: return "checkmark.circle.fill"
      case .error: return "xmark.circle.fill"
      }
    }
}

struct ToastView: View {
    var style: ToastStyle
    var title: String
    var message: String
    var width = CGFloat.infinity
    var closeButtonHidden = true
    var onCancelTapped: (() -> Void)
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: style.iconFileName)
                .foregroundColor(style.iconColor)

            VStack(alignment: .leading) {
                if !title.isEmpty {
                    Text(title)
                        .font(.bodyB25())
                        .foregroundColor(.black)
                    
                    Spacer().frame(height: 5)
                }
                
                Text(message)
                    .font(.body40())
                    .foregroundColor(.black)
            }
            
            Spacer(minLength: 10)
            
            if !closeButtonHidden {
                Button {
                    onCancelTapped()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(style.iconColor)
                }
            }
        }
        .padding()
        .frame(minWidth: 0, maxWidth: width)
        .background(style.backgroundColor)
        .cornerRadius(8)
        .padding(.horizontal, 16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// トースト専用のウィンドウクラス
class ToastWindow: UIWindow {
    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        self.windowLevel = UIWindow.Level.alert + 1
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = true
        self.isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        
        // rootViewControllerのビューを取得
        guard let rootView = self.rootViewController?.view else {
            return hitView == self ? nil : hitView
        }
        
        // トーストエリア内かどうかをチェック
        let convertedPoint = self.convert(point, to: rootView)
        let isInToastArea = isPointInToastArea(convertedPoint, in: rootView)
        
        // トーストエリア外の場合はタッチを透過
        if !isInToastArea {
            return nil
        }
        
        return hitView
    }
    
    private func isPointInToastArea(_ point: CGPoint, in view: UIView) -> Bool {
        // 表示位置の計算と同じロジックを使用
        let fixedTopDistance: CGFloat = 60
        let safeAreaTop = view.safeAreaInsets.top
        let topPosition = max(safeAreaTop + 10, fixedTopDistance)
        
        // トーストの表示エリア
        let toastAreaHeight: CGFloat = 80
        let toastRect = CGRect(
            x: 16,
            y: topPosition,
            width: view.bounds.width - 32,
            height: toastAreaHeight
        )
        
        return toastRect.contains(point)
    }
}

// トースト管理クラス - @MainActorでマーク
@MainActor
class ToastManager: ObservableObject {
    static let shared = ToastManager()
    
    @Published var currentToast: Toast?
    @Published var isVisible: Bool = false
    private var toastWindow: ToastWindow?
    private var workItem: DispatchWorkItem?
    private var toastQueue: [Toast] = []
    private var isProcessing: Bool = false
    
    private init() {}
    
    func showToast(_ toast: Toast) {
        // @MainActorによりメインアクターで実行されることが保証される
        toastQueue.append(toast)
        processNextToast()
    }
    
    private func processNextToast() {
        // 既に処理中、またはキューが空の場合は何もしない
        guard !isProcessing, !toastQueue.isEmpty else { return }
        
        isProcessing = true
        let nextToast = toastQueue.removeFirst()
        
        // 既存のトーストがある場合は即座に非表示にする
        if isVisible {
            // アニメーションなしで即座に非表示
            isVisible = false
            currentToast = nil
            
            // 少し待ってから新しいトーストを表示
            Task {
                try await Task.sleep(nanoseconds: 100_000_000) // 0.1秒
                displayToast(nextToast)
            }
        } else {
            // 既存のトーストがない場合はすぐに表示
            displayToast(nextToast)
        }
    }
    
    private func displayToast(_ toast: Toast) {
        self.currentToast = toast
        self.setupToastWindow()
        
        // 少し遅延してからアニメーションで表示
        Task {
            try await Task.sleep(nanoseconds: 50_000_000) // 0.05秒
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                self.isVisible = true
            }
        }
        
        self.scheduleAutoDismiss(toast)
    }
    
    private func setupToastWindow() {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first else { return }
        
        // 既存のウィンドウがある場合は再利用、ない場合は新規作成
        if toastWindow == nil {
            toastWindow = ToastWindow(windowScene: windowScene)
        }
        
        // HostingControllerを更新
        let hostingController = UIHostingController(
            rootView: ToastWindowView(onDismiss: {
                Task { @MainActor in
                    self.dismissToast()
                }
            })
            .environmentObject(self)
        )
        
        hostingController.view.backgroundColor = UIColor.clear
        toastWindow?.rootViewController = hostingController
        toastWindow?.isHidden = false
        
        // フィードバック
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    private func scheduleAutoDismiss(_ toast: Toast) {
        guard toast.duration > 0 else { return }
        
        workItem?.cancel()
        
        // Taskを使用してタイマーを実装
        Task {
            try await Task.sleep(nanoseconds: UInt64(toast.duration * 1_000_000_000))
            dismissToast()
        }
        
        // workItemの代わりにTaskを保持するプロパティを別途用意するか、
        // ここではシンプルにDispatchWorkItemを維持
        let dispatchTask = DispatchWorkItem {
            Task { @MainActor in
                self.dismissToast()
            }
        }
        
        workItem = dispatchTask
        DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: dispatchTask)
    }
    
    func dismissToast() {
        // 既に非表示の場合は何もしない
        guard isVisible else {
            finishDismissAndProcessNext()
            return
        }
        
        withAnimation(.easeOut(duration: 0.3)) {
            self.isVisible = false
        }
        
        // アニメーション完了後にクリーンアップ
        Task {
            try await Task.sleep(nanoseconds: 350_000_000) // 0.35秒
            self.currentToast = nil
            self.finishDismissAndProcessNext()
        }
        
        workItem?.cancel()
        workItem = nil
    }
    
    private func finishDismissAndProcessNext() {
        isProcessing = false
        
        // キューに次のトーストがある場合は処理
        if !toastQueue.isEmpty {
            Task {
                try await Task.sleep(nanoseconds: 100_000_000) // 0.1秒
                processNextToast()
            }
        } else {
            // キューが空の場合はウィンドウをクリーンアップ
            Task {
                try await Task.sleep(nanoseconds: 200_000_000) // 0.2秒
                if self.toastQueue.isEmpty && !self.isVisible {
                    self.cleanupWindow()
                }
            }
        }
    }
    
    private func cleanupWindow() {
        toastWindow?.isHidden = true
        toastWindow = nil
    }
    
    // キューを全てクリア
    func clearAllToasts() {
        toastQueue.removeAll()
        workItem?.cancel()
        workItem = nil
        
        if isVisible {
            withAnimation(.easeOut(duration: 0.2)) {
                self.isVisible = false
            }
            Task {
                try await Task.sleep(nanoseconds: 250_000_000) // 0.25秒
                self.currentToast = nil
                self.isProcessing = false
                self.cleanupWindow()
            }
        } else {
            isProcessing = false
            cleanupWindow()
        }
    }
}

// ウィンドウ内で表示されるトーストビュー
struct ToastWindowView: View {
    let onDismiss: () -> Void
    @EnvironmentObject var toastManager: ToastManager
    
    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea(.all)
            
            if let toast = toastManager.currentToast {
                VStack {
                    ToastView(
                        style: toast.style,
                        title: toast.title ?? "",
                        message: toast.message,
                        width: min(toast.width, UIScreen.main.bounds.width - 32),
                        closeButtonHidden: toast.closeButtonHidden,
                        onCancelTapped: onDismiss
                    )
                    .offset(y: toastManager.isVisible ? 0 : -100)
                    .opacity(toastManager.isVisible ? 1 : 0)
                    .onTapGesture {
                        // トースト全体をタップで非表示
                        onDismiss()
                    }
                    
                    Spacer()
                }
                .padding(.top, 30)
            }
        }
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: toastManager.isVisible)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: toastManager.currentToast?.message)
    }
}

// 従来のモディファイアも残しつつ、新しいマネージャーを使用
struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    
    func body(content: Content) -> some View {
        content
            .onChange(of: toast) { oldValue, newValue in
                if let newToast = newValue {
                    Task { @MainActor in
                        ToastManager.shared.showToast(newToast)
                        // バインディングをクリア
                        toast = nil
                    }
                }
            }
    }
}

extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}

// より簡単に使用できる拡張メソッド
extension View {
    func showToast(_ toast: Toast) {
        Task { @MainActor in
            ToastManager.shared.showToast(toast)
        }
    }
}

// 使用例のヘルパーメソッド
extension ToastManager {
    func showError(_ message: String, title: String? = nil, duration: Double = 5) {
        let toast = Toast(style: .error, title: title, message: message, duration: duration)
        showToast(toast)
    }
    
    func showSuccess(_ message: String, title: String? = nil, duration: Double = 3) {
        let toast = Toast(style: .success, title: title, message: message, duration: duration)
        showToast(toast)
    }
    
    func showWarning(_ message: String, title: String? = nil, duration: Double = 4) {
        let toast = Toast(style: .warning, title: title, message: message, duration: duration)
        showToast(toast)
    }
    
    func showInfo(_ message: String, title: String? = nil, duration: Double = 3) {
        let toast = Toast(style: .info, title: title, message: message, duration: duration)
        showToast(toast)
    }
}

#Preview {
    ToastView(
        style: .error,
        title: "タイトルが入ります",
        message: "長い長いテキストが入ります長い長いテキストが入ります長い長いテキストが入ります長い長いテキストが入ります") {
    }
}
