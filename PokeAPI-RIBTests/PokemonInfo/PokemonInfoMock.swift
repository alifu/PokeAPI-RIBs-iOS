//
//  PokemonInfoMock.swift
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

final class PokemonInfoInteractableMock: PokemonInfoInteractable {
    weak var router: PokemonInfoRouting?
    weak var listener: PokemonInfoListener?
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
    func updatePokemonInfo(abilities: [String], stats: [PokeAPI_RIB.Pokemon.Stats], types: [String], height: Double, weight: Double) { }
    func updatePokemonDescription(_ description: String) { }
}
