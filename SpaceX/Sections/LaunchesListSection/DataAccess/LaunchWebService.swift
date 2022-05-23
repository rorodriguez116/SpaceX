//
//  LaunchWebService.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/19/22.
//

import Combine
import Foundation
import Rapide
import Resolver

protocol LaunchWebService {
    func getAllLaunches() -> AnyPublisher<[Launch], Error>
}

struct DefaultLaunchWebService: LaunchWebService {
    func getAllLaunches() -> AnyPublisher<[Launch], Error> {
        Rapide
            .https
            .host(Config.EnvironmentKeys.domainName)
            .path("/v4/launches")
            .authorization(.none)
            .params([:])
            .execute(.get, decoding: [Launch].self)
            .eraseToAnyPublisher()
    }
}
