//
//  CharacterClassListViewModel.swift
//  DnD-App-Example
//
//  Created by AlexG on 6/27/22.
//

import Foundation

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
// MARK: - for SwfitUI previews
extension CharacterClass {
    static var example: [CharacterClass] = [
        CharacterClass(index: "barbarian", name: "Barbarian", url: "/api/classes/barbarian"),
        CharacterClass(index: "cleric", name: "Cleric", url: "/api/classes/cleric")
    ]
}
#endif

@MainActor
class CharacterClassViewModel: ObservableObject {
    @Published var result: AsyncResult<CharacterClassResponse> = .empty
    
    func characterClasses() async {
        self.result = .inProgress
        
        do {
            let endpoint = DnDEndpoints()
            self.result = .success(try await endpoint.characterClasses())
        } catch {
            self.result = .failure(error)
        }
    }
}

