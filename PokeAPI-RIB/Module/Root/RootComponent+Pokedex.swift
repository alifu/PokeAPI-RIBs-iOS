//
//  RootComponent+Pokedex.swift
//  PokeAPI-RIB
//
//  Created by Alif on 03/09/25.
//

import RIBs

/// The dependencies needed from the parent scope of RootComponent to provide for the Pokedex scope.
// TODO: Update RootComponentDependency protocol to inherit this protocol.
protocol RootDependencyPokedex: Dependency {
    // TODO: Declare dependencies needed from the parent scope of RootComponent to provide dependencies
    // for the Pokedex scope.
}

extension RootComponent: PokedexDependency {

    // TODO: Implement properties to provide for Pokedex scope.
}
