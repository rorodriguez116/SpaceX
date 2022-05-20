//
//  Launch+Extensions.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/19/22.
//

import Foundation

extension Launch: Decodable {
    struct Links: Decodable {
        let patch: [String: URL]
        let webcast: URL?
        let youtube_id: String?
        let article: URL?
        let wikipedia: URL?
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case missionName = "name"
        case date = "date_unix"
        case rocketId = "rocket"
        case status = "success"
        case articleUrl = "article"
        case videoId = "youtube_id"
        case wikiUrl = "wikipedia"
        case links = "links"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let links = try values.decode(Links.self, forKey: .links)
        
        missionName = try values.decode(String.self, forKey: .missionName)
        let timestamp = try values.decode(Double.self, forKey: .date)
        date = Date(timeIntervalSince1970: timestamp)
        
        rocketId = try values.decode(String.self, forKey: .rocketId)
        if let url = links.patch["small"] {
            missionImageUrl = url
        } else {
            missionImageUrl = nil
        }
        
        id = try values.decode(String.self, forKey: .id)
        status = try values.decode(Bool?.self, forKey: .status) ?? false ? .success : .failure
        articleUrl = links.article
        videoId = links.youtube_id
        wikiUrl = links.wikipedia
    }
}
