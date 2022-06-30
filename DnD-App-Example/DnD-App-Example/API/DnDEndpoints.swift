//
//  DnDEndpoints.swift
//  DnD-App-Example
//
//  Created by AlexG on 6/27/22.
//

import Foundation

// Custom enum similar to Swift Result type with
// added convenice emtpy (inital) and inProgress states
enum AsyncResult<Success> {
    case empty
    case inProgress
    case success(Success)
    case failure(Error)
}

// Helper extension to throw custom error strings. Example:
/*
    func funcThatThrows() throws {
       throw "The URL was malformed"
    }
 */
extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

// The 5th Edition Dungeons and Dragons API
// https://www.dnd5eapi.co
struct DnDEndpoints {
    static let dndApiURLScheme = "https"
    static let dndApiHostString = "www.dnd5eapi.co"
    
    let urlSession = URLSession.shared
    let jsonDecoder = JSONDecoder()
    
    func urlWithPath(pathString: String) throws -> URL {
        var url = URLComponents()
        url.scheme = DnDEndpoints.dndApiURLScheme
        url.host = DnDEndpoints.dndApiHostString
        url.path = pathString
        
        guard let spellURLString = url.string else {
            throw "Invalid string url: \(url)"
        }
        
        guard let url = URL(string: spellURLString) else {
            throw "Could not form the URL."
        }
        
        return url
    }
    
    func characterClasses() async throws -> CharacterClassResponse {
        let url = try urlWithPath(pathString: "/api/classes")
        
        let (data, _) = try await urlSession.data(from: url)
        return try jsonDecoder.decode(CharacterClassResponse.self, from: data)
    }
    
    func classSpells(classIndex: String) async throws -> CharacterSpellsResponse {
        let url = try urlWithPath(pathString: "/api/classes/\(classIndex)/spells")
        
        let (data, _) = try await urlSession.data(from: url)
        return try jsonDecoder.decode(CharacterSpellsResponse.self, from: data)
    }
    
    func spellDetails(spellIndex: String) async throws -> SpellDetailsResponse {
        let url = try urlWithPath(pathString: "/api/spells/\(spellIndex)")
        
        let (data, _) = try await urlSession.data(from: url)
        return try jsonDecoder.decode(SpellDetailsResponse.self, from: data)
    }
}
