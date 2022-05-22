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

struct MockLaunchRepository: LaunchRepository {
    var getLaunchesListResult: Result<[Launch], Error> = .failure(AnyLocalizedError())

    func getLaunchesList() -> AnyPublisher<[Launch], Error> {
        Future<[Launch], Error> { promise in
            promise(getLaunchesListResult)
        }
        .eraseToAnyPublisher()
    }
}
