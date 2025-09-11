//
//  ModelDecodingTests.swift
//  PokeAPI-RIBTests
//
//  Created by AI Assistant on 11/09/25.
//

import XCTest
@testable import PokeAPI_RIB

final class ModelDecodingTests: XCTestCase {

    func testDecodePokemonResponse() throws {
        let json = """
        {
          "id": 25,
          "name": "pikachu",
          "abilities": [
            {
              "ability": { "name": "static", "url": "https://pokeapi.co/api/v2/ability/9/" },
              "is_hidden": false,
              "slot": 1
            }
          ],
          "sprites": {
            "other": {
              "official-artwork": {
                "front_default": "https://img.example/pikachu.png"
              }
            }
          },
          "types": [
            { "slot": 1, "type": { "name": "electric", "url": "https://pokeapi.co/api/v2/type/13/" } }
          ],
          "stats": [
            { "base_stat": 35, "effort": 0, "stat": { "name": "hp", "url": "https://pokeapi.co/api/v2/stat/1/" } }
          ],
          "height": 4,
          "weight": 60
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let response = try decoder.decode(Pokemon.Response.self, from: json)

        XCTAssertEqual(response.id, 25)
        XCTAssertEqual(response.name, "pikachu")
        XCTAssertEqual(response.abilities.count, 1)
        XCTAssertEqual(response.abilities.first?.ability.name, "static")
        XCTAssertEqual(response.sprites.other.officialArtwork.frontDefault, "https://img.example/pikachu.png")
        XCTAssertEqual(response.types.first?.type.name, "electric")
        XCTAssertEqual(response.stats.first?.baseStat, 35)
        XCTAssertEqual(response.height, 4)
        XCTAssertEqual(response.weight, 60)
    }

    func testDecodePokemonSpeciesResponse() throws {
        let json = """
        {
          "flavor_text_entries": [
            { "flavor_text": "When several of these POKéMON gather, their electricity could build and cause lightning storms." }
          ]
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let response = try decoder.decode(PokemonSpecies.Response.self, from: json)

        XCTAssertEqual(response.flavorTextEntries.count, 1)
        XCTAssertTrue(response.flavorTextEntries.first?.flavourText.contains("electricity") == true)
    }

    func testDecodePokedexResponse() throws {
        let json = """
        {
          "count": 2,
          "next": null,
          "previous": null,
          "results": [
            { "name": "bulbasaur", "url": "https://pokeapi.co/api/v2/pokemon/1/" },
            { "name": "ivysaur", "url": "https://pokeapi.co/api/v2/pokemon/2/" }
          ]
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let response = try decoder.decode(Pokedex.Response.self, from: json)

        XCTAssertEqual(response.count, 2)
        XCTAssertEqual(response.results.count, 2)
        XCTAssertEqual(response.results.first?.name, "bulbasaur")
        XCTAssertEqual(response.results.first?.url, "https://pokeapi.co/api/v2/pokemon/1/")
    }
}



