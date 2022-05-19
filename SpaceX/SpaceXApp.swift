//
//  SpaceXApp.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/19/22.
//

import SwiftUI
import Resolver

@main
struct SpaceXApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView<DefaultCompanyDetailsSectionViewModel>()
        }
    }
}

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register {
            DefaultCompanyDetailsRepository()
        }
        .implements(CompanyDetailsRepository.self)
        
        register {
            DefaultCompanyDetailsWebService()
        }
        .implements(CompanyDetailsWebService.self)
    }
}
