//
//  Repositories.swift
//  SpaceXTests
//
//  Created by Rolando Rodriguez on 5/19/22.
//

@testable import SpaceX
import Combine
import Foundation

struct MockCompanyDetailsRepository: CompanyDetailsRepository {
    var getCompanyDetailsResult: Result<CompanyDetails, Error> = .failure(AnyLocalizedError())
    
    func getCompanyDetails() -> AnyPublisher<CompanyDetails, Error> {
        Future<CompanyDetails, Error> { promise in
            promise(getCompanyDetailsResult)
        }
        .eraseToAnyPublisher()
    }
}
