//
//  RocketMatcher.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/22/22.
//

import Foundation

struct RocketMatcher {
    /// Returns a list of updated launches containing new data of its corresponding rockets.
    static func matchRocketsToLaunches(rockets: [Rocket], launches: [Launch]) -> [Launch] {
        let collection = launches.compactMap { launch -> Launch in
            guard let rocket = rockets.first(where: { $0.id == launch.rocketId }) else { return launch }
            
            var _launch = launch
            _launch.rocketName = rocket.name
            _launch.rocketType = rocket.type
            
            return _launch
        }
        
        return collection
    }
}
