//
//  LaunchesTest.swift
//  SpaceXTests
//
//  Created by Rolando Rodriguez on 5/22/22.
//

@testable import SpaceX
import XCTest

class LaunchesTest: XCTestCase {
    private typealias Resource = Launch.ResourceProvider
    
    func testThatLaunchesCanBeDecoded() throws {
        // Given
        let json = try Resource.json(for: .launchesComplete)
        
        // When
        let launches = try JSONDecoder().decode([Launch].self, from: json)
        let firstLaunch = mockLaunch()
        
        // Then
        
        XCTAssertNotNil(launches[5].id)
        XCTAssertNotNil(launches[5].missionName)
        XCTAssertNotNil(launches[5].date)
        XCTAssertNotNil(launches[5].rocketId)
        XCTAssertNotNil(launches[5].status)
        XCTAssertNotNil(launches[5].missionImageUrl)
        XCTAssertNotNil(launches[5].articleUrl)
        XCTAssertNotNil(launches[5].videoId)
        XCTAssertNotNil(launches[5].wikiUrl)

        XCTAssertEqual(launches[0], firstLaunch)
        XCTAssertEqual(launches.count, 64)
    }
    
    func testThatLaunchesCanBeDecodedWithMinSchema() throws {
        // Given
        let json = try Resource.json(for: .launchesIncomplete)

        // When
        let launches = try JSONDecoder().decode([Launch].self, from: json)

        // Then
        
        XCTAssertNotNil(launches[0].id)
        XCTAssertNotNil(launches[0].missionName)
        XCTAssertNotNil(launches[0].date)
        XCTAssertNotNil(launches[0].rocketId)
        XCTAssertNotNil(launches[0].status)

        
        XCTAssertNil(launches[0].missionImageUrl)
        XCTAssertNil(launches[0].articleUrl)
        XCTAssertNil(launches[0].videoId)
        XCTAssertNil(launches[0].wikiUrl)

        XCTAssertEqual(launches.count, 1)
        XCTAssertEqual(launches[0].status, .undetermined)
    }
    
    private func mockLaunch() -> Launch {
        let date = Date(timeIntervalSince1970: 1143239400)
        
        return Launch(id: "5eb87cd9ffd86e000604b32a", missionName: "FalconSat", date: date, rocketId: "5e9d0d95eda69955f709d1eb", missionImageUrl: URL(string: "https://images2.imgbox.com/3c/0e/T8iJcSN3_o.png"), status: .failure, articleUrl: URL(string:"https://www.space.com/2196-spacex-inaugural-falcon-1-rocket-lost-launch.html"), videoId: "0a_00nJ_Y88", wikiUrl: URL(string: "https://en.wikipedia.org/wiki/DemoSat"))
    }
}

extension Launch {
    enum ResourceProvider {
        enum Schema: String {
            case launchesComplete = "LaunchesComplete"
            case launchesIncomplete = "LaunchesIncomplete"
        }
        
        static func json(for schema: Schema) throws -> Data {
            try BaseResourceProvider.json(forResourceNamed: schema.rawValue)
        }
    }
}
