//
//  CharacterSpellView.swift
//  DnD-App-Example
//
//  Created by AlexG on 6/26/22.
//

import SwiftUI

struct SpellView: View {
    let spells: [CharacterSpell]
    
    var body: some View {
        VStack {
            if (spells.count == 0) {
                Text("No spells found.")
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            } else {
                ForEach(spells) { spell in
                    Text(spell.name)
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    SpellDescriptionView(spellIndex: spell.index)
                }
            }
        }
    }
}

struct CharacterSpellView: View {
    let characterClass: CharacterClass
    @StateObject var spellsModel = CharacterSpellViewModel()
    @State private var query = ""
    
    var body: some View {
        ScrollView {
            Group {
                switch spellsModel.result {
                case .empty:
                    Text("")
                case .inProgress:
                    ProgressView()
                case let .success(spellsResponse):
                    SpellView(spells: spellsResponse.results)
                case let .failure(error):
                    Text(error.localizedDescription)
                }
            }
        }
        .searchable(text: $query)
        .onChange(of: query) { newQuery in
            Task {
                await spellsModel.search(matching: query)
            }
        }
        .task {
            await self.spellsModel.classSpells(classIndex: characterClass.index)
        }
        .navigationTitle(characterClass.name)
    }
    
}

#if DEBUG
struct CharacterSpellView_Previews: PreviewProvider {
    static let dynamicTypeSizes: [ContentSizeCategory] = [.extraSmall, .large, .extraExtraExtraLarge]
    
    static var previews: some View {
        Group {
            SpellView(spells: [])
                .previewLayout(PreviewLayout.sizeThatFits)
            
            ForEach(dynamicTypeSizes, id: \.self) { sizeCategory in
                SpellView(spells: CharacterSpell.example)
                    .previewLayout(PreviewLayout.sizeThatFits)
                    .padding()
                    .environment(\.sizeCategory, sizeCategory)
                    .previewDisplayName("\(sizeCategory)")
            }
        }
    }
}
#endif
