//
//  PokedexInteractorTests.swift
//  PokeAPI-RIBTests
//
//  Created by Alif on 11/09/25.
//

@testable import PokeAPI_RIB
import XCTest

final class PokedexInteractorTests: XCTestCase {
    
    private var interactor: PokedexInteractor!
    private var presenter: PokedexPresenterMock!
    private var repository: RealmServiceMock!
    private var api: APIManagerMock!
    
    // TODO: declare other objects and mocks you need as private vars
    
    override func setUp() {
        super.setUp()
        presenter = PokedexPresenterMock()
        repository = RealmServiceMock()
        api = APIManagerMock()
        
        interactor = PokedexInteractor(
            presenter: presenter,
            repository: repository,
            api: api
        )
    }
    
    override func tearDown() {
        interactor = nil
        presenter = nil
        repository = nil
        api = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_exampleObservable_callsRouterOrListener_exampleProtocol() {
        // This is an example of an interactor test case.
        // Test your interactor binds observables and sends messages to router or listener.
    }
    
    func testDidBecomeActive_attachesOffGame() {
        // When
        interactor.didBecomeActive()
        
        // Then
//        XCTAssertTrue(mockRouter.attachOffGameCalled)
    }
}
