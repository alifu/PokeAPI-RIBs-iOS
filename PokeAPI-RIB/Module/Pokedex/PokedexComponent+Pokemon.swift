//
//  PokedexComponent+Pokemon.swift
//  PokeAPI-RIB
//
//  Created by Alif on 09/09/25.
//

import RIBs

/// The dependencies needed from the parent scope of Pokedex to provide for the Pokemon scope.
// TODO: Update PokedexDependency protocol to inherit this protocol.
protocol PokedexDependencyPokemon: Dependency {
    // TODO: Declare dependencies needed from the parent scope of Pokedex to provide dependencies
    // for the Pokemon scope
    var pokemonNavigator: PokemonNavigator { get }
}

extension PokedexComponent: PokemonDependency {
    
    // TODO: Implement properties to provide for Pokemon scope.
}
