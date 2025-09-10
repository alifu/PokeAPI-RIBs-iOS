//
//  PokemonInteractor.swift
//  PokeAPI-RIB
//
//  Created by Alif Phincon on 09/09/25.
//

import Foundation
import RIBs
import RxCocoa
import RxSwift

protocol PokemonRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func attachPokemonBanner() -> PokemonBannerInteractable?
    func attachPokemonInfo() -> PokemonInfoInteractable?
}

protocol PokemonPresentable: Presentable {
    var listener: PokemonPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func changeHeader(with data: Observable<Pokedex.Result?>)
    func changeBackground(with data: Observable<[String]>)
    func loading(_ isLoading: Observable<Bool>)
}

protocol PokemonListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func goBackFromPokemon()
}

final class PokemonInteractor: PresentableInteractor<PokemonPresentable>, PokemonInteractable, PokemonPresentableListener {
    
    weak var router: PokemonRouting?
    weak var listener: PokemonListener?
    
    private let disposeBag = DisposeBag()
    private let dependency: PokemonInteractorDependency
    private var pokemonBannerInteractor: PokemonBannerInteractable?
    private var pokemonInfoInteractor: PokemonInfoInteractable?
    private let isLoading = PublishRelay<Bool>()
    private let types = BehaviorRelay<[String]>(value: [])
    private let about = PublishRelay<String>()
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: PokemonPresentable, dependency: PokemonInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        presenter.loading(isLoading.asObservable())
        presenter.changeBackground(with: types.asObservable())
        presenter.changeHeader(with: dependency.pokemonNavigator.currentRelay.asObservable())
            
        attachPokemonBanner()
        attachPokemonInfo()
        fetchPokemon()
        fetchPokemonSpecies()
        refreshData()
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    // MARK: - Private
    
    private func attachPokemonBanner() {
        // Ask router to attach child and return its interactor reference
        if let child = router?.attachPokemonBanner() {
            child.listener = self
            self.pokemonBannerInteractor = child
        }
    }
    
    private func attachPokemonInfo() {
        // Ask router to attach child and return its interactor reference
        if let child = router?.attachPokemonInfo() {
            child.listener = self
            self.pokemonInfoInteractor = child
        }
    }
    
    private func refreshData() {
        if let current = dependency.pokemonNavigator.currentRelay.value {
            pokemonBannerInteractor?.updatePokemonBanner(with: current)
        }
    }
    
    private func fetchPokemon() {
        guard let `name` = dependency.pokemonNavigator.currentRelay.value?.name else { return }
        isLoading.accept(true)
        if let pokemon = RealmService.shared.getPokemon(withName: name) {
            //                    self.abilities = Array(pokemon.abilities.map {
            //                        String($0.name)
            //                    })
            //                    self.imageURL = pokemon.spritesOther?.officialArtwork ?? ""
            //                    self.stats = Array(pokemon.stats.map { result in
            //                        Pokemon.Stats(
            //                            baseStat: result.baseStat,
            //                            effort: result.effort,
            //                            stat: Pokemon.StatsInfo(name: result.stat, url: "")
            //                        )
            //                    })
            let rawTypes = Array(pokemon.types.map { result in
                String(result.type)
            })
            types.accept(rawTypes)
            //                    self.height = pokemon.height
            //                    self.weight = pokemon.weight
            //                    self.name = pokemon.name
            //                    self.id = Int(pokemon.idPokemon)
            isLoading.accept(false)
        } else {
            APIManager.provider.rx.request(.pokemon(name: name))
                .asObservable()
                .subscribe { [weak self] event in
                    guard let `self` = self else { return }
                    defer { self.isLoading.accept(false) }
                    switch event {
                    case .next(let response):
                        do {
                            let result = try JSONDecoder().decode(Pokemon.Response.self, from: response.data)
                            let rawAbilities = result.abilities
                            let rawSprites = result.sprites
                            let rawStats = result.stats
                            let rawTypes = result.types
                            let rawHeight = result.height
                            let rawWeight = result.weight
                            let rawName = result.name
                            let rawId = result.id
                            
                            //                        self.abilities = abilities.map { $0.ability.name }
                            //                        self.imageURL = sprites.other.officialArtwork.frontDefault
                            //                        self.stats = stats
                            let rawTypesString = rawTypes.map { $0.type.name }
                            self.types.accept(rawTypesString)
                            //                        self.height = Double(height)
                            //                        self.weight = Double(weight)
                            //                        self.name = name
                            //                        self.id = id
                            //
                            RealmService.shared.storePokemon(
                                id: rawId,
                                name: rawName,
                                abilities: rawAbilities,
                                spritesOther: rawSprites,
                                types: rawTypes,
                                weight: rawWeight,
                                height: rawHeight,
                                stats: rawStats
                            )
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
        }
    }
    
    private func fetchPokemonSpecies() {
        guard let `name` = dependency.pokemonNavigator.currentRelay.value?.name else { return }
        isLoading.accept(true)
        if let pokemon = RealmService.shared.getPokemonSpecies(withName: name) {
            let rawAbout = pokemon.flavourTextEntries.first?.flavourText ?? ""
            isLoading.accept(false)
        } else {
            APIManager.provider.rx.request(.pokemonSpecies(name: name))
                .asObservable()
                .subscribe { [weak self] event in
                    guard let `self` = self else { return }
                    defer { self.isLoading.accept(false) }
                    switch event {
                    case .next(let response):
                        do {
                            let result = try JSONDecoder().decode(PokemonSpecies.Response.self, from: response.data)
                            let resultAbout = result.flavorTextEntries.first?.flavourText ?? ""
                            
                            let rawAbout = resultAbout.replacingOccurrences(of: "\n", with: " ")
                            self.about.accept(rawAbout)
                            
                            RealmService.shared.storePokemonSpecies(name: name, flavourTextEntries: result.flavorTextEntries)
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
        }
    }
}

extension PokemonInteractor {
    
    func goback() {
        self.listener?.goBackFromPokemon()
    }
    
    func didClickPrevious() {
        dependency.pokemonNavigator.movePrevious()
        refreshData()
        fetchPokemon()
        fetchPokemonSpecies()
    }
    
    func didClickNext() {
        dependency.pokemonNavigator.moveNext()
        refreshData()
        fetchPokemon()
        fetchPokemonSpecies()
    }
}
