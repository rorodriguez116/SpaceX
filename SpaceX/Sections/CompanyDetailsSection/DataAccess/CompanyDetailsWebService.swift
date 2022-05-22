//
//  CompanyDetailsWebService.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/19/22.
//

import Combine
import Foundation
import Rapide
import Resolver

protocol CompanyDetailsWebService {
    func getCompanyDetails() -> AnyPublisher<CompanyDetails, Error>
}

struct DefaultCompanyDetailsWebService: CompanyDetailsWebService {
    func getCompanyDetails() -> AnyPublisher<CompanyDetails, Error> {
        Rapide
            .https
            .host(EnvironmentKeys.domainName)
            .path("/v4/company")
            .authorization(.none)
            .params([:])
            .execute(.get, decoding: CompanyDetails.self)
            .eraseToAnyPublisher()
    }
}
