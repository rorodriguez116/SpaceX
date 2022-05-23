//
//  CompanyDetailsRepositoryTests.swift
//  SpaceXTests
//
//  Created by Rolando Rodriguez on 5/23/22.
//

import Combine
import Resolver
@testable import SpaceX
import XCTest

class CompanyDetailsRepositoryTests: XCTestCase {
    private var repository: DefaultCompanyDetailsRepository?
    private var webservice: MockCompanyDetailsWebService?
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        Resolver.resetUnitTestRegistrations()
        cancellables = []

       
    }
    
    override func tearDown() {
        Resolver.root = Resolver.main
    }
    
    func testSuccessResponse() {
       // Given
        webservice = Resolver.test.optional()
        repository = DefaultCompanyDetailsRepository()
        
        let result: Result<CompanyDetails, Error> = .success(CompanyDetails.previewCompanyDetails)
        var details: CompanyDetails!
        
        webservice?.complete(with: result)
        
        let expectation = self.expectation(description: "Data download and processing")

        // When
    
        repository?.getCompanyDetails()
            .sink(receiveCompletion: { comp in
                if case .failure = comp {
                    XCTFail("Unexpected error")
                }
                
                expectation.fulfill()
            }, receiveValue: { val in
                details = val
            })
            .store(in: &self.cancellables)
           
        waitForExpectations(timeout: 10)
        
        // Then
        
        XCTAssertEqual(details, CompanyDetails.previewCompanyDetails)
    }
    
    func testFailResponse() {
       // Given
        webservice = Resolver.test.optional()
        repository = DefaultCompanyDetailsRepository()
        
        let result: Result<CompanyDetails, Error> = .failure(AnyLocalizedError("Expected error"))
        var details: CompanyDetails!
        
        webservice?.complete(with: result)
        
        let expectation = self.expectation(description: "Data download and processing")

        // When
    
        repository?.getCompanyDetails()
            .sink(receiveCompletion: { comp in
                if case .finished = comp {
                    XCTFail("Unexpected success")
                }
                
                expectation.fulfill()
            }, receiveValue: { val in
                details = val
            })
            .store(in: &self.cancellables)
           
        waitForExpectations(timeout: 10)
        
        // Then
        XCTAssertNil(details)
    }
}

class MockCompanyDetailsWebService: CompanyDetailsWebService {
    private var getCompanyDetailsResult: Result<CompanyDetails, Error> = .failure(AnyLocalizedError())
    
    func getCompanyDetails() -> AnyPublisher<CompanyDetails, Error> {
        Future<CompanyDetails, Error> { promise in
            promise(self.getCompanyDetailsResult)
        }
        .eraseToAnyPublisher()
    }
    
    func complete(with result: Result<CompanyDetails, Error>) {
        self.getCompanyDetailsResult = result
    }
}
