import SwiftUI

// MARK: - Configuration
struct LoadingConfiguration: Equatable {
    let indicatorColor: Color
    let allowsTapThrough: Bool
    let loadingAreaSize: CGSize
    
    init(
        indicatorColor: Color = .white,
        allowsTapThrough: Bool = false,
        loadingAreaSize: CGSize = CGSize(width: 200, height: 120)
    ) {
        self.indicatorColor = indicatorColor
        self.allowsTapThrough = allowsTapThrough
        self.loadingAreaSize = loadingAreaSize
    }
}

// MARK: - Loading Animation Constants
private enum LoadingAnimation {
    static let showDuration: Double = 0.3
    static let hideDuration: Double = 0.3
    static let forceHideDuration: Double = 0.2
    static let showDelay: Double = 0.05
    static let cleanupDelay: Double = 0.35
    static let forceCleanupDelay: Double = 0.25
    
    static let showAnimation = Animation.easeIn(duration: showDuration)
    static let hideAnimation = Animation.easeOut(duration: hideDuration)
    static let forceHideAnimation = Animation.easeOut(duration: forceHideDuration)
    static let scaleAnimation = Animation.spring(response: 0.6, dampingFraction: 0.8)
}

// MARK: - Loading View
struct LoadingIndicatorView: View {
    let configuration: LoadingConfiguration
    
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(
                    CircularProgressViewStyle(tint: configuration.indicatorColor)
                )
        }
    }
}

// MARK: - Loading Window
final class LoadingWindow: UIWindow {
    private let configuration: LoadingConfiguration
    
    init(windowScene: UIWindowScene, configuration: LoadingConfiguration) {
        self.configuration = configuration
        super.init(windowScene: windowScene)
        setupWindow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupWindow() {
        windowLevel = UIWindow.Level.alert + 2
        backgroundColor = UIColor.clear
        isUserInteractionEnabled = true
        isHidden = false
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        
        guard let rootView = rootViewController?.view else {
            return hitView
        }
        
        if configuration.allowsTapThrough {
            let convertedPoint = convert(point, to: rootView)
            let isInLoadingArea = isPointInLoadingArea(convertedPoint, in: rootView)
            
            if !isInLoadingArea {
                return nil
            }
        }
        
        return hitView == self ? rootView : hitView
    }
    
    private func isPointInLoadingArea(_ point: CGPoint, in view: UIView) -> Bool {
        let centerX = view.bounds.width / 2
        let centerY = view.bounds.height / 2
        
        let loadingRect = CGRect(
            x: centerX - configuration.loadingAreaSize.width / 2,
            y: centerY - configuration.loadingAreaSize.height / 2,
            width: configuration.loadingAreaSize.width,
            height: configuration.loadingAreaSize.height
        )
        
        return loadingRect.contains(point)
    }
}

// MARK: - Loading Manager
@MainActor
final class LoadingManager: ObservableObject {
    static let shared = LoadingManager()
    
    @Published private(set) var isVisible: Bool = false
    @Published private(set) var currentConfiguration: LoadingConfiguration = LoadingConfiguration()
    
    private var loadingWindow: LoadingWindow?
    private var showCount: Int = 0
    
    private init() {}
    
    func showLoading(configuration: LoadingConfiguration = LoadingConfiguration()) {
        showCount += 1
        currentConfiguration = configuration
        
        guard !isVisible else { return }
        
        setupLoadingWindow(with: configuration)
        
        Task {
            try? await Task.sleep(nanoseconds: UInt64(LoadingAnimation.showDelay * 1_000_000_000))
            
            withAnimation(LoadingAnimation.showAnimation) {
                isVisible = true
            }
        }
    }
    
    func hideLoading() {
        showCount = max(0, showCount - 1)
        
        guard showCount == 0 else { return }
        
        withAnimation(LoadingAnimation.hideAnimation) {
            isVisible = false
        }
        
        Task {
            try? await Task.sleep(nanoseconds: UInt64(LoadingAnimation.cleanupDelay * 1_000_000_000))
            
            if showCount == 0 {
                cleanupWindow()
            }
        }
    }
    
    func forceHideLoading() {
        showCount = 0
        
        withAnimation(LoadingAnimation.forceHideAnimation) {
            isVisible = false
        }
        
        Task {
            try? await Task.sleep(nanoseconds: UInt64(LoadingAnimation.forceCleanupDelay * 1_000_000_000))
            cleanupWindow()
        }
    }
    
    private func setupLoadingWindow(with configuration: LoadingConfiguration) {
        guard let windowScene = findActiveWindowScene() else { return }
        
        cleanupWindow()
        
        loadingWindow = LoadingWindow(windowScene: windowScene, configuration: configuration)
        
        let hostingController = UIHostingController(
            rootView: LoadingWindowContentView()
                .environmentObject(self)
        )
        
        hostingController.view.backgroundColor = UIColor.clear
        loadingWindow?.rootViewController = hostingController
        loadingWindow?.isHidden = false
    }
    
    private func cleanupWindow() {
        loadingWindow?.isHidden = true
        loadingWindow = nil
    }
    
    private func findActiveWindowScene() -> UIWindowScene? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
            ?? UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first
    }
}

// MARK: - Loading Window Content View
struct LoadingWindowContentView: View {
    @EnvironmentObject private var loadingManager: LoadingManager
    
    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea(.all)
            
            if loadingManager.isVisible {
                LoadingIndicatorView(configuration: loadingManager.currentConfiguration)
                    .scaleEffect(loadingManager.isVisible ? 1 : 0.8)
                    .opacity(loadingManager.isVisible ? 1 : 0)
                    .animation(LoadingAnimation.scaleAnimation, value: loadingManager.isVisible)
            }
        }
    }
}

// MARK: - View Modifier
struct LoadingOverlayModifier: ViewModifier {
    @Binding var isLoading: Bool
    let configuration: LoadingConfiguration
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                handleLoadingStateChange()
            }
            .onChange(of: isLoading) { _, _ in
                handleLoadingStateChange()
            }
            .onDisappear {
                LoadingManager.shared.hideLoading()
            }
    }
    
    private func handleLoadingStateChange() {
        if isLoading {
            LoadingManager.shared.showLoading(configuration: configuration)
        } else {
            LoadingManager.shared.hideLoading()
        }
    }
}

// MARK: - View Extensions
extension View {
    func loadingOverlay(
        isLoading: Binding<Bool>,
        configuration: LoadingConfiguration = LoadingConfiguration()
    ) -> some View {
        modifier(LoadingOverlayModifier(isLoading: isLoading, configuration: configuration))
    }
    
    func loadingOverlay(
        isLoading: Binding<Bool>,
        allowsTapThrough: Bool
    ) -> some View {
        let configuration = LoadingConfiguration(allowsTapThrough: allowsTapThrough)
        return loadingOverlay(isLoading: isLoading, configuration: configuration)
    }
}
