//
//  ScoreView.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/28.
//

import SwiftUI

struct ScoreView: View, Equatable {
    let score: UserScore
    var textColor: Color
    
    init(score: UserScore, textColor: Color = Color.Text.body) {
        self.score = score
        self.textColor = textColor
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4.0)
                .opacity(0.4)
                .foregroundColor(score.color)
            Circle()
                .trim(from: 0.0, to: min(CGFloat(score.value / 10.0), 1))
                .stroke(style: StrokeStyle(lineWidth: 4.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(score.color)
                .rotationEffect(.degrees(-90))

            Text(score.toString)
                .foregroundStyle(textColor)
                .font(.titleLargeS())
            + Text(score.unitText)
                .foregroundStyle(textColor)
                .font(.captionS())
        }
    }
}

#Preview {
    ScoreView(score: UserScore(value: 5.0))
}
