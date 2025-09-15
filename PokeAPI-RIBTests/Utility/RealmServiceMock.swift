//
//  RealmServiceMock.swift
//  PokeAPI-RIB
//
//  Created by Alif Phincon on 12/09/25.
//

@testable import PokeAPI_RIB
import Foundation
import RxSwift

final class RealmServiceMock: PokedexRepository {
    var storedPokemons: [PokemonEntity] = []
    var pokemonsToReturn: [PokemonEntity] = []
    var storedPokemonSpecies: PokemonSpeciesEntity?
    var pokemonSpeciesToReturn: PokemonSpeciesEntity?
    var storedPokemonDetail: PokemonDetailEntity?
    var pokemonToReturnDetail: PokemonDetailEntity?
    
    func getPokedex(limit: Int, offset: Int) -> [PokemonEntity] {
        return pokemonsToReturn
    }
    
    func storePokedex(_ pokemons: [PokemonEntity]) {
        storedPokemons.append(contentsOf: pokemons)
    }
    
    func getPokemonSpecies(withName: String) -> PokeAPI_RIB.PokemonSpeciesEntity? {
        return pokemonSpeciesToReturn
    }
    
    func storePokemonSpecies(name: String, flavourTextEntries: [PokeAPI_RIB.PokemonSpecies.FlavourTextEntry]) {
        storedPokemonSpecies = PokemonSpeciesEntity(name: name, from: flavourTextEntries)
    }
    
    func getPokemon(withName: String) -> PokeAPI_RIB.PokemonDetailEntity? {
        return pokemonToReturnDetail
    }
    
    func storePokemon(id: Int, name: String, abilities: [PokeAPI_RIB.Pokemon.Ability], spritesOther: PokeAPI_RIB.Pokemon.Sprites, types: [PokeAPI_RIB.Pokemon.Types], weight: Double, height: Double, stats: [PokeAPI_RIB.Pokemon.Stats]) {
        storedPokemonDetail = PokemonDetailEntity(id: id, name: name, abilities: abilities, spritesOther: spritesOther, types: types, weight: weight, height: height, stats: stats)
    }
}
