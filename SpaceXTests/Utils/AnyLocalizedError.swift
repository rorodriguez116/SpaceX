//
//  AnyLocalizedError.swift
//  SpaceXTests
//
//  Created by Rolando Rodriguez on 5/22/22.
//

import Foundation

struct AnyLocalizedError: LocalizedError {
    let errorDescription: String?

    init(_ errorDescription: String? = nil) {
        self.errorDescription = errorDescription
    }
}
