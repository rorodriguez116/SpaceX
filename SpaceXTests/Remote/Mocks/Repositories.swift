//
//  Repositories.swift
//  SpaceXTests
//
//  Created by Rolando Rodriguez on 5/19/22.
//

@testable import SpaceX
import Combine
import Foundation

final class MockCompanyDetailsRepository: CompanyDetailsRepository {
    var getCompanyDetailsResult: Result<CompanyDetails, Error> = .failure(AnyLocalizedError())
    
    func getCompanyDetails() -> AnyPublisher<CompanyDetails, Error> {
        Future<CompanyDetails, Error> { promise in
            promise(self.getCompanyDetailsResult)
        }
        .eraseToAnyPublisher()
    }
}

final class MockLaunchRepository: LaunchRepository {
    var getLaunchesListResult: Result<[Launch], Error> = .failure(AnyLocalizedError())

    func getLaunchesList() -> AnyPublisher<[Launch], Error> {
        Future<[Launch], Error> { promise in
            promise(self.getLaunchesListResult)
        }
        .eraseToAnyPublisher()
    }
}

final class MockRocketRepository: RocketRepository {
    var getRocketsForIdsResult: Result<[Rocket], Error> = .failure(AnyLocalizedError())
    var getRocketsForIdResult: Result<Rocket, Error> = .failure(AnyLocalizedError())
    
    func getRocketFor(id: String) -> AnyPublisher<Rocket, Error> {
        Future<Rocket, Error> { promise in
            promise(self.getRocketsForIdResult)
        }
        .eraseToAnyPublisher()
    }
    
    func getRocketsFor(ids: [String]) -> AnyPublisher<[Rocket], Error> {
        Future<[Rocket], Error> { promise in
            promise(self.getRocketsForIdsResult)
        }
        .eraseToAnyPublisher()
    }
}
