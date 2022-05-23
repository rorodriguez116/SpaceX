//
//  RocketWebService.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/19/22.
//

import Combine
import Rapide
import Resolver

protocol RocketWebService {
    func getRocketFor(id: String) -> AnyPublisher<Rocket, Error>
    func getRocketsFor(ids: [String]) -> AnyPublisher<RocketsDTO, Error>
}

struct DefaultRocketWebService: RocketWebService {
    func getRocketFor(id: String) -> AnyPublisher<Rocket, Error> {
        Rapide
            .https
            .host(Config.EnvironmentKeys.domainName)
            .path("/v4/rockets/\(id)")
            .authorization(.none)
            .params([:])
            .execute(.get, decoding: Rocket.self)
            .eraseToAnyPublisher()
    }
    
    func getRocketsFor(ids: [String]) -> AnyPublisher<RocketsDTO, Error> {
        Rapide
            .https
            .host("api.spacexdata.com")
            .path("/v4/rockets/query")
            .authorization(.none)
            .params(
                [
                    "query": [
                        "_id": [
                            "$in": ids
                        ]
                    ],
                    "options": [
                        "select": ["name", "type"]
                    ]
                ]
            )
            .execute(.post, decoding: RocketsDTO.self)
            .eraseToAnyPublisher()
    }
}
