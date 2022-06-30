//
//  SpellDetailsViewModel.swift
//  DnD-App-Example
//
//  Created by AlexG on 6/27/22.
//

import Foundation
import SwiftUI

struct SpellDetailsResponse: Identifiable, Codable {
    let _id: String
    let index: String
    let desc: [String]
    
    var id: String {
        _id
    }
}

#if DEBUG
// MARK: - SwiftUI preview sample data
extension SpellDetailsViewModel {
    static var example: [SpellDetailsResponse] = [
        SpellDetailsResponse(_id: "62b248818b12b6a08c9fa695", index: "guidance", desc: ["You touch one willing creature. Once before the spell ends, the target can roll a d4 and add the number rolled to one ability check of its choice. It can roll the die before or after making the ability check. The spell then ends."]),
        
        SpellDetailsResponse(_id: "62b248818b12b6a08c9fa6b7", index: "light", desc: ["You touch one object that is no larger than 10 feet in any dimension. Until the spell ends, the object sheds bright light in a 20-foot radius and dim light for an additional 20 feet. The light can be colored as you like. Completely covering the object with something opaque blocks the light. The spell ends if you cast it again or dismiss it as an action.", "If you target an object held or worn by a hostile creature, that creature must succeed on a dexterity saving throw to avoid the spell."])
    ]
}
#endif

@MainActor
class SpellDetailsViewModel: ObservableObject {
    @Published var result: AsyncResult<SpellDetailsResponse> = .empty
    
    func spellDetails(spellIndex: String) async {
        self.result = .inProgress
        
        do {
            let endpoint = DnDEndpoints()
            self.result = .success(try await endpoint.spellDetails(spellIndex: spellIndex))
            
        } catch {
            self.result = .failure(error)
        }
    }
}
