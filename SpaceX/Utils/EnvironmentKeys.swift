//
//  Environment.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/21/22.
//

import Foundation

enum Config {
    static var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    
    struct EnvironmentKeys {
        static var domainName: String {
            guard let info = Bundle.main.infoDictionary, let domain = info["DOMAIN_NAME"] as? String else { fatalError("MISSING ENVIRONMENT CONFIGURATION") }
            
            return domain
        }
    }
}


