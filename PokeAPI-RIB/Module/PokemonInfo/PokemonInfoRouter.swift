//
//  PokemonInfoRouter.swift
//  PokeAPI-RIB
//
//  Created by Alif Phincon on 10/09/25.
//

import RIBs

protocol PokemonInfoInteractable: Interactable {
    var router: PokemonInfoRouting? { get set }
    var listener: PokemonInfoListener? { get set }
}

protocol PokemonInfoViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class PokemonInfoRouter: ViewableRouter<PokemonInfoInteractable, PokemonInfoViewControllable>, PokemonInfoRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: PokemonInfoInteractable, viewController: PokemonInfoViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
