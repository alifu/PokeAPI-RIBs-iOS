//
//  PokemonInteractor.swift
//  PokeAPI-RIB
//
//  Created by Alif on 09/09/25.
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
    
    private let repository: PokedexRepository
    private let api: PokemonAPI
    private let disposeBag = DisposeBag()
    private let dependency: PokemonInteractorDependency
    private var pokemonBannerInteractor: PokemonBannerInteractable?
    private var pokemonInfoInteractor: PokemonInfoInteractable?
    private let isLoading = PublishRelay<Bool>()
    private let abilities = BehaviorRelay<[String]>(value: [])
    private let imageUrl = BehaviorRelay<String>(value: "")
    private let stats = BehaviorRelay<[Pokemon.Stats]>(value: [])
    private let types = BehaviorRelay<[String]>(value: [])
    private let about = BehaviorRelay<String>(value: "")
    private let height = BehaviorRelay<Double>(value: 0)
    private let weight = BehaviorRelay<Double>(value: 0)
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: PokemonPresentable,
        dependency: PokemonInteractorDependency,
        repository: PokedexRepository,
        api: PokemonAPI
    ) {
        self.dependency = dependency
        self.repository = repository
        self.api = api
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
        pokemonBannerInteractor?.updatePokemonBanner(with: imageUrl.value)
        pokemonInfoInteractor?.updatePokemonInfo(
            abilities: abilities.value,
            stats: stats.value,
            types: types.value,
            height: height.value,
            weight: weight.value)
    }
    
    private func fetchPokemon() {
        guard let `name` = dependency.pokemonNavigator.currentRelay.value?.name else { return }
        isLoading.accept(true)
        if let pokemon = repository.getPokemon(withName: name) {
            let rawAbilities = Array(pokemon.abilities.map {
                String($0.name)
            })
            abilities.accept(rawAbilities)
            let rawImageURL = pokemon.spritesOther?.officialArtwork ?? ""
            imageUrl.accept(rawImageURL)
            let rawStats = Array(pokemon.stats.map { result in
                Pokemon.Stats(
                    baseStat: result.baseStat,
                    effort: result.effort,
                    stat: Pokemon.StatsInfo(name: result.stat, url: "")
                )
            })
            stats.accept(rawStats)
            let rawTypes = Array(pokemon.types.map { result in
                String(result.type)
            })
            types.accept(rawTypes)
            let rawHeight = pokemon.height
            height.accept(rawHeight)
            let rawWeight = pokemon.weight
            weight.accept(rawWeight)
            isLoading.accept(false)
            refreshData()
        } else {
            
            api.fetchPokemon(name: name)
                .subscribe(
                    onSuccess: { [weak self] response in
                        guard let `self` = self else { return }
                        defer {
                            self.isLoading.accept(false)
                            self.refreshData()
                        }
                        
                        let rawAbilities = response.abilities
                        let rawSprites = response.sprites
                        let rawStats = response.stats
                        let rawTypes = response.types
                        let rawHeight = response.height
                        let rawWeight = response.weight
                        let rawName = response.name
                        let rawId = response.id
                        
                        let abilitiesString = rawAbilities.map { $0.ability.name }
                        self.abilities.accept(abilitiesString)
                        self.imageUrl.accept(rawSprites.other.officialArtwork.frontDefault)
                        self.stats.accept(rawStats)
                        let rawTypesString = rawTypes.map { $0.type.name }
                        self.types.accept(rawTypesString)
                        self.height.accept(Double(rawHeight))
                        self.weight.accept(Double(rawWeight))

                        repository.storePokemon(
                            id: rawId,
                            name: rawName,
                            abilities: rawAbilities,
                            spritesOther: rawSprites,
                            types: rawTypes,
                            weight: rawWeight,
                            height: rawHeight,
                            stats: rawStats
                        )
                    },
                    onFailure: { [weak self] error in
                        guard let `self` = self else { return }
                        self.isLoading.accept(false)
                        print("❌ API Error:", error)
                    }
                )
                .disposed(by: disposeBag)
        }
    }
    
    private func fetchPokemonSpecies() {
        guard let `name` = dependency.pokemonNavigator.currentRelay.value?.name else { return }
        isLoading.accept(true)
        if let pokemon = repository.getPokemonSpecies(withName: name) {
            let rawAbout = pokemon.flavourTextEntries.first?.flavourText ?? ""
            about.accept(rawAbout.replacingOccurrences(of: "\n", with: " "))
            isLoading.accept(false)
            pokemonInfoInteractor?.updatePokemonDescription(about.value)
        } else {
            api.fetchPokemonSpecies(name: name)
                .subscribe(
                    onSuccess: { [weak self] response in
                        guard let `self` = self else { return }
                        defer {
                            self.isLoading.accept(false)
                            self.pokemonInfoInteractor?.updatePokemonDescription(self.about.value)
                        }
                        
                        let resultAbout = response.flavorTextEntries.first?.flavourText ?? ""
                        
                        let rawAbout = resultAbout.replacingOccurrences(of: "\n", with: " ")
                        self.about.accept(rawAbout)
                        
                        repository.storePokemonSpecies(name: name, flavourTextEntries: response.flavorTextEntries)
                    },
                    onFailure: { [weak self] error in
                        guard let `self` = self else { return }
                        self.isLoading.accept(false)
                        print("❌ API Error:", error)
                    }
                )
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
        fetchPokemon()
        fetchPokemonSpecies()
    }
    
    func didClickNext() {
        dependency.pokemonNavigator.moveNext()
        fetchPokemon()
        fetchPokemonSpecies()
    }
}
