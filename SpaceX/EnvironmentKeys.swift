//
//  Environment.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/21/22.
//

import Foundation

struct EnvironmentKeys {
    static var baseUrl: String {
        guard let info = Bundle.main.infoDictionary, let domain = info["Base_Url"] as? String else { fatalError("MISSING ENVIRONMENT CONFIGURATION") }
        
        return domain
    }
}
