import Foundation
import SwiftUI

struct Movie: Identifiable, Equatable {
    let id: MovieId
    let title: String
    let overview: String
    let rate: UserScore
    let reviewersCount: Int
    let backdropPath: String
    let posterPath: String
    let releaseDateAt: String
    
    var imagePath: String {
        "http://image.tmdb.org/t/p/w780\(backdropPath)"
    }
    
    var posterUrl: String {
        "http://image.tmdb.org/t/p/w780\(posterPath)"
    }
    
    var posterAspectRatio: CGFloat {
        780 / 1112
    }
    
    static func preview() -> Movie {
        Movie(id: MovieId(value: "1"),
              title: "Deadpool & Wolverine",
              overview: " listless Wade Wilson toils away in civilian life with his days as the morally flexible mercenary, Deadpool, behind him. But when his homeworld faces an existential threat, Wade must reluctantly suit-up again with an even more reluctant Wolverine.",
              rate: UserScore(value: 0),
              reviewersCount: 1,
              backdropPath: "/yDHYTfA3R0jFYba16jBB1ef8oIt.jpg",
              posterPath: "mvRqW2z4iBws3CDkCNmojksyr4V.jpg",
              releaseDateAt: "2024-07-24")
    }
}

//extension Movie: Equatable {
//    static func == (lhs: Movie, rhs: Movie) -> Bool {
//        lhs.id.value == rhs.id.value
//    }
//}
