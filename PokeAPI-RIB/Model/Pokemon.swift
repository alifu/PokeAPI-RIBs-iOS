//
//  PokemonModel.swift
//  PokeAPI-SwiftUI
//
//  Created by alif rama on 11/08/25.
//

import Foundation

struct Pokemon {
    
    struct Request {
        let id: String
    }
    
    struct Response: Decodable {
        let id: Int
        let name: String
        let abilities: [Ability]
        let sprites: Sprites
        let types: [Types]
        let stats: [Stats]
        let height: Double
        let weight: Double
    }

    struct Ability: Decodable {
        let ability: AbilityInfo
        let isHidden: Bool
        let slot: Int

        enum CodingKeys: String, CodingKey {
            case ability
            case isHidden = "is_hidden"
            case slot
        }
    }

    struct AbilityInfo: Decodable {
        let name: String
        let detailURL: String

        enum CodingKeys: String, CodingKey {
            case name
            case detailURL = "url"
        }
    }
    
    struct Sprites: Decodable {
        let other: SpritesOther
        
        enum CodingKeys: String, CodingKey {
            case other
        }
    }
    
    struct SpritesOther: Decodable {
        let officialArtwork: OfficialArtwork
        
        enum CodingKeys: String, CodingKey {
            case officialArtwork = "official-artwork"
        }
    }
    
    struct OfficialArtwork: Decodable {
        let frontDefault: String
        
        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }
    
    struct Types: Decodable {
        let slot: Int
        let type: TypesInfo
    }
    
    struct TypesInfo: Decodable {
        let name: String
        let url: String
    }
    
    struct Stats: Decodable {
        let baseStat: Int
        let effort: Int
        let stat: StatsInfo
        
        enum CodingKeys: String, CodingKey {
            case baseStat = "base_stat"
            case effort
            case stat
        }
    }
    
    struct StatsInfo: Decodable {
        let name: String
        let url: String
        
        func displayName() -> String {
            if name.lowercased() == "hp" {
                return "HP"
            } else if name.lowercased() == "attack" {
                return "ATK"
            } else if name.lowercased() == "defense" {
                return "DEF"
            } else if name.lowercased() == "special-attack" {
                return "SATK"
            } else if name.lowercased() == "special-defense" {
                return "SDEF"
            } else if name.lowercased() == "speed" {
                return "SPD"
            } else {
                return "-"
            }
        }
    }
}

struct PokemonSpecies {
    
    struct Request {
        let id: String
    }
    
    struct Response: Decodable {
        let flavorTextEntries: [FlavourTextEntry]
        
        enum CodingKeys: String, CodingKey {
            case flavorTextEntries = "flavor_text_entries"
        }
    }
    
    struct FlavourTextEntry: Decodable {
        let flavourText: String
        
        enum CodingKeys: String, CodingKey {
            case flavourText = "flavor_text"
        }
    }
}
