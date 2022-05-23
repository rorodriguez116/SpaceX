//
//  RocketMatcher.swift
//  SpaceXTests
//
//  Created by Rolando Rodriguez on 5/22/22.
//

@testable import SpaceX
import XCTest

class RocketMatcherTests: XCTestCase {

    func testThatRocketsAreMatchedToLaunches() throws {
        // Given
        let launches = try getLaunchesDataMin()
        let rockets = try getRockets()
        let expectations = [
            Launch(id: "5eb87cdcffd86e000604b32e", missionName: "RazakSat", date: Date(timeIntervalSince1970: 1247456100), rocketId: "5e9d0d95eda69955f709d1eb", rocketName: "Falcon 1", rocketType: "rocket", missionImageUrl: nil, status: .success, articleUrl: nil, videoId: nil, wikiUrl: nil),
            Launch(id: "5eb87ce1ffd86e000604b333", missionName: "CRS-2", date: Date(timeIntervalSince1970: 1362165000), rocketId: "5e9d0d95eda69973a809d1ec", rocketName: "Falcon 9", rocketType: "rocket", missionImageUrl: nil, status: .success, articleUrl: nil, videoId: nil, wikiUrl: nil)
        ]
        
        // When
        let matched = RocketMatcher.matchRocketsToLaunches(rockets: rockets, launches: launches)
        
        // Then
        XCTAssertEqual(matched.count, 2)
        XCTAssertEqual(expectations, matched)
    }

    private func getLaunchesDataMin() throws -> [Launch] {
        let json = try Launch.ResourceProvider.json(for: .launchesMin)
        let launches = try JSONDecoder().decode([Launch].self, from: json)
        return launches.sorted { $0.date < $1.date }
    }

    private func getRockets() throws -> [Rocket] {
        let json = try Rocket.ResourceProvider.json(for: .rocketsComplete)
        let rockets = try JSONDecoder().decode([Rocket].self, from: json)
        return rockets
    }
    
}
