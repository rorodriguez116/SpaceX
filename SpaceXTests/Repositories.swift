//
//  Repositories.swift
//  SpaceXTests
//
//  Created by Rolando Rodriguez on 5/19/22.
//

@testable import SpaceX
import Combine
import Foundation

struct AnyLocalizedError: LocalizedError {
    let errorDescription: String?

    init(_ errorDescription: String? = nil) {
        self.errorDescription = errorDescription
    }
}

struct MockCompanyDetailsRepository: CompanyDetailsRepository {
    var getCompanyDetailsResult: Result<CompanyDetails, Error> = .failure(AnyLocalizedError())
    
    func getCompanyDetails() -> AnyPublisher<CompanyDetails, Error> {
        Future<CompanyDetails, Error> { promise in
            promise(getCompanyDetailsResult)
        }
        .eraseToAnyPublisher()
    }
}
