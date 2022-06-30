//
//  CharacterClassListView.swift
//  DnD-App-Example
//
//  Created by AlexG on 6/26/22.
//

import SwiftUI

struct ClassListView: View {
    let characterClasses: [CharacterClass]
    
    var body: some View {
        List(characterClasses) { charClass  in
            NavigationLink(destination: CharacterSpellView(characterClass: charClass)) {
                    Text(charClass.name)
                        .font(.headline)
            }
        }
    }
}

struct CharacterClassListView: View {
    @StateObject var classesModel = CharacterClassViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                switch classesModel.result {
                case .empty:
                    Text("")
                case .inProgress:
                    ProgressView()
                case let .success(classesResponse):
                    ClassListView(characterClasses: classesResponse.results)
                case let .failure(error):
                    Text(error.localizedDescription)
                }
            }
            .navigationTitle("Character Classes")
            .task {
                await self.classesModel.characterClasses()
            }
        }
        // Fixes LayoutConstraints issues
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#if DEBUG
struct CharacterClassListView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterClassListView(classesModel: CharacterClassViewModel())
        
        ClassListView(characterClasses: CharacterClass.example)
    }
}
#endif
