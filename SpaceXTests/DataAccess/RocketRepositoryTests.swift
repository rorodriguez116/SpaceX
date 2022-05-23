//
//  RocketRepositoryTests.swift
//  SpaceXTests
//
//  Created by Rolando Rodriguez on 5/23/22.
//

import Combine
import Resolver
@testable import SpaceX
import XCTest

class RocketRepositoryTests: XCTestCase {
    private var repository: DefaultRocketRepository?
    private var webservice: MockRocketWebService?
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        Resolver.resetUnitTestRegistrations()
        cancellables = []
    }
    
    override func tearDown() {
        Resolver.root = Resolver.main
    }
    
    func testThatFetchingRocketsByIdCanSucceed() throws {
        // Given
        webservice = Resolver.test.optional()
        repository = DefaultRocketRepository()
    
        let values = try getRockets()
        let result: Result<RocketsDTO, Error> = .success(values)
        var rockets: [Rocket]!
        
        webservice?.complete(with: result)
        
        let expectation = self.expectation(description: "Data download and processing")
        
        let inputRocketIds =  ["5e9d0d96eda699382d09d1ee", "5e9d0d95eda69955f709d1eb"]

        // When
        repository?.getRocketsFor(ids: inputRocketIds)
            .sink(receiveCompletion: { comp in
                if case .failure = comp {
                    XCTFail("Unexpected error")
                }
                
                expectation.fulfill()
            }, receiveValue: { val in
                rockets = val
            })
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 10)
        
        let resultRocketsIds = Set<String>(rockets.map { $0.id })
        
        // Then
        XCTAssertNotNil(rockets)
        XCTAssertEqual(resultRocketsIds, Set<String>(inputRocketIds))
    }
    
    func testThatFetchingRocketsByIdCanFail() {
        // Given
        webservice = Resolver.test.optional()
        repository = DefaultRocketRepository()
    
        let result: Result<RocketsDTO, Error> = .failure(AnyLocalizedError("Expected error"))
        var rockets: [Rocket]!
        
        webservice?.complete(with: result)
        
        let expectation = self.expectation(description: "Data download and processing")
        
        // When
        let rocketIds =  ["5e9d0d96eda699382d09d1ee", "5e9d0d95eda69955f709d1eb"]
        
        repository?.getRocketsFor(ids: rocketIds)
            .sink(receiveCompletion: { comp in
                if case .finished = comp {
                    XCTFail("Unexpected success")
                }
                
                expectation.fulfill()
            }, receiveValue: { val in
                rockets = val
            })
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 10)
        
        // Then
        XCTAssertNil(rockets)
    }
    
    func testThatFetchingSingleRocketByIdCanSucceed() throws {
        // Given
        webservice = Resolver.test.optional()
        repository = DefaultRocketRepository()
    
        let value = try getRocket()
        let result: Result<Rocket, Error> = .success(value)
        var rocket: Rocket!
        
        webservice?.complete(with: result)
        
        let expectation = self.expectation(description: "Data download and processing")
        
        let inputRocketId = "5e9d0d95eda69955f709d1eb"

        // When
        repository?.getRocketFor(id: inputRocketId)
            .sink(receiveCompletion: { comp in
                if case .failure = comp {
                    XCTFail("Unexpected error")
                }
                
                expectation.fulfill()
            }, receiveValue: { val in
                rocket = val
            })
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 10)
                
        // Then
        XCTAssertNotNil(rocket)
        XCTAssertEqual(inputRocketId, rocket.id)
    }
    
    func testThatFetchingSingleRocketByIdCanFail() {
        // Given
        webservice = Resolver.test.optional()
        repository = DefaultRocketRepository()
    
        let result: Result<Rocket, Error> = .failure(AnyLocalizedError("Expected error"))
        var rocket: Rocket!
        
        webservice?.complete(with: result)
        
        let expectation = self.expectation(description: "Data download and processing")
        
        let inputRocketId = "5e9d0d95eda69955f709d1eb"
        
        repository?.getRocketFor(id: inputRocketId)
            .sink(receiveCompletion: { comp in
                if case .finished = comp {
                    XCTFail("Unexpected success")
                }
                
                expectation.fulfill()
            }, receiveValue: { val in
                rocket = val
            })
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 10)
        
        // Then
        XCTAssertNil(rocket)
    }
    
    private func getRockets() throws -> RocketsDTO {
        let json = try Rocket.ResourceProvider.json(for: .rocketsMid)
        let rockets = try JSONDecoder().decode(RocketsDTO.self, from: json)
        return rockets
    }
    
    private func getRocket() throws -> Rocket {
        let json = try Rocket.ResourceProvider.json(for: .rocketSingle)
        let rocket = try JSONDecoder().decode(Rocket.self, from: json)
        return rocket
    }
}

class MockRocketWebService: RocketWebService {
    private var getRocketsByIdsResult: Result<RocketsDTO, Error> = .failure(AnyLocalizedError())
    private var getRocketsByIdResult: Result<Rocket, Error> = .failure(AnyLocalizedError())

    func getRocketsFor(ids: [String]) -> AnyPublisher<RocketsDTO, Error> {
        Future<RocketsDTO, Error> { promise in
            promise(self.getRocketsByIdsResult)
        }
        .eraseToAnyPublisher()
    }
    
    func getRocketFor(id: String) -> AnyPublisher<Rocket, Error> {
        Future<Rocket, Error> { promise in
            promise(self.getRocketsByIdResult)
        }
        .eraseToAnyPublisher()
    }
    
    func complete(with result: Result<RocketsDTO, Error>) {
        self.getRocketsByIdsResult = result
    }
    
    func complete(with result: Result<Rocket, Error>) {
        self.getRocketsByIdResult = result
    }
}
