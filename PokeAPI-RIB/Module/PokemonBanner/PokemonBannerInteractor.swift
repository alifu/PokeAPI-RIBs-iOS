//
//  PokemonBannerInteractor.swift
//  PokeAPI-RIB
//
//  Created by Alif Phincon on 10/09/25.
//

import RIBs
import RxSwift

protocol PokemonBannerRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol PokemonBannerPresentable: Presentable {
    var listener: PokemonBannerPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func loadPokemonImage(with urlString: String?)
}

protocol PokemonBannerListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func didClickPrevious()
    func didClickNext()
}

final class PokemonBannerInteractor: PresentableInteractor<PokemonBannerPresentable>, PokemonBannerInteractable, PokemonBannerPresentableListener {

    weak var router: PokemonBannerRouting?
    weak var listener: PokemonBannerListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: PokemonBannerPresentable) {
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

extension PokemonBannerInteractor {
    
    func updatePokemonBanner(with data: Pokedex.Result) {
        self.presenter.loadPokemonImage(with: data.imageURL)
    }
    
    func previousButtonTapped() {
        self.listener?.didClickPrevious()
    }
    
    func nextButtonTapped() {
        self.listener?.didClickNext()
    }
}
