//
//  PokemonNavigator.swift
//  PokeAPI-RIB
//
//  Created by Alif on 09/09/25.
//

import Foundation
import RxCocoa
import RxSwift

final class PokemonNavigator {
    
    private let allResults: [Pokedex.Result]
    
    let currentRelay: BehaviorRelay<Pokedex.Result?>
    
    init(results: [Pokedex.Result], startIndex: Int = 0) {
        self.allResults = results
        let start = results.indices.contains(startIndex) ? results[startIndex] : nil
        self.currentRelay = BehaviorRelay(value: start)
    }
    
    func moveNext() {
        guard
            let current = currentRelay.value,
            let index = allResults.firstIndex(where: { $0.id == current.id }),
            index + 1 < allResults.count
        else { return }
        
        currentRelay.accept(allResults[index + 1])
    }
    
    func movePrevious() {
        guard
            let current = currentRelay.value,
            let index = allResults.firstIndex(where: { $0.id == current.id }),
            index - 1 >= 0
        else { return }
        
        currentRelay.accept(allResults[index - 1])
    }
}

