//
//  PokemonMock.swift
//  PokeAPI-RIB
//
//  Created by Alif Phincon on 15/09/25.
//

@testable import PokeAPI_RIB
import Foundation
import RIBs
import RxSwift
import RxCocoa
import XCTest

final class PokemonBuildableMock: PokemonBuildable {
    var buildCalled = false
    func build(withListener listener: any PokeAPI_RIB.PokemonListener, results: [PokeAPI_RIB.Pokedex.Result], startIndex: Int, repository: any PokeAPI_RIB.PokedexRepository, api: any PokeAPI_RIB.PokemonAPI) -> any PokeAPI_RIB.PokemonRouting {
        buildCalled = true
        return PokemonRoutingMock()
    }
}

final class PokemonRoutingMock: PokemonRouting {
    var detachCalled = false
    // MARK: - Custom PokemonRouting methods
    
    var attachChildPokemonBannerCalled = false
    var attachChildPokemonInfoCalled = false
    var attachChildPokemonBannerReturnValue: PokemonBannerInteractable? = PokemonBannerInteractableMock()
    var attachChildPokemonInfoReturnValue: PokemonInfoInteractable? = PokemonInfoInteractableMock()
    func attachPokemonBanner() -> (any PokeAPI_RIB.PokemonBannerInteractable)? {
        attachChildPokemonBannerCalled = true
        return attachChildPokemonBannerReturnValue
    }
    func attachPokemonInfo() -> (any PokeAPI_RIB.PokemonInfoInteractable)? {
        attachChildPokemonInfoCalled = true
        return attachChildPokemonInfoReturnValue
    }
    
    // MARK: - Child routing management
    
    var children: [Routing] = []
    var attachChildParam: Routing?
    var detachChildParam: Routing?
    
    func attachChild(_ child: Routing) {
        children.append(child)
        attachChildParam = child
    }
    
    func detachChild(_ child: Routing) {
        children.removeAll { $0 === child }
        detachChildParam = child
    }
    
    // MARK: - Lifecycle
    
    private let lifecycleSubject = PublishSubject<RouterLifecycle>()
    var lifecycle: Observable<RouterLifecycle> {
        lifecycleSubject.asObservable()
    }
    
    // MARK: - ViewableRouting requirements
    
    var viewControllable: ViewControllable = ViewControllableMock()
    var interactable: Interactable = InteractableMock()
    
    // MARK: - Tracking load/cleanup
    
    var loadCalled = false
    var cleanupCalled = false
    
    func load() {
        loadCalled = true
        lifecycleSubject.onNext(.didLoad)
    }
    
    func cleanupViews() {
        cleanupCalled = true
    }
}
