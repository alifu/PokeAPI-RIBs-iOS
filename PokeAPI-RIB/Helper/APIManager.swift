//
//  APIManager.swift
//  PokeAPI-RIB
//
//  Created by Alif on 04/09/25.
//

import Foundation
import Moya
import RxMoya
import RxSwift

enum PokeAPI {
    case pokemon(name: String)
    case pokemonSpecies(name: String)
    case pokemonList(limit: Int, offset: Int)
}

extension PokeAPI: TargetType {
    var baseURL: URL { URL(string: "https://pokeapi.co/api/v2")! }
    
    var path: String {
        switch self {
        case .pokemon(let name):
            return "/pokemon/\(name.lowercased())"
        case .pokemonSpecies(let name):
            return "/pokemon-species/\(name.lowercased())"
        case .pokemonList:
            return "/pokemon"
        }
    }
    
    var method: Moya.Method { .get }
    
    var sampleData: Data { Data() }
    
    var task: Task {
        switch self {
        case .pokemon:
            return .requestPlain
        case .pokemonSpecies:
            return .requestPlain
        case .pokemonList(let limit, let offset):
            return .requestParameters(
                parameters: ["limit": limit, "offset": offset],
                encoding: URLEncoding.default
            )
        }
    }
    
    var headers: [String : String]? { ["Content-Type": "application/json"] }
}

protocol PokemonAPI {
    func fetchPokedex(limit: Int, offset: Int) -> Single<Pokedex.Response>
    func fetchPokemon(name: String) -> Single<Pokemon.Response>
    func fetchPokemonSpecies(name: String) -> Single<PokemonSpecies.Response>
}

struct APIManager {
    
    static let shared = APIManager()
    static let provider = MoyaProvider<PokeAPI>()
    
    private init() {}
}

extension APIManager: PokemonAPI {
    
    func fetchPokedex(limit: Int, offset: Int) -> Single<Pokedex.Response> {
        return APIManager.provider.rx
            .request(.pokemonList(limit: limit, offset: offset))
            .map(Pokedex.Response.self)
    }
    
    func fetchPokemon(name: String) -> Single<Pokemon.Response> {
        return APIManager.provider.rx
            .request(.pokemon(name: name))
            .map(Pokemon.Response.self)
    }
    
    func fetchPokemonSpecies(name: String) -> Single<PokemonSpecies.Response> {
        return APIManager.provider.rx
            .request(.pokemonSpecies(name: name))
            .map(PokemonSpecies.Response.self)
    }
}
