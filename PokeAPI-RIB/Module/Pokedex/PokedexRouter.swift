//
//  PokedexRouter.swift
//  PokeAPI-RIB
//
//  Created by Alif Phincon on 03/09/25.
//

import RIBs

protocol PokedexInteractable: Interactable, PokedexListListener, PokemonListener {
    var router: PokedexRouting? { get set }
    var listener: PokedexListener? { get set }
}

protocol PokedexViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func attachPokedexListView(viewController: ViewControllable?)
    func openPokemonPage(viewController: ViewControllable?)
}

final class PokedexRouter: ViewableRouter<PokedexInteractable, PokedexViewControllable>, PokedexRouting {
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: PokedexInteractable,
        viewController: PokedexViewControllable,
        pokedexListBuilder: PokedexListBuildable,
        pokemonBuilder: PokemonBuildable
    ) {
        self.pokedexListBuilder = pokedexListBuilder
        self.pokemonBuilder = pokemonBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    func attachChild() -> PokedexListInteractable? {
        guard pokedexList == nil else { return pokedexList?.interactable as? PokedexListInteractable }
        let childRouter = pokedexListBuilder.build(withListener: interactor)
        self.pokedexList = childRouter
        attachChild(childRouter)
        viewController.attachPokedexListView(viewController: pokedexList?.viewControllable)
        return childRouter.interactable as? PokedexListInteractable
    }
    
    func openPokemon(_ pokedex: [Pokedex.Result], withSelectedId id: Int) {
        let pokemonRouter = pokemonBuilder.build(withListener: interactor, results: pokedex, startIndex: id)
        self.pokemon = pokemonRouter
        attachChild(pokemonRouter)
        viewController.openPokemonPage(viewController: pokemon?.viewControllable)
    }
    
    func detachPokemon() {
        if let detach = pokemon {
            detachChild(detach)
            pokemon = nil
        }
    }
    
    // MARK: Private
    
    private let pokedexListBuilder: PokedexListBuildable
    private var pokedexList: PokedexListRouting?
    private let pokemonBuilder: PokemonBuildable
    private var pokemon: PokemonRouting?
    
}
