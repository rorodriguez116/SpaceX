//
//  LaunchFilterTest.swift
//  SpaceXTests
//
//  Created by Rolando Rodriguez on 5/22/22.
//

@testable import SpaceX
import XCTest

class LaunchFilterTest: XCTestCase {
    
    func testFilteringBySingleYearSelection() throws {
        let launches = try getLaunchesData()
        let expectation = [Launch(id: "5eb87cd9ffd86e000604b32a", missionName: "FalconSat", date: Date(timeIntervalSince1970: 1143239400), rocketId: "5e9d0d95eda69955f709d1eb", missionImageUrl: URL(string: "https://images2.imgbox.com/3c/0e/T8iJcSN3_o.png"), status: .failure, articleUrl: URL(string: "https://www.space.com/2196-spacex-inaugural-falcon-1-rocket-lost-launch.html"), videoId: "0a_00nJ_Y88", wikiUrl: URL(string: "https://en.wikipedia.org/wiki/DemoSat"))]
        
        let filteredResults = LaunchFilter.applySortAndFilters(launches: launches, status: .all, years: [2006], sort: .forward)
        
        XCTAssertEqual(1, filteredResults.count)
        XCTAssertEqual(expectation, filteredResults)
    }
    
    func testFilteringByMultipleYearSelection() throws {
        let launches = try getLaunchesData()
        let expectation = [launches[0], launches[2], launches[3]]
        
        let filteredResults = LaunchFilter.applySortAndFilters(launches: launches, status: .all, years: [2006,2008], sort: .forward)
        
        XCTAssertEqual(3, filteredResults.count)
        XCTAssertEqual(expectation, filteredResults)
    }
    
    func testFilteringByLaunchStatus() throws {
        let launches = try getLaunchesDataLimited()
        let expectation = [launches[0], launches[1] ,launches[2], launches[23], launches[33]]
        
        let filteredResults = LaunchFilter.applySortAndFilters(launches: launches, status: .failedOnly, years: [], sort: .forward)
        
        XCTAssertEqual(5, filteredResults.count)
        XCTAssertEqual(expectation, filteredResults)
    }
    
    func testSortingAscending() throws {
        let launches = try getLaunchesDataLimited()
        let expectation = launches
        
        let filteredResults = LaunchFilter.applySortAndFilters(launches: launches, status: .all, years: [], sort: .forward)
        
        XCTAssertEqual(34, filteredResults.count)
        XCTAssertEqual(expectation, filteredResults)
    }
    
    func testLaunchSortingDescending() throws {
        let launches = try getLaunchesDataLimited()
        let expectation = Array(launches.reversed())
        
        let filteredResults = LaunchFilter.applySortAndFilters(launches: launches, status: .all, years: [], sort: .reverse)
        
        XCTAssertEqual(34, filteredResults.count)
        XCTAssertEqual(expectation, filteredResults)
    }
    
    func testFilteringByYearsByStatusAndSorting() throws {
        let launches = try getLaunchesData()
        let expectation = [launches[33], launches[23], launches[2], launches[1], launches[0]]
        
        let filteredResults = LaunchFilter.applySortAndFilters(launches: launches, status: .failedOnly, years: [2006, 2007, 2008, 2015, 2016], sort: .reverse)
        
        XCTAssertEqual(5, filteredResults.count)
        XCTAssertEqual(expectation, filteredResults)
    }
    
    private func getLaunchesData() throws -> [Launch] {
        let json = try Launch.ResourceProvider.json(for: .launchesComplete)
        let launches = try JSONDecoder().decode([Launch].self, from: json)
        return launches.sorted { $0.date < $1.date }
    }
    
    private func getLaunchesDataLimited() throws -> [Launch] {
        let json = try Launch.ResourceProvider.json(for: .launchesLimited)
        let launches = try JSONDecoder().decode([Launch].self, from: json)
        return launches.sorted { $0.date < $1.date }
    }
}
