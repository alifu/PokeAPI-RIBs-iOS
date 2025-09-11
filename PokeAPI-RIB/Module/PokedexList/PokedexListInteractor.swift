//
//  PokedexListInteractor.swift
//  PokeAPI-RIB
//
//  Created by Alif on 04/09/25.
//

import RIBs
import RxCocoa
import RxDataSources
import RxSwift

protocol PokedexListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol PokedexListPresentable: Presentable {
    var listener: PokedexListPresentableListener? { get set }
    func bindPokedexList(_ pokedexList: Observable<[Pokedex.Result]>)
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol PokedexListListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func didLoadMore()
    func selectedPokedex(at index: Int, pokedex: Pokedex.Result)
}

final class PokedexListInteractor: PresentableInteractor<PokedexListPresentable>, PokedexListInteractable, PokedexListPresentableListener {

    weak var router: PokedexListRouting?
    weak var listener: PokedexListListener?
    
    private let dependency: PokedexListDependency
    private let pokedexRelay = BehaviorRelay<[Pokedex.Result]>(value: [])

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: PokedexListPresentable, dependency: PokedexListDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        presenter.bindPokedexList(pokedexRelay.asObservable())
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}

extension PokedexListInteractor {
    
    func didLoadMore() {
        self.listener?.didLoadMore()
    }
    
    func selectedPokedex(at index: Int, data: Pokedex.Result) {
        self.listener?.selectedPokedex(at: index, pokedex: data)
    }
    
    func updatePokedexList(_ data: [Pokedex.Result]) {
        var current = pokedexRelay.value
        current.append(contentsOf: data)
        pokedexRelay.accept(current)
    }
    
    func searchPokedexList(_ data: [Pokedex.Result]) {
        pokedexRelay.accept(data)
    }
}
