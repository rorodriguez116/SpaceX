//
//  RocketTests.swift
//  SpaceXTests
//
//  Created by Rolando Rodriguez on 5/22/22.
//

@testable import SpaceX
import XCTest

class RocketTests: XCTestCase {
    private typealias Resource = Rocket.ResourceProvider

    func testThatRocketCanBeDecoded() throws {
        // Given
        let json = try Resource.json(for: .rocketsComplete)
        
        // When
        let rockets = try JSONDecoder().decode([Rocket].self, from: json)
        let firstRocket = mockLaunch()
        
        // Then
        
        XCTAssertNotNil(rockets[0].id)
        XCTAssertNotNil(rockets[0].name)
        XCTAssertNotNil(rockets[0].type)

        XCTAssertEqual(rockets[0], firstRocket)
        
    }
    
    private func mockLaunch() -> Rocket {
        return Rocket(id: "5e9d0d95eda69955f709d1eb", name: "Falcon 1", type: "rocket")
    }
}

extension Rocket {
    enum ResourceProvider {
        enum Schema: String {
            case rocketsComplete = "RocketsComplete"
        }
        
        static func json(for schema: Schema) throws -> Data {
            try BaseResourceProvider.json(forResourceNamed: schema.rawValue)
        }
    }
}
