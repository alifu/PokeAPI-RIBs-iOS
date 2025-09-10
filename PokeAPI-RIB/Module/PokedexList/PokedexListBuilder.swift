//
//  PokedexListBuilder.swift
//  PokeAPI-RIB
//
//  Created by Alif Phincon on 04/09/25.
//

import RIBs

protocol PokedexListDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class PokedexListComponent: Component<PokedexListDependency>, PokedexListDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol PokedexListBuildable: Buildable {
    func build(withListener listener: PokedexListListener) -> PokedexListRouting
}

final class PokedexListBuilder: Builder<PokedexListDependency>, PokedexListBuildable {

    override init(dependency: PokedexListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: PokedexListListener) -> PokedexListRouting {
        let component = PokedexListComponent(dependency: dependency)
        let viewController = PokedexListViewController()
        let interactor = PokedexListInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return PokedexListRouter(interactor: interactor, viewController: viewController)
    }
}
