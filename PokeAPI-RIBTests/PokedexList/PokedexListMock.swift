//
//  PokedexListMock.swift
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

final class PokedexListInteractableMock: PokedexListInteractable {
    weak var router: PokedexListRouting?
    weak var listener: PokedexListListener?
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
    func updatePokedexList(_ data: [PokeAPI_RIB.Pokedex.Result]) { }
    func searchPokedexList(_ data: [PokeAPI_RIB.Pokedex.Result]) { }
}

final class PokedexListBuildableMock: PokedexListBuildable {
    var buildCalled = false
    func build(withListener listener: PokedexListListener) -> PokedexListRouting {
        buildCalled = true
        return PokedexListRoutingMock()
    }
}

final class PokedexListRoutingMock: PokedexListRouting {
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
