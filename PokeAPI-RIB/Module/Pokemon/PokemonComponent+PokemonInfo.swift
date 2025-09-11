//
//  PokemonComponent+PokemonInfo.swift
//  PokeAPI-RIB
//
//  Created by Alif on 10/09/25.
//

import RIBs

/// The dependencies needed from the parent scope of Pokemon to provide for the PokemonInfo scope.
// TODO: Update PokemonDependency protocol to inherit this protocol.
protocol PokemonDependencyPokemonInfo: Dependency {
    // TODO: Declare dependencies needed from the parent scope of Pokemon to provide dependencies
    // for the PokemonInfo scope.
}

extension PokemonComponent: PokemonInfoDependency {

    // TODO: Implement properties to provide for PokemonInfo scope.
}
