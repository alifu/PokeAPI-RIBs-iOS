//
//  PokedexMock.swift
//  PokeAPI-RIB
//
//  Created by Alif Phincon on 12/09/25.
//

@testable import PokeAPI_RIB
import Foundation
import RIBs
import RxSwift
import RxCocoa
import XCTest

final class PokedexPresenterMock: PokedexPresentable {
    var listener: PokedexPresentableListener?
    var loadingObservable: Observable<Bool>?
    func loading(_ isLoading: Observable<Bool>) {
        loadingObservable = isLoading
    }
}

final class PokedexBuildableMock: PokedexBuildable {
    var buildCalled = false
    func build(withListener listener: PokedexListener) -> PokedexRouting {
        buildCalled = true
        return PokedexRoutingMock()
    }
}

final class PokedexViewControllableMock: PokedexViewControllable {
    func attachPokedexListView(viewController: (any RIBs.ViewControllable)?) { }
    func openPokemonPage(viewController: (any RIBs.ViewControllable)?) { }
    var uiviewController: UIViewController = UIViewController()
}

final class PokedexInteractableMock: PokedexInteractable {
    weak var router: PokedexRouting?
    weak var listener: PokedexListener?
    var isActive: Bool = false
    var isActiveStream: Observable<Bool> {
        return Observable.just(isActive)
    }
    func activate() {
        isActive = true
    }
    func deactivate() {
        isActive = false
    }
    func didLoadMore() { }
    func selectedPokedex(at index: Int, pokedex: PokeAPI_RIB.Pokedex.Result) { }
    func goBackFromPokemon() { }
}

final class PokedexRoutingMock: PokedexRouting {
    // MARK: - Custom PokedexRouting methods
    
    var attachChildCalled = false
    var openPokemonCalled = false
    var detachPokemonCalled = false
    
    var attachChildReturnValue: PokedexListInteractable? = PokedexListInteractableMock()
    
    func attachChild() -> PokedexListInteractable? {
        attachChildCalled = true
        return attachChildReturnValue
    }
    
    func openPokemon(
        _ pokedex: [Pokedex.Result],
        withSelectedId id: Int,
        repository: PokedexRepository,
        api: PokemonAPI
    ) {
        openPokemonCalled = true
    }
    
    func detachPokemon() {
        detachPokemonCalled = true
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
