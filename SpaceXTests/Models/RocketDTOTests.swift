//
//  RocketDTOTests.swift
//  SpaceXTests
//
//  Created by Rolando Rodriguez on 5/23/22.
//

@testable import SpaceX
import XCTest

class RocketDTOTests: XCTestCase {

    func testThatRocketDTOCanBeDecoded() throws {
        // Given
        let json = try Rocket.ResourceProvider.json(for: .rocketsMid)
        let expected = RocketsDTO(docs: [Rocket(id: "5e9d0d95eda69955f709d1eb", name: "Falcon 1", type: "rocket"), Rocket(id: "5e9d0d96eda699382d09d1ee", name: "Starship", type: "rocket")])
        
        // When
        let rockets = try JSONDecoder().decode(RocketsDTO.self, from: json)
        
        // Then
        XCTAssertEqual(expected, rockets)
    }
}
