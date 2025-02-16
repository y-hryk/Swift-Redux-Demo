//
//  UserScore.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/10/02.
//

import SwiftUI

struct UserScore: Hashable {
    let value: Float
    
    var score: CGFloat {
        floor(CGFloat(value) * 10) / 10
    }
    var toString: String {
        if score >= 10.0 { return "10" }
        return score <= 0.0 ? "NR" : String(format: "%.1f%", score)
    }
    
    var unitText: String {
        return score <= 0.0 ? "" : "/10"
    }
    
    var color: Color {
        if score <= 0.0 {
            return Color.Score.gray
        }
        if score >= 8.0 {
            return Color.Score.green
        } else if score >= 4.0 {
            return Color.Score.yellow
        } else {
            return Color.Score.red
        }
    }
}
