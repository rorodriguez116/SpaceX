//
//  Launch.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/19/22.
//

import Foundation

struct Launch: Identifiable, Hashable {
    enum Status: Hashable {
        case success
        case failure
        case undetermined
    }
    
    let id: String 
    let missionName: String
    let date: Date
    let rocketId: String
    var rocketName: String = ""
    var rocketType: String = ""
    let missionImageUrl: URL?
    var status: Status
    let articleUrl: URL?
    let videoId: String?
    let wikiUrl: URL?
}
