//
//  CompanyDetailsRepository.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/19/22.
//

import Combine
import Foundation

protocol CompanyDetailsRepository {
    func getCompanyDetails() -> AnyPublisher<CompanyDetails, Error>
}

