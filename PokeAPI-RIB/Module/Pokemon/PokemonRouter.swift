//
//  PokemonRouter.swift
//  PokeAPI-RIB
//
//  Created by Alif Phincon on 09/09/25.
//

import RIBs

protocol PokemonInteractable: Interactable, PokemonBannerListener, PokemonInfoListener {
    var router: PokemonRouting? { get set }
    var listener: PokemonListener? { get set }
}

protocol PokemonViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func attachPokemonBannerView(viewController: ViewControllable?)
    func attachPokemonInfoView(viewController: ViewControllable?)
}

final class PokemonRouter: ViewableRouter<PokemonInteractable, PokemonViewControllable>, PokemonRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: PokemonInteractable,
        viewController: PokemonViewControllable,
        pokemonBannerBuilder: PokemonBannerBuildable,
        pokemonInfoBuilder: PokemonInfoBuildable
    ) {
        self.pokemonBannerBuilder = pokemonBannerBuilder
        self.pokemonInfoBuilder = pokemonInfoBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachPokemonBanner() -> PokemonBannerInteractable? {
        guard pokemonBanner == nil else { return pokemonBanner?.interactable as? PokemonBannerInteractable }
        let childRouter = pokemonBannerBuilder.build(withListener: interactor)
        self.pokemonBanner = childRouter
        attachChild(childRouter)
        viewController.attachPokemonBannerView(viewController: pokemonBanner?.viewControllable)
        return childRouter.interactable as? PokemonBannerInteractable
    }
    
    func attachPokemonInfo() -> PokemonInfoInteractable? {
        guard pokemonInfo == nil else { return pokemonInfo?.interactable as? PokemonInfoInteractable }
        let childRouter = pokemonInfoBuilder.build(withListener: interactor)
        self.pokemonInfo = childRouter
        attachChild(childRouter)
        viewController.attachPokemonInfoView(viewController: pokemonInfo?.viewControllable)
        return childRouter.interactable as? PokemonInfoInteractable
    }
    
    // MARK: - Private
    
    private let pokemonBannerBuilder: PokemonBannerBuildable
    private var pokemonBanner: PokemonBannerRouting?
    private let pokemonInfoBuilder: PokemonInfoBuildable
    private var pokemonInfo: PokemonInfoRouting?
}
