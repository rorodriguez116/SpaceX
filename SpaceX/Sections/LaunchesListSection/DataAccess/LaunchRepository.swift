//
//  LaunchRepository.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/19/22.
//

import Combine
import Foundation
import Resolver

protocol LaunchRepository {
    func getLaunchesList() -> AnyPublisher<[Launch], Error>
}

struct DefaultLaunchRepository: LaunchRepository {
    @Injected private var webservice: LaunchWebService
    
    func getLaunchesList() -> AnyPublisher<[Launch], Error> {
        webservice.getLatestLaunches()
    }
}
