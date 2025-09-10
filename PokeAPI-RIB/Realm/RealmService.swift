//
//  RealmService.swift
//  PokeAPI-SwiftUI
//
//  Created by alif rama on 11/08/25.
//

import Foundation
import RealmSwift

class RealmService {
    
    static let shared = RealmService()
    private var realmInstance: Realm!
    
    private init() {
        configureRealmMigration()
        
        do {
            realmInstance = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }
    
    private func configureRealmMigration() {
        let config = Realm.Configuration(
            schemaVersion: 4,
            migrationBlock: { migration, oldSchemaVersion in
                // TODO: Do Migration
            }
        )
        
        Realm.Configuration.defaultConfiguration = config
    }
    
    var realm: Realm {
        return realmInstance
    }
    
    func storePokedex(_ pokemon: [PokemonEntity]) {
        do {
            try realm.write {
                realm.add(pokemon, update: .modified)
            }
        } catch {
            print("Error storing pokedex: \(error)")
        }
    }
    
    func storePokemon(id: Int, name: String, abilities: [Pokemon.Ability], spritesOther: Pokemon.Sprites, types: [Pokemon.Types], weight: Double, height: Double, stats: [Pokemon.Stats]) {
        do {
            let pokemon = PokemonDetailEntity(id: id, name: name, abilities: abilities, spritesOther: spritesOther, types: types, weight: weight, height: height, stats: stats)
            try realm.write {
                realm.add(pokemon, update: .modified)
            }
        } catch {
            print("Error storing pokemon: \(error)")
        }
    }
    
    func storePokemonSpecies(name: String, flavourTextEntries: [PokemonSpecies.FlavourTextEntry]) {
        do {
            let species = PokemonSpeciesEntity(name: name, from: flavourTextEntries)
            try realm.write {
                realm.add(species, update: .modified)
            }
        } catch {
            print("Error storing pokemon species: \(error)")
        }
    }
    
    func getPokedex(limit: Int, offset: Int = 0) -> [PokemonEntity] {
        let results = realm.objects(PokemonEntity.self)
            .sorted(byKeyPath: "idPokemon", ascending: true)
        return Array(results.dropFirst(offset).prefix(limit))
    }
    
    func getPokemon(withName: String) -> PokemonDetailEntity? {
        return realm.object(ofType: PokemonDetailEntity.self, forPrimaryKey: withName)
    }
    
    func getPokemonSpecies(withName: String) -> PokemonSpeciesEntity? {
        return realm.object(ofType: PokemonSpeciesEntity.self, forPrimaryKey: withName)
    }
}
