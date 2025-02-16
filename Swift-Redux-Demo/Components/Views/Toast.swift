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
                Text(title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .hidden(title.isEmpty)
                
                Spacer().frame(height: 5)
                    .hidden(title.isEmpty)
                
                Text(message)
                    .font(.caption2)
                    .foregroundColor(.black)
            }
            
            Spacer(minLength: 10)
            
            Button {
                onCancelTapped()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(style.iconColor)
            }
            .hidden(closeButtonHidden)
        }
        .padding()
        .frame(minWidth: 0, maxWidth: width)
        .background(style.backgroundColor)
        .cornerRadius(8)
        .padding(.horizontal, 16)
    }
}

struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainToastView()
                        .offset(y: 32)
                }.animation(.spring(), value: toast)
            )
            .onChange(of: toast, { oldValue, newValue in
                showToast()
            })
    }
    
    @ViewBuilder func mainToastView() -> some View {
        if let toast = toast {
            VStack {
                ToastView(
                    style: toast.style,
                    title: toast.title ?? "",
                    message: toast.message,
                    width: toast.width
                ) {
                    dismissToast()
                }
                Spacer()
            }
        }
    }
    
    private func showToast() {
        guard let toast = toast else { return }
        
        UIImpactFeedbackGenerator(style: .light)
            .impactOccurred()
        
        if toast.duration > 0 {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                dismissToast()
            }
            
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }
    
    private func dismissToast() {
        withAnimation {
            toast = nil
        }
        
        workItem?.cancel()
        workItem = nil
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
