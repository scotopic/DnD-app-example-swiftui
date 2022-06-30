//
//  CharacterSpellViewModel.swift
//  DnD-App-Example
//
//  Created by AlexG on 6/27/22.
//

import Foundation

struct CharacterSpellsResponse: Codable {
    let count: Int
    let results: [CharacterSpell]
}

struct CharacterSpell: Identifiable, Codable {
    let index: String
    let name: String
    let url: String
    
    var id: String {
        index
    }
}

#if DEBUG
// MARK: - for SwiftUI previews
extension CharacterSpell {
    static var example: [CharacterSpell] = [
        CharacterSpell(index: "guidance", name: "Guidance", url: "/api/spells/guidance"),
        CharacterSpell(index: "light", name: "Light", url: "/api/spells/light")
    ]
}

#endif

@MainActor
class CharacterSpellViewModel: ObservableObject {
    @Published var result: AsyncResult<CharacterSpellsResponse> = .empty
    private var cache = CharacterSpellsResponse(count: 0, results: [])
    
    func classSpells(classIndex: String) async {
        self.result = .inProgress
        
        do {
            let endpoint = DnDEndpoints()
            let charSpellsResponse = try await endpoint.classSpells(classIndex: classIndex)
            self.cache = charSpellsResponse
            self.result = .success(charSpellsResponse)
        } catch {
            self.result = .failure(error)
        }
    }
    
    func search(matching: String) async {
        if matching.isEmpty {
            self.result = .success(self.cache)
        } else {
            self.result = .success(search(spellResponse: self.cache, query: matching))
        }
    }
    
    func search(spellResponse: CharacterSpellsResponse, query: String) -> CharacterSpellsResponse {
        let spells: [CharacterSpell] = spellResponse.results
        let found = spells.filter { $0.name.contains(query) }
        
        return CharacterSpellsResponse(count: 0, results: found)
    }
}
