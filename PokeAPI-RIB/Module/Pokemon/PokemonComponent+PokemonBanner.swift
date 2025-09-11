//
//  PokemonComponent+PokemonBanner.swift
//  PokeAPI-RIB
//
//  Created by Alif on 10/09/25.
//

import RIBs

/// The dependencies needed from the parent scope of Pokemon to provide for the PokemonBanner scope.
// TODO: Update PokemonDependency protocol to inherit this protocol.
protocol PokemonDependencyPokemonBanner: Dependency {
    // TODO: Declare dependencies needed from the parent scope of Pokemon to provide dependencies
    // for the PokemonBanner scope.
}

extension PokemonComponent: PokemonBannerDependency {

    // TODO: Implement properties to provide for PokemonBanner scope.
}
