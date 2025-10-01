//
//  PersonView.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/10/02.
//

import SwiftUI

struct PersonView: View {
    let person: AsyncValue<Person>
    var body: some View {
        switch person {
        case .data(let data):
            content(person: data)
        case .loading:
            content(person: Person.preview(), isLoading: true)
        case .error:
            content(person: Person.preview(), isLoading: true)
        }
    }
    
    private func content(person: Person, isLoading: Bool = false) -> some View {
        HStack(alignment: .top, spacing: 0.0) {
            NetworkImageView(
                imageUrl: person.profileUrl,
                aspectRatio: person.profileImageAspectRatio,
                size: CGSize(width: 80, height: 80)
            )
            .cornerRadius(8.0)
            .padding(8)
            VStack(alignment: .leading, spacing: 10.0) {
                Text(person.name)
                    .font(.title50())
                Text("Birthday")
                    .font(.title25())
                Text("\(person.birthday)")
                    .font(.body45())
                if !person.biography.isEmpty {
                    Text("Biography")
                        .font(.title25())
                    Text("\(person.biography)")
                        .font(.body45())
                }
            }
            .padding([.vertical, .trailing], 8)
            Spacer()
        }
        .redacted(reason: isLoading ? .placeholder : [])
        .background(Color.Background.main)
        .frame(maxWidth: .infinity)
        .padding(8)
    }
}

#Preview {
    PersonView(person: .loading)
}
