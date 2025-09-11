//
//  UtilityTests.swift
//  PokeAPI-RIBTests
//
//  Created by AI Assistant on 11/09/25.
//

import XCTest
@testable import PokeAPI_RIB

final class UtilityTests: XCTestCase {

    func testStatsDisplayNameMapping() {
        let cases: [(String, String)] = [
            ("hp", "HP"),
            ("attack", "ATK"),
            ("defense", "DEF"),
            ("special-attack", "SATK"),
            ("special-defense", "SDEF"),
            ("speed", "SPD"),
            ("unknown", "-")
        ]

        for (input, expected) in cases {
            let info = Pokemon.StatsInfo(name: input, url: "")
            XCTAssertEqual(info.displayName(), expected, "Mapping failed for \(input)")
        }
    }
}



