//
//  PokedexComponent+PokedexList.swift
//  PokeAPI-RIB
//
//  Created by Alif Phincon on 04/09/25.
//

import RIBs

/// The dependencies needed from the parent scope of Pokedex to provide for the PokedexList scope.
// TODO: Update PokedexDependency protocol to inherit this protocol.
protocol PokedexDependencyPokedexList: Dependency {
    // TODO: Declare dependencies needed from the parent scope of Pokedex to provide dependencies
    // for the PokedexList scope.
}

extension PokedexComponent: PokedexListDependency {

    // TODO: Implement properties to provide for PokedexList scope.
}
