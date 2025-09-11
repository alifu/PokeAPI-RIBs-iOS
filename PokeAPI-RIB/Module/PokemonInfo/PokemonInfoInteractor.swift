//
//  PokemonInfoInteractor.swift
//  PokeAPI-RIB
//
//  Created by Alif on 10/09/25.
//

import RIBs
import RxSwift

protocol PokemonInfoRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol PokemonInfoPresentable: Presentable {
    var listener: PokemonInfoPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    
    func loadPokemonInfo(abilities: [String], stats: [Pokemon.Stats], types: [String], height: Double, weight: Double)
    func loadPokemonDescription(_ description: String)
}

protocol PokemonInfoListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class PokemonInfoInteractor: PresentableInteractor<PokemonInfoPresentable>, PokemonInfoInteractable, PokemonInfoPresentableListener {

    weak var router: PokemonInfoRouting?
    weak var listener: PokemonInfoListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: PokemonInfoPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}

extension PokemonInfoInteractor {
    
    func updatePokemonInfo(abilities: [String], stats: [Pokemon.Stats], types: [String], height: Double, weight: Double) {
        self.presenter.loadPokemonInfo(abilities: abilities, stats: stats, types: types, height: height, weight: weight)
    }
    
    func updatePokemonDescription(_ description: String) {
        self.presenter.loadPokemonDescription(description)
    }
}
