//
//  PokedexInteractor.swift
//  PokeAPI-RIB
//
//  Created by Alif on 03/09/25.
//

import RIBs
import RxSwift
import Moya
import RxMoya
import RxCocoa
import Foundation

protocol PokedexRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func attachChild() -> PokedexListInteractable?
    func openPokemon(_ pokedex: [Pokedex.Result], withSelectedId id: Int)
    func detachPokemon()
}

protocol PokedexPresentable: Presentable {
    var listener: PokedexPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func loading(_ isLoading: Observable<Bool>)
}

protocol PokedexListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class PokedexInteractor: PresentableInteractor<PokedexPresentable>, PokedexInteractable, PokedexPresentableListener {
    
    weak var router: PokedexRouting?
    weak var listener: PokedexListener?
    
    private let disposeBag = DisposeBag()
    private let limit = 24
    private var offset = 0
    private var pokedexListInteractor: PokedexListInteractable?
    private var pokedex: [Pokedex.Result] = []
    private var isLoading = PublishRelay<Bool>()
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: PokedexPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        presenter.loading(isLoading.asObservable())
        attachPokedexList()
        fetchPokedex()
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func fetchPokedex() {
        isLoading.accept(true)
        let pokedex = RealmService.shared.getPokedex(limit: limit, offset: offset)
        if pokedex.isEmpty {
            APIManager.provider.rx.request(.pokemonList(limit: limit, offset: offset))
                .asObservable()
                .subscribe { [weak self] event in
                    guard let `self` = self else { return }
                    defer { self.isLoading.accept(false) }
                    switch event {
                    case .next(let response):
                        do {
                            let data = try JSONDecoder().decode(Pokedex.Response.self, from: response.data)
                            self.offset += self.limit
                            let pokemonEntities = data.results.map { result in
                                let entity = PokemonEntity()
                                entity.idPokemon = Int(result.id ?? "") ?? 0
                                entity.name = result.name
                                entity.url = result.url
                                return entity
                            }
                            RealmService.shared.storePokedex(pokemonEntities)
                            self.pokedex.append(contentsOf: data.results)
                            self.pokedexListInteractor?.updatePokedexList(data.results)
                        } catch(let error) {
                            print("❌ Error:", error)
                        }
                    case .error(let error):
                        print("❌ Error:", error)
                    case .completed:
                        print("✅ Completed")
                    }
                }
                .disposed(by: disposeBag)
        } else {
            let localPokemon = pokedex.map { result in
                let entity = Pokedex.Result(from: result)
                return entity
            }
            self.offset += self.limit
            self.pokedex.append(contentsOf: localPokemon)
            self.pokedexListInteractor?.updatePokedexList(localPokemon)
            isLoading.accept(false)
        }
    }
    
    // MARK: - Private
    
    private func attachPokedexList() {
        // Ask router to attach child and return its interactor reference
        if let child = router?.attachChild() {
            child.listener = self
            self.pokedexListInteractor = child
        }
    }
}

extension PokedexInteractor {
    
    func didLoadMore() {
        fetchPokedex()
    }
    
    func selectedPokedex(at index: Int, pokedex: Pokedex.Result) {
        self.router?.openPokemon(self.pokedex, withSelectedId: index)
    }
    
    func goBackFromPokemon() {
        self.router?.detachPokemon()
    }
}
