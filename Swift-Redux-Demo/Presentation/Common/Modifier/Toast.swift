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
        
        guard let rootView = self.rootViewController?.view else {
            return hitView == self ? nil : hitView
        }
        
        let convertedPoint = self.convert(point, to: rootView)
        let isInToastArea = isPointInToastArea(convertedPoint, in: rootView)
        
        if !isInToastArea {
            return nil
        }
        
        return hitView
    }
    
    private func isPointInToastArea(_ point: CGPoint, in view: UIView) -> Bool {
        let fixedTopDistance: CGFloat = 60
        let safeAreaTop = view.safeAreaInsets.top
        let topPosition = max(safeAreaTop + 10, fixedTopDistance)
        
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

@MainActor
class ToastManager: ObservableObject {
    static let shared = ToastManager()
    
    @Published var currentToast: Toast?
    @Published var isVisible: Bool = false
    private var toastWindow: ToastWindow?
    private var toastQueue: [Toast] = []
    private var isProcessing: Bool = false
    private var dismissTask: Task<Void, Never>?
    
    private init() {}
    
    func showToast(_ toast: Toast) {
        toastQueue.append(toast)
        processNextToast()
    }
    
    private func processNextToast() {
        guard !isProcessing, !toastQueue.isEmpty else { return }
        
        isProcessing = true
        let nextToast = toastQueue.removeFirst()
        
        dismissTask?.cancel()
        dismissTask = nil
        
        if isVisible {
            dismissTask = Task { @MainActor in
                withAnimation(.easeOut(duration: 0.2)) {
                    self.isVisible = false
                }
                
                try? await Task.sleep(nanoseconds: 250_000_000) // 0.25sec
                
                guard !Task.isCancelled else { return }
                
                await self.displayToast(nextToast)
            }
        } else {
            dismissTask = Task { @MainActor in
                await self.displayToast(nextToast)
            }
        }
    }
    
    private func displayToast(_ toast: Toast) async {
        guard !Task.isCancelled else { return }
        
        self.currentToast = toast
        self.setupToastWindow()
        
        try? await Task.sleep(nanoseconds: 50_000_000) // 0.05sec
        
        guard !Task.isCancelled else { return }
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            self.isVisible = true
        }
        
        self.scheduleAutoDismiss(toast)
    }
    
    private func setupToastWindow() {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first else { return }
        
        if toastWindow == nil {
            toastWindow = ToastWindow(windowScene: windowScene)
        }
        
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
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    private func scheduleAutoDismiss(_ toast: Toast) {
        guard toast.duration > 0 else { return }
        
        dismissTask?.cancel()
        
        dismissTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(toast.duration * 1_000_000_000))
            
            guard !Task.isCancelled else { return }
            
            await self.dismissToast()
        }
    }
    
    func dismissToast() async {
        guard isVisible else {
            await finishDismissAndProcessNext()
            return
        }
        
        withAnimation(.easeOut(duration: 0.3)) {
            self.isVisible = false
        }
        
        try? await Task.sleep(nanoseconds: 350_000_000) // 0.35sec
        
        guard !Task.isCancelled else { return }
        
        self.currentToast = nil
        await self.finishDismissAndProcessNext()
    }
    
    func dismissToast() {
        Task { @MainActor in
            await self.dismissToast()
        }
    }
    
    private func finishDismissAndProcessNext() async {
        isProcessing = false
        
        if !toastQueue.isEmpty {
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1sec
            
            guard !Task.isCancelled else { return }
            
            processNextToast()
        } else {
            try? await Task.sleep(nanoseconds: 200_000_000) // 0.2sec
            
            guard !Task.isCancelled else { return }
            
            if self.toastQueue.isEmpty && !self.isVisible {
                self.cleanupWindow()
            }
        }
    }
    
    private func cleanupWindow() {
        toastWindow?.isHidden = true
        toastWindow = nil
    }
    
    func clearAllToasts() {
        toastQueue.removeAll()
        dismissTask?.cancel()
        dismissTask = nil
        
        if isVisible {
            withAnimation(.easeOut(duration: 0.2)) {
                self.isVisible = false
            }
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 250_000_000)
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
                        onDismiss()
                    }
                    
                    Spacer()
                }
                .padding(.top, 30)
            }
        }
    }
}

struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    
    func body(content: Content) -> some View {
        content
            .onChange(of: toast) { oldValue, newValue in
                if let newToast = newValue {
                    Task { @MainActor in
                        ToastManager.shared.showToast(newToast)
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

#Preview {
    ToastView(
        style: .error,
        title: "タイトルが入ります",
        message: "長い長いテキストが入ります長い長いテキストが入ります長い長いテキストが入ります長い長いテキストが入ります") {
    }
}
