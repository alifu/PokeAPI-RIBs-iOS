//
//  AppDependency.swift
//  PokeAPI-RIB
//
//  Created by Alif on 03/09/25.
//

import RIBs

class AppComponent: Component<EmptyDependency>, RootDependency {

    init() {
        super.init(dependency: EmptyComponent())
    }
}
