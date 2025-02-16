import SwiftUI

struct CircularProgressBar: View {
    @Binding var progress: CGFloat
    let color: Color

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 8.0)
                .opacity(0.3)
                .foregroundColor(color)
            Circle()
                .trim(from: 0.0, to: min(progress, 1))
                .stroke(style: StrokeStyle(lineWidth: 8.0, lineCap: .round, lineJoin: .round))
                .animation(.easeInOut, value: progress)
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270.0))
            Text(String(format: "%.0f%%", min(progress, 1.0) * 100.0))
                .font(.titleS())
                .animation(.easeInOut, value: progress)
        }
    }
}

#Preview {
    CircularProgressBar(progress: .constant(0.3), color: .orange)
}
