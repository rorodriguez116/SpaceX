//
//  LaunchesListSectionViewModel.swift
//  SpaceXTests
//
//  Created by Rolando Rodriguez on 5/22/22.
//

@testable import SpaceX
import XCTest
import Resolver
import Combine

class LaunchesListSectionViewModelTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        Resolver.resetUnitTestRegistrations()
        cancellables = []
    }
    
    override func tearDown() {
        Resolver.root = Resolver.main
    }
    
    func testLoad() throws {
        // Given

        let launches = try getLaunchesDataMin()
        let rockets = try getRockets()
        let viewModel = DefaultLaunchesListSectionViewModel()
        
        // Will return the same repo assigned to viewModels because of DI scope.
        let launchRepo: MockLaunchRepository = Resolver.resolve()
        let rocketRepo: MockRocketRepository = Resolver.resolve()
        // Set operation result.
        launchRepo.getLaunchesListResult = .success(launches)
        rocketRepo.getRocketsForIdsResult = .success(rockets)
        
        let expectedResult = [
            Launch(id: "5eb87cdcffd86e000604b32e", missionName: "RazakSat", date: Date(timeIntervalSince1970: 1247456100), rocketId: "5e9d0d95eda69955f709d1eb", rocketName: "Falcon 1", rocketType: "rocket", missionImageUrl: nil, status: .success, articleUrl: nil, videoId: nil, wikiUrl: nil),
            Launch(id: "5eb87ce1ffd86e000604b333", missionName: "CRS-2", date: Date(timeIntervalSince1970: 1362165000), rocketId: "5e9d0d95eda69973a809d1ec", rocketName: "Falcon 9", rocketType: "rocket", missionImageUrl: nil, status: .success, articleUrl: nil, videoId: nil, wikiUrl: nil)
        ]
        
        let expectation = self.expectation(description: "Data download and processing")

        var stateCollector = [ListState<[Launch]>]()

        // When
        
        viewModel.$state.sink { state in
            stateCollector.append(state)
        }
        .store(in: &self.cancellables)
        
        viewModel.getLaunchesListWithMatchingRocketDataPublisher
            .receive(on: RunLoop.main)
            .sink { completion in
                if case .failure = completion {
                    viewModel.updateUI(with: "Something went wrong.")
                }
            } receiveValue: { result in
                viewModel.updateUI(with: result, resultByStatus: result)
                
                expectation.fulfill()
            }
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 10)
        // Then
        
        XCTAssertEqual(stateCollector, [.idle, .loading, .loaded(expectedResult)])
    }
    
    func testThatLoadCanFail() throws {
        // Given

        let rockets = try getRockets()
        let viewModel = DefaultLaunchesListSectionViewModel()
        
        // Will return the same repo assigned to viewModels because of DI scope.
        let launchRepo: MockLaunchRepository = Resolver.resolve()
        let rocketRepo: MockRocketRepository = Resolver.resolve()
        // Set operation result.
        launchRepo.getLaunchesListResult = .failure(AnyLocalizedError("Expected Error"))
        rocketRepo.getRocketsForIdsResult = .success(rockets)
        
        let expectation = self.expectation(description: "Data download and processing")

        var stateCollector = [ListState<[Launch]>]()

        // When
        
        viewModel.$state.sink { state in
            stateCollector.append(state)
        }
        .store(in: &self.cancellables)
        
        viewModel.getLaunchesListWithMatchingRocketDataPublisher
            .receive(on: RunLoop.main)
            .sink { completion in
                if case .failure = completion {
                    viewModel.updateUI(with: "Something went wrong.")
                }
                
                expectation.fulfill()
            } receiveValue: { result in
                viewModel.updateUI(with: result, resultByStatus: result)
                XCTFail("Unexpected success")
            }
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 10)
        // Then
        
        XCTAssertEqual(stateCollector, [.idle, .loading, .failed("Something went wrong.")])
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
