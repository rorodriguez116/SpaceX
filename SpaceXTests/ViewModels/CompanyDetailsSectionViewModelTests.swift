//
//  CompanyDetailsSectionViewModelTests.swift
//  SpaceXTests
//
//  Created by Rolando Rodriguez on 5/23/22.
//

@testable import SpaceX
import XCTest
import Resolver
import Combine

class CompanyDetailsSectionViewModelTests: XCTestCase {
    
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

        let expectedResult = try getCompanyDetails()
        let viewModel = DefaultCompanyDetailsSectionViewModel()
        
        // Will return the same repo assigned to viewModels because of DI scope.
        let companyRepo: MockCompanyDetailsRepository = Resolver.resolve()

        // Set operation result.
        companyRepo.getCompanyDetailsResult = .success(expectedResult)
        
        let expectation = self.expectation(description: "Data download and processing")

        var stateCollector = [ListState<CompanyDetails>]()

        // When
        
        viewModel.$state.sink { state in
            stateCollector.append(state)
        }
        .store(in: &self.cancellables)
        
        viewModel.getCompanyDetails {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
        // Then
        
        XCTAssertEqual(stateCollector, [.idle, .loading, .loaded(expectedResult)])
    }
    
    func testThatLoadCanFail() throws {
        // Given

        let viewModel = DefaultCompanyDetailsSectionViewModel()
        
        // Will return the same repo assigned to viewModels because of DI scope.
        let companyRepo: MockCompanyDetailsRepository = Resolver.resolve()

        // Set operation result.
        companyRepo.getCompanyDetailsResult = .failure(AnyLocalizedError("Expected error."))
        
        let expectation = self.expectation(description: "Data download and processing.")

        var stateCollector = [ListState<CompanyDetails>]()

        // When
        
        viewModel.$state.sink { state in
            stateCollector.append(state)
        }
        .store(in: &self.cancellables)
        
        viewModel.getCompanyDetails {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
        // Then
        
        XCTAssertEqual(stateCollector, [.idle, .loading, .failed("Something went wrong.")])
    }
    
    private func getCompanyDetails() throws -> CompanyDetails {
        let json = try CompanyDetails.ResourceProvider.json(for: .companyDetailsComplete)
        let details = try JSONDecoder().decode(CompanyDetails.self, from: json)
        return details
    }
}
