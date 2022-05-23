//
//  Resolver+XCTest.swift
//  SpaceXTests
//
//  Created by Rolando Rodriguez on 5/22/22.
//

@testable import SpaceX
import Resolver

extension Resolver {
    static var test: Resolver!
    
    static func resetUnitTestRegistrations() {
        // Update DI system to use mock models.

        Resolver.test = Resolver(child: .main)
        Resolver.root = Resolver.test
        
        Resolver.test.register {
            MockLaunchRepository()
        }
            .implements(LaunchRepository.self)
            .scope(.shared)
        
        Resolver.test.register { MockCompanyDetailsRepository() }
            .implements(CompanyDetailsRepository.self)
            .scope(.shared)
        
        Resolver.test.register { MockRocketRepository() }
            .implements(RocketRepository.self)
            .scope(.shared)
        
        Resolver.test.register { MockCompanyDetailsWebService() }
            .implements(CompanyDetailsWebService.self)
            .scope(.shared)
        
        Resolver.test.register { MockLaunchWebService() }
            .implements(LaunchWebService.self)
            .scope(.shared)

    }
}
