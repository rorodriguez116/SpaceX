//
//  RocketsRepository.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/19/22.
//

import Combine
import Foundation
import Resolver

protocol RocketRepository {
    func getRocketFor(id: String) -> AnyPublisher<Rocket, Error>
    func getRocketsFor(ids: [String]) -> AnyPublisher<[Rocket], Error> 
}

struct DefaultRocketRepository: RocketRepository {
    @Injected private var webservice: RocketWebService
    
    func getRocketFor(id: String) -> AnyPublisher<Rocket, Error> {
        webservice.getRocketFor(id: id)
    }
    
    func getRocketsFor(ids: [String]) -> AnyPublisher<[Rocket], Error> {
        webservice.getRocketsFor(ids: ids)
            .map { $0.docs }
            .eraseToAnyPublisher()
    }
}
