//
//  WebViewContentModel.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/20/22.
//

import Foundation

enum WebContentModel: Identifiable {
    var id: UUID { UUID() }
    
    case video(youtubeId: String)
    case page(url: URL)
}
