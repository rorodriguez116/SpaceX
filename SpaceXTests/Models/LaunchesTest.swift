//
//  LaunchesTest.swift
//  SpaceXTests
//
//  Created by Rolando Rodriguez on 5/22/22.
//

@testable import SpaceX
import XCTest

class LaunchesTest: XCTest {
    
    func testThatLaunchesCanBeDecoded() throws {
        // Given
        
        // When
        
        // Then
    }
}

extension Launch {
    enum ResourceProvider {
        enum Schema: String {
            case launchesComplete = "LaunchesMax"
            case launchesIncomplete = "LaunchesIncomplete"
        }
        
        static func json(for schema: Schema) -> Data {
            BaseResourceProvider.json(forResourceNamed: schema.rawValue)
        }
    }
}
