//
//  APIManagerMock.swift
//  PokeAPI-RIB
//
//  Created by Alif Phincon on 12/09/25.
//

@testable import PokeAPI_RIB
import RxSwift
import Foundation

final class APIManagerMock: PokemonAPI {
    
    var responsePokedex: Pokedex.Response?
    var responsePokemon: Pokemon.Response?
    var responsePokemonSpecies: PokemonSpecies.Response?
    var shouldFail = false
    
    func fetchPokedex(limit: Int, offset: Int) -> Single<Pokedex.Response> {
        if shouldFail {
            return .error(NSError(domain: "test", code: -1))
        }
        return .just(responsePokedex ?? Pokedex.Response(count: 0, next: nil, previous: nil, results: []))
    }
    
    func fetchPokemon(name: String) -> RxSwift.Single<PokeAPI_RIB.Pokemon.Response> {
        if shouldFail {
            return .error(NSError(domain: "test", code: -1))
        }
        return .just(responsePokemon ?? Pokemon.Response(
            id: 0,
            name: "",
            abilities: [],
            sprites: Pokemon.Sprites(
                other: Pokemon.SpritesOther(
                    officialArtwork: Pokemon.OfficialArtwork(
                        frontDefault: ""))),
            types: [],
            stats: [],
            height: 0.0,
            weight: 0.0))
    }
    
    func fetchPokemonSpecies(name: String) -> RxSwift.Single<PokeAPI_RIB.PokemonSpecies.Response> {
        if shouldFail {
            return .error(NSError(domain: "test", code: -1))
        }
        return .just(responsePokemonSpecies ?? PokemonSpecies.Response(flavorTextEntries: []))
    }
}
