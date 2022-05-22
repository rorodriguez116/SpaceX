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

// Dependency Injection
extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register {
            DefaultLaunchesListSectionViewModel(launchRepository: DefaultLaunchRepository(), rocketRepository: DefaultRocketRepository())
        }

        register {
            DefaultCompanyDetailsRepository()
        }
        .implements(CompanyDetailsRepository.self)
        
        register {
            DefaultCompanyDetailsWebService()
        }
        .implements(CompanyDetailsWebService.self)
        
        register {
            DefaultLaunchRepository()
        }
        .implements(LaunchRepository.self)
        
        register {
            DefaultLaunchWebService()
        }
        .implements(LaunchWebService.self)
        
        register {
            DefaultRocketWebService()
        }
        .implements(RocketWebService.self)
        
        register {
            DefaultRocketRepository()
        }
        .implements(RocketRepository.self)
    }
}
