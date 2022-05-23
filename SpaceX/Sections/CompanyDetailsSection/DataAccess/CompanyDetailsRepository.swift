//
//  CompanyDetailsRepository.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/19/22.
//

import Combine
import Foundation
import Resolver

protocol CompanyDetailsRepository {
    func getCompanyDetails() -> AnyPublisher<CompanyDetails, Error>
}

struct DefaultCompanyDetailsRepository: CompanyDetailsRepository {
    @Injected private var webservice: CompanyDetailsWebService
    
    func getCompanyDetails() -> AnyPublisher<CompanyDetails, Error> {
        webservice.getCompanyDetails()
    }
}
