//
//  ContentView.swift
//  DnD-App-Example
//
//  Created by AlexG on 6/26/22.
//

import SwiftUI

struct CharacterClassResponse: Codable {
    let count: Int
    let results: [CharacterClass]
}

struct CharacterClass: Identifiable, Codable {
    let index: String
    let name: String
    let url: String
    
    var id: String {
        index
    }
}

#if DEBUG
// MARK: - Example CharacterClass for previews
extension CharacterClass {
    static var example: [CharacterClass] = [
        CharacterClass(index: "barbarian", name: "Barbarian", url: "/api/classes/barbarian"),
        CharacterClass(index: "cleric", name: "Cleric", url: "/api/classes/cleric")
    ]
}
#endif


struct ContentView: View {
    @State var results = [CharacterClass]()
    
    var body: some View {
        NavigationView {
            List(results) { item  in
                Text(item.name)
                    .font(.headline)
            }
            .navigationTitle("Character Classes")
            .task {
                await loadData()
            }
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://www.dnd5eapi.co/api/classes") else {
            print("ERROR: Invalid URL")
            return
        }
        
        let data: Data
        do {
            (data, _) = try await URLSession.shared.data(from: url)
        } catch {
            fatalError("ERROR: Couldn't load \(url)")
        }
        
        do {
            if let decodedResponse = try? JSONDecoder().decode(CharacterClassResponse.self, from: data) {
                results = decodedResponse.results
            } else {
                fatalError("ERROR: Invalid data")
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(results: CharacterClass.example)
    }
}
