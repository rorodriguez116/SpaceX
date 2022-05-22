//
//  BaseResourceProvider.swift
//  SpaceXTests
//
//  Created by Rolando Rodriguez on 5/22/22.
//

import Foundation

enum BaseResourceProvider {
    static func json(forResourceNamed name: String) throws -> Data {
        let bundle = Bundle(for: DefaultCompanyDetailsSectionViewModel.self)
        guard let url = bundle.url(forResource: name, withExtension: "json") else { throw AnyLocalizedError("No JSON resource named \(name) found in Bundle \(bundle.bundlePath)") }
        let data = try Data(contentsOf: url)
        return data
    }
}
