//
//  LaunchRepositoryTests.swift
//  SpaceXTests
//
//  Created by Rolando Rodriguez on 5/23/22.
//

import Combine
import Resolver
@testable import SpaceX
import XCTest

class LaunchRepositoryTests: XCTestCase {
    private var repository: DefaultLaunchRepository?
    private var webservice: MockLaunchWebService?
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        Resolver.resetUnitTestRegistrations()
        cancellables = []
    }
    
    override func tearDown() {
        Resolver.root = Resolver.main
    }
    
    func testSuccessResponse() throws {
        // Given
        webservice = Resolver.test.optional()
        repository = DefaultLaunchRepository()
    
        let values = try getLaunchesDataMax()
        let result: Result<[Launch], Error> = .success(values)
        var launches: [Launch]!
        
        webservice?.complete(with: result)
        
        let expectation = self.expectation(description: "Data download and processing")
        
        // When
        
        repository?.getLaunchesList()
            .sink(receiveCompletion: { comp in
                if case .failure = comp {
                    XCTFail("Unexpected error")
                }
                
                expectation.fulfill()
            }, receiveValue: { val in
                launches = val
            })
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 10)
        
        // Then
        
        XCTAssertEqual(launches, values)
    }
    
    func testFailResponse() {
        // Given
        webservice = Resolver.test.optional()
        repository = DefaultLaunchRepository()
        
        let result: Result<[Launch], Error> = .failure(AnyLocalizedError("Expected error"))
        var launches: [Launch]!
        
        webservice?.complete(with: result)
        
        let expectation = self.expectation(description: "Data download and processing")
        
        // When
        
        repository?.getLaunchesList()
            .sink(receiveCompletion: { comp in
                if case .finished = comp {
                    XCTFail("Unexpected success")
                }
                
                expectation.fulfill()
            }, receiveValue: { val in
                launches = val
            })
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 10)
        
        // Then
        XCTAssertNil(launches)
    }
    
    private func getLaunchesDataMax() throws -> [Launch] {
        let json = try Launch.ResourceProvider.json(for: .launchesComplete)
        let launches = try JSONDecoder().decode([Launch].self, from: json)
        return launches.sorted { $0.date < $1.date }
    }
}

class MockLaunchWebService: LaunchWebService {
    private var getLaunchesResult: Result<[Launch], Error> = .failure(AnyLocalizedError())
    
    func getAllLaunches() -> AnyPublisher<[Launch], Error> {
        Future<[Launch], Error> { promise in
            promise(self.getLaunchesResult)
        }
        .eraseToAnyPublisher()
    }
    
    func complete(with result: Result<[Launch], Error>) {
        self.getLaunchesResult = result
    }
}
