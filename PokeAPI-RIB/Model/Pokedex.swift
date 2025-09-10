//
//  PokedexModel.swift
//  PokeAPI-SwiftUI
//
//  Created by alif rama on 10/08/25.
//

import Foundation
import RxDataSources

struct Pokedex {
    
    struct Request {
        let limit: Int
        let offset: Int
    }
    
    struct Response: Decodable {
        let count: Int
        let next: String?
        let previous: String?
        let results: [Result]
    }
    
    struct Result: Identifiable, Decodable {
        let url: String
        let name: String
        
        var id: String? {
            return url
                .split(separator: "/")
                .last
                .map(String.init)
        }
        
        var imageURL: String? {
            guard let id = id else { return nil }
            return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
        }
        
        init(url: String, name: String) {
            self.name = name
            self.url = url
        }
        
        init(from pokemon: PokemonEntity) {
            self.name = pokemon.name
            self.url = pokemon.url
        }
    }
}

struct SectionOfPokedex {
    var header: String
    var items: [Pokedex.Result]
}

extension SectionOfPokedex: SectionModelType {
    init(original: SectionOfPokedex, items: [Pokedex.Result]) {
        self = original
        self.items = items
    }
}
