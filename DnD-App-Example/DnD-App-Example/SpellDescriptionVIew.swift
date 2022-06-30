//
//  SpellDescriptionVIew.swift
//  DnD-App-Example
//
//  Created by AlexG on 6/27/22.
//

import SwiftUI


struct DescriptionView: View {
    let descriptions: [String]
    var body: some View {
        LazyVStack {
            ForEach(descriptions, id: \.self) { info in
                Text(info)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
        }
    }
}

struct SpellDescriptionView: View {
    let spellIndex: String
    @StateObject var spellDetailsModel = SpellDetailsViewModel()
    
    var body: some View {
        Group {
            switch spellDetailsModel.result {
            case .empty:
                Text("")
            case .inProgress:
                ProgressView()
            case let .success(detailsData):
                DescriptionView(descriptions: detailsData.desc)
            case let .failure(error):
                Text(error.localizedDescription)
            }
        }
        .task {
            await self.spellDetailsModel.spellDetails(spellIndex: self.spellIndex)
        }
    }
}

#if DEBUG
struct CharacterSpellDetailView_Previews: PreviewProvider {
    static let dynamicTypeSizes: [ContentSizeCategory] = [.extraSmall, .large, .extraExtraExtraLarge]

    static var previews: some View {
        
        Group {
            ForEach(dynamicTypeSizes, id: \.self) { sizeCategory in
                DescriptionView(descriptions: SpellDetailsViewModel.example[1].desc)
                    .previewLayout(PreviewLayout.sizeThatFits)
                    .padding()
                    .environment(\.sizeCategory, sizeCategory)
                    .previewDisplayName("\(sizeCategory)")
            }
        }
        
    }
}
#endif
