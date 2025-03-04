//
//  CreditList.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/28.
//

import Foundation

struct CreditList {
    let actors: [Actor]
    let director: [Creator]
    let screenplay: [Creator]
    let creators: [Creator]
    
    static func loading() -> CreditList {
        CreditList(
            actors: [
                Actor(id: PersonId(value: "0"), castId: 1, name: "aaaaaaaaa", characterName: "bbbbbbbbbb", profilePath: ""),
                Actor(id: PersonId(value: "1"), castId: 2, name: "aaaaaaaaa", characterName: "bbbbbbbbbb", profilePath: ""),
                Actor(id: PersonId(value: "2"), castId: 3, name: "aaaaaaaaa", characterName: "bbbbbbbbbb", profilePath: ""),
                Actor(id: PersonId(value: "3"), castId: 4, name: "aaaaaaaaa", characterName: "bbbbbbbbbb", profilePath: "")
            ],
            director: [],
            screenplay: [],
            creators: [])
    }
    
    static func preview() -> CreditList {
        CreditList(
            actors: [
                Actor(id: PersonId(value: "0"), castId: 1, name: "aaaaaaaaa", characterName: "bbbbbbbbbb", profilePath: "/tpEczFclQZeKAiCeKZZ0adRvtfz.jpg"),
                Actor(id: PersonId(value: "1"), castId: 2, name: "aaaaaaaaa", characterName: "bbbbbbbbbb", profilePath: "/tpEczFclQZeKAiCeKZZ0adRvtfz.jpg"),
                Actor(id: PersonId(value: "2"), castId: 3, name: "aaaaaaaaa", characterName: "bbbbbbbbbb", profilePath: "/tpEczFclQZeKAiCeKZZ0adRvtfz.jpg"),
                Actor(id: PersonId(value: "3"), castId: 4, name: "aaaaaaaaa", characterName: "bbbbbbbbbb", profilePath: "/tpEczFclQZeKAiCeKZZ0adRvtfz.jpg")
            ],
            director: [],
            screenplay: [],
            creators: [])
    }
}
