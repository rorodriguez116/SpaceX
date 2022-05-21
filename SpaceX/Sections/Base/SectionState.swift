//
//  SectionState.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/21/22.
//

import Foundation

enum SectionState: Equatable {
    case idle
    case loading
    case loaded
    case failed(String)

    var canLoad: Bool {
        switch self {
        case .idle, .failed:
            return true
        case .loading, .loaded:
            return false
        }
    }
}
