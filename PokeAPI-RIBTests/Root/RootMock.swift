//
//  RootMock.swift
//  PokeAPI-RIB
//
//  Created by Alif Phincon on 15/09/25.
//

@testable import PokeAPI_RIB
import RIBs
import RxSwift
import XCTest

final class RootPresentableMock: RootPresentable {
    var listener: RootPresentableListener?
}

final class RootRoutingMock: RootRouting {
    var children: [any RIBs.Routing] = []
    private let lifecycleSubject = PublishSubject<RouterLifecycle>()
    var lifecycle: Observable<RouterLifecycle> {
        lifecycleSubject.asObservable()
    }
    var viewControllable: ViewControllable = ViewControllableMock()
    var interactable: Interactable = InteractableMock()
    var routeToPokedexCalled = false
    func routeToPokedex() { routeToPokedexCalled = true }
    func load() { }
    func attachChild(_ child: any RIBs.Routing) { }
    func detachChild(_ child: any RIBs.Routing) { }
}

final class RootListenerMock: RootListener {
    var didFinishRootCalled = false
    func didFinishRoot() { didFinishRootCalled = true }
}

final class ViewControllableMock: ViewControllable {
    var pushViewControllerCalled = false
    var presentedViewController: ViewControllable?
    var uiviewController: UIViewController = UIViewController()
    func present(_ viewController: ViewControllable, animated: Bool) {
        presentedViewController = viewController
    }
    func dismiss(animated: Bool) { }
    func pushViewController(_ viewController: ViewControllable, animated: Bool) {
        pushViewControllerCalled = true
        presentedViewController = viewController
    }
    func popViewController(animated: Bool) { }
}

final class InteractableMock: Interactable {
    weak var router: Routing?
    weak var listener: AnyObject?
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
}
