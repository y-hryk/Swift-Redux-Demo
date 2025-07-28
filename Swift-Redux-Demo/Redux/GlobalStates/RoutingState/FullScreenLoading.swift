import SwiftUI

// ローディング設定構造体
struct LoadingConfig: Equatable {
    var indicatorColor: Color = .white
    var allowsTapThrough: Bool = false
}

// ローディングビュー
struct LoadingView: View {
    let config: LoadingConfig
    
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: config.indicatorColor))
        }
    }
}

// ローディング専用ウィンドウ
class LoadingWindow: UIWindow {
    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        self.windowLevel = UIWindow.Level.alert + 2
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
            return hitView
        }
        
        // LoadingManagerの設定を確認
        let config = LoadingManager.shared.currentConfig
        
        // タップ透過が許可されている場合のみ透過処理
        if config.allowsTapThrough {
            // ローディングエリア外の場合はタッチを透過
            let convertedPoint = self.convert(point, to: rootView)
            let isInLoadingArea = isPointInLoadingArea(convertedPoint, in: rootView)
            
            if !isInLoadingArea {
                return nil
            }
        }
        
        // タップ透過が許可されていない場合、またはローディングエリア内の場合は通常処理
        return hitView == self ? rootView : hitView
    }
    
    private func isPointInLoadingArea(_ point: CGPoint, in view: UIView) -> Bool {
        // ローディングビューのおおよそのサイズを計算
        let loadingSize = CGSize(width: 200, height: 120)
        let centerX = view.bounds.width / 2
        let centerY = view.bounds.height / 2
        
        let loadingRect = CGRect(
            x: centerX - loadingSize.width / 2,
            y: centerY - loadingSize.height / 2,
            width: loadingSize.width,
            height: loadingSize.height
        )
        
        return loadingRect.contains(point)
    }
}

// ローディング管理クラス
class LoadingManager: ObservableObject {
    static let shared = LoadingManager()
    
    @Published var isVisible: Bool = false
    @Published var currentConfig: LoadingConfig = LoadingConfig()
    private var loadingWindow: LoadingWindow?
    private var showCount: Int = 0 // 表示要求のカウント
    
    private init() {}
    
    func showLoading(config: LoadingConfig = LoadingConfig()) {
        DispatchQueue.main.async {
            self.showCount += 1
            self.currentConfig = config
            
            // 既に表示中の場合は設定のみ更新
            if self.isVisible {
                return
            }
            
            self.setupLoadingWindow()
            
            // 少し遅延してからアニメーションで表示
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                withAnimation(.easeIn(duration: 0.3)) {
                    self.isVisible = true
                }
            }
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.showCount = max(0, self.showCount - 1)
            
            // まだ表示要求が残っている場合は非表示にしない
            if self.showCount > 0 {
                return
            }
            
            withAnimation(.easeOut(duration: 0.3)) {
                self.isVisible = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                if self.showCount == 0 {
                    self.cleanupWindow()
                }
            }
        }
    }
    
    // 強制的に全て非表示
    func forceHideLoading() {
        DispatchQueue.main.async {
            self.showCount = 0
            
            withAnimation(.easeOut(duration: 0.2)) {
                self.isVisible = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.cleanupWindow()
            }
        }
    }
    
    private func setupLoadingWindow() {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first else { return }
        
        // 既存のウィンドウを削除してから新規作成
        if loadingWindow != nil {
            loadingWindow?.isHidden = true
            loadingWindow = nil
        }
        
        loadingWindow = LoadingWindow(windowScene: windowScene)
        
        let hostingController = UIHostingController(
            rootView: LoadingWindowView()
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
}

// ウィンドウ内で表示されるローディングビュー
struct LoadingWindowView: View {
    @EnvironmentObject var loadingManager: LoadingManager
    
    var body: some View {
        ZStack {
            // 背景オーバーレイ（タップを無効化）
            Color.clear
                .ignoresSafeArea(.all)
                .animation(.easeInOut(duration: 0.3), value: loadingManager.isVisible)
            
            if loadingManager.isVisible {
                LoadingView(config: loadingManager.currentConfig)
                    .scaleEffect(loadingManager.isVisible ? 1 : 0.8)
                    .opacity(loadingManager.isVisible ? 1 : 0)
            }
        }
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: loadingManager.isVisible)
    }
}

// Modifier実装
struct LoadingModifier: ViewModifier {
    @Binding var isLoading: Bool
    let config: LoadingConfig
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if isLoading {
                    LoadingManager.shared.showLoading(config: config)
                }
            }
            .onChange(of: isLoading) { oldValue, newValue in
                if newValue {
                    LoadingManager.shared.showLoading(config: config)
                } else {
                    LoadingManager.shared.hideLoading()
                }
            }
            .onDisappear {
                LoadingManager.shared.hideLoading()
            }
    }
}

// View Extension
extension View {
    func loadingOverlay(
        isLoading: Binding<Bool>,
        config: LoadingConfig = LoadingConfig()
    ) -> some View {
        self.modifier(LoadingModifier(isLoading: isLoading, config: config))
    }
    
    // 便利メソッド
    func loadingOverlay(
        isLoading: Binding<Bool>,
        allowsTapThrough: Bool
    ) -> some View {
        let config = LoadingConfig(allowsTapThrough: allowsTapThrough)
        return self.modifier(LoadingModifier(isLoading: isLoading, config: config))
    }
}
