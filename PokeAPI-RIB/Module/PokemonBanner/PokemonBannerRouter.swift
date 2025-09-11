//
//  PokemonBannerRouter.swift
//  PokeAPI-RIB
//
//  Created by Alif on 10/09/25.
//

import RIBs

protocol PokemonBannerInteractable: Interactable {
    var router: PokemonBannerRouting? { get set }
    var listener: PokemonBannerListener? { get set }
    
    func updatePokemonBanner(with data: String)
}

protocol PokemonBannerViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class PokemonBannerRouter: ViewableRouter<PokemonBannerInteractable, PokemonBannerViewControllable>, PokemonBannerRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: PokemonBannerInteractable, viewController: PokemonBannerViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
