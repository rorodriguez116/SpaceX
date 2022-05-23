//
//  RocketDTO.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/23/22.
//

import Foundation

struct RocketsDTO: Decodable, Equatable {
    let docs: [Rocket]
}
