//
//  PokemonBannerMock.swift
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

final class PokemonBannerInteractableMock: PokemonBannerInteractable {
    weak var router: PokemonBannerRouting?
    weak var listener: PokemonBannerListener?
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
    func updatePokemonBanner(with data: String) { }
}
