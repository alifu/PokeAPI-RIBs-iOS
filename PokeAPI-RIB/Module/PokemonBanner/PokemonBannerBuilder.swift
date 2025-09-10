//
//  PokemonBannerBuilder.swift
//  PokeAPI-RIB
//
//  Created by Alif Phincon on 10/09/25.
//

import RIBs

protocol PokemonBannerDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class PokemonBannerComponent: Component<PokemonBannerDependency>, PokemonBannerDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol PokemonBannerBuildable: Buildable {
    func build(withListener listener: PokemonBannerListener) -> PokemonBannerRouting
}

final class PokemonBannerBuilder: Builder<PokemonBannerDependency>, PokemonBannerBuildable {

    override init(dependency: PokemonBannerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: PokemonBannerListener) -> PokemonBannerRouting {
        let component = PokemonBannerComponent(dependency: dependency)
        let viewController = PokemonBannerViewController()
        let interactor = PokemonBannerInteractor(presenter: viewController)
        interactor.listener = listener
        return PokemonBannerRouter(interactor: interactor, viewController: viewController)
    }
}
