//
//  CompanyDetailsTests.swift
//  SpaceXTests
//
//  Created by Rolando Rodriguez on 5/22/22.
//

@testable import SpaceX
import XCTest

class CompanyDetailsTests: XCTestCase {
    private typealias Resource = CompanyDetails.ResourceProvider
    
    func testThatCompanyDetailsCanBeDecoded() throws {
        // Given
        let json = try Resource.json(for: .companyDetailsComplete)
        
        // When
        let companyDetails = try JSONDecoder().decode(CompanyDetails.self, from: json)
        let mockCompanyDetails = mockCompanyDetails()
        
        // Then
        
        XCTAssertNotNil(companyDetails.companyName)
        XCTAssertNotNil(companyDetails.employeesCount)
        XCTAssertNotNil(companyDetails.founderName)
        XCTAssertNotNil(companyDetails.launchSitesCount)
        XCTAssertNotNil(companyDetails.summary)
        XCTAssertNotNil(companyDetails.valuation)
        
        XCTAssertEqual(companyDetails, mockCompanyDetails)
    }
    
    func testThatCompanyDetailsCanBeDecodedWithMinSchema() throws {
        // Given
        let json = try Resource.json(for: .companyDetailsIncomplete)
        
        // When
        let companyDetails = try JSONDecoder().decode(CompanyDetails.self, from: json)
        
        // Then
        
        XCTAssertNotNil(companyDetails.companyName)
        XCTAssertNotNil(companyDetails.employeesCount)
        XCTAssertNotNil(companyDetails.founderName)
        XCTAssertNotNil(companyDetails.launchSitesCount)
        XCTAssertNotNil(companyDetails.valuation)
        
        XCTAssertNil(companyDetails.summary)
    }
    
    private func mockCompanyDetails() -> CompanyDetails {
        CompanyDetails(companyName: "SpaceX", summary: "SpaceX designs, manufactures and launches advanced rockets and spacecraft. The company was founded in 2002 to revolutionize space technology, with the ultimate goal of enabling people to live on other planets.", founderName: "Elon Musk", year: 2002, employeesCount: 9500, launchSitesCount: 3, valuation: 74000000000.0)
    }
}

extension CompanyDetails {
    enum ResourceProvider {
        enum Schema: String {
            case companyDetailsComplete = "CompanyDetailsComplete"
            case companyDetailsIncomplete = "CompanyDetailsIncomplete"
        }
        
        static func json(for schema: Schema) throws -> Data {
            try BaseResourceProvider.json(forResourceNamed: schema.rawValue)
        }
    }
}
