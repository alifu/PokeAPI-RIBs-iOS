//
//  RootRouterTests.swift
//  PokeAPI-RIBTests
//
//  Created by Alif Phincon on 15/09/25.
//

@testable import PokeAPI_RIB
import XCTest

final class RootRouterTests: XCTestCase {
    
    private var router: RootRouter!
    
    // TODO: declare other objects and mocks you need as private vars
    
    override func setUp() {
        super.setUp()
        
        // TODO: instantiate objects and mocks
    }
    
    // MARK: - Tests
    
    func test_routeToExample_invokesToExampleResult() {
        // This is an example of a router test case.
        // Test your router functions invokes the corresponding builder, attachesChild, presents VC, etc.
    }
    
    func test_openPokedex_invokesRouter() {
        // Given
        let interactor = PokedexInteractableMock()
        let viewController = PokedexViewControllableMock()
        let pokedexListBuilder = PokedexListBuildableMock()
        let pokemonBuilder = PokemonBuildableMock()
        let router = PokedexRouter(
            interactor: interactor,
            viewController: viewController,
            pokedexListBuilder: pokedexListBuilder,
            pokemonBuilder: pokemonBuilder
        )
        
        // When
        router.openPokemon([],
                           withSelectedId: 1,
                           repository: RealmServiceMock(),
                           api: APIManagerMock())
        
        XCTAssertEqual(router.children.count, 1)
        
        // Act
        router.detachPokemon()
        
        // Then
        XCTAssertEqual(router.children.count, 0)
    }
}
