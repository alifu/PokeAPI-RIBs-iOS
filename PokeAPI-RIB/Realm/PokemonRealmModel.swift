//
//  PokemonRealmModel.swift
//  PokeAPI-SwiftUI
//
//  Created by alif rama on 11/08/25.
//

import Foundation
import RealmSwift

class PokemonEntity: Object {
    @Persisted(primaryKey: true)  var name: String
    @Persisted var idPokemon: Int
    @Persisted var url: String
    
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
}

class PokemonDetailEntity: Object {
    @Persisted(primaryKey: true) var name: String
    @Persisted var idPokemon: Int
    @Persisted var abilities = List<PokemonAbilityEntity>()
    @Persisted var spritesOther: PokemonSpritesOtherEntity?
    @Persisted var stats = List<PokemonStatsEntity>()
    @Persisted var types = List<PokemonTypesEntity>()
    @Persisted var height: Double = 0
    @Persisted var weight: Double = 0
}

class PokemonAbilityEntity: Object {
    @Persisted var name: String = ""
    @Persisted var detailURL: String = ""
    @Persisted var isHidden: Bool = false
    @Persisted var slot: Int = 0
}

class PokemonSpritesOtherEntity: Object {
    @Persisted var officialArtwork: String = ""
}

class PokemonStatsEntity: Object {
    @Persisted var baseStat: Int
    @Persisted var effort: Int
    @Persisted var stat: String
}

class PokemonTypesEntity: Object {
    @Persisted var slot: Int
    @Persisted var type: String
}

extension PokemonAbilityEntity {
    convenience init(from ability: Pokemon.Ability) {
        self.init()
        self.name = ability.ability.name
        self.detailURL = ability.ability.detailURL
        self.isHidden = ability.isHidden
        self.slot = ability.slot
    }
}

extension PokemonDetailEntity {
    convenience init(id: Int, name: String, abilities: [Pokemon.Ability], spritesOther: Pokemon.Sprites, types: [Pokemon.Types], weight: Double, height: Double, stats: [Pokemon.Stats]) {
        self.init()
        self.idPokemon = id
        self.name = name
        self.abilities.append(objectsIn: abilities.map { PokemonAbilityEntity(from: $0) })
        self.spritesOther = PokemonSpritesOtherEntity(officialArtwork: spritesOther.other.officialArtwork.frontDefault)
        self.types.append(objectsIn: types.map { PokemonTypesEntity(from: $0) })
        self.stats.append(objectsIn: stats.map { PokemonStatsEntity(from: $0) })
        self.height = height
        self.weight = weight
    }
}

extension PokemonSpritesOtherEntity {
    convenience init(officialArtwork: String) {
        self.init()
        self.officialArtwork = officialArtwork
    }
}

extension PokemonTypesEntity {
    convenience init(from type: Pokemon.Types) {
        self.init()
        self.slot = type.slot
        self.type = type.type.name
    }
}

extension PokemonStatsEntity {
    convenience init(from stat: Pokemon.Stats) {
        self.init()
        self.baseStat = stat.baseStat
        self.effort = stat.effort
        self.stat = stat.stat.name
    }
}

class PokemonSpeciesEntity: Object {
    @Persisted(primaryKey: true) var name: String
    @Persisted var flavourTextEntries = List<PokemonSpeciesFlavourTextEntity>()
    
    convenience init(name: String, from: [PokemonSpecies.FlavourTextEntry]) {
        self.init()
        self.name = name
        self.flavourTextEntries.append(objectsIn: from.map { PokemonSpeciesFlavourTextEntity(from: $0) })
    }
}

class PokemonSpeciesFlavourTextEntity: Object {
    @Persisted var flavourText: String = ""
    
    convenience init(from: PokemonSpecies.FlavourTextEntry) {
        self.init()
        self.flavourText = from.flavourText
    }
}
