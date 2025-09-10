//
//  PokemonInfoBuilder.swift
//  PokeAPI-RIB
//
//  Created by Alif Phincon on 10/09/25.
//

import RIBs

protocol PokemonInfoDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class PokemonInfoComponent: Component<PokemonInfoDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol PokemonInfoBuildable: Buildable {
    func build(withListener listener: PokemonInfoListener) -> PokemonInfoRouting
}

final class PokemonInfoBuilder: Builder<PokemonInfoDependency>, PokemonInfoBuildable {

    override init(dependency: PokemonInfoDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: PokemonInfoListener) -> PokemonInfoRouting {
        let component = PokemonInfoComponent(dependency: dependency)
        let viewController = PokemonInfoViewController()
        let interactor = PokemonInfoInteractor(presenter: viewController)
        interactor.listener = listener
        return PokemonInfoRouter(interactor: interactor, viewController: viewController)
    }
}
