//
//  PokedexListRouter.swift
//  PokeAPI-RIB
//
//  Created by Alif Phincon on 04/09/25.
//

import RIBs

protocol PokedexListInteractable: Interactable {
    var router: PokedexListRouting? { get set }
    var listener: PokedexListListener? { get set }
    
    func updatePokedexList(_ data: [Pokedex.Result])
}

protocol PokedexListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class PokedexListRouter: ViewableRouter<PokedexListInteractable, PokedexListViewControllable>, PokedexListRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: PokedexListInteractable, viewController: PokedexListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
