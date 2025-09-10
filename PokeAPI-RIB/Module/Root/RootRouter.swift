//
//  RootRouter.swift
//  PokeAPI-RIB
//
//  Created by Alif Phincon on 03/09/25.
//

import RIBs
import UIKit

protocol RootInteractable: Interactable, PokedexListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func attachPokedexView(viewController: ViewControllable?)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: RootInteractable,
        viewController: RootViewControllable,
        pokedexBuilder: PokedexBuildable
    ) {
        self.pokedexBuilder = pokedexBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
        launchPokedex()
    }
    
    // MARK: Private
    
    private let pokedexBuilder: PokedexBuildable
    
    private var pokedex: ViewableRouting?
    
    private func launchPokedex() {
        let pokedex = pokedexBuilder.build(withListener: interactor)
        self.pokedex = pokedex
        attachChild(pokedex)
        
        let navController = UINavigationController(rootViewController: pokedex.viewControllable.uiviewController)
        let navWrapper = NavigationControllerViewControllable(navController)
        
        viewController.attachPokedexView(viewController: navWrapper)
    }
}
