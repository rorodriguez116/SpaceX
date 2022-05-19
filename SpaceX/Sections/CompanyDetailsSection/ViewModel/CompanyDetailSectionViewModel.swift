//
//  CompanyDetailSectionViewModel.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/19/22.
//

import Foundation
import Combine
import Resolver

protocol CompanyDetailSectionViewModel: ObservableObject {
    var companyDetails: CompanyDetails? { get set }
    
    init() 
    
    func getCompanyDetails()
}

final class DefaultCompanyDetailsSectionViewModel: CompanyDetailSectionViewModel {
    @Injected var repository: CompanyDetailsRepository
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var companyDetails: CompanyDetails?
    
    init() {}
    
    func getCompanyDetails() {
        repository.getCompanyDetails().sink { completion in
            print(completion)
        } receiveValue: { details in
            print(details)
            self.companyDetails = details
        }
        .store(in: &self.subscriptions)
    }
}

struct AnyLocalizedError: LocalizedError {
    let errorDescription: String?

    init(_ errorDescription: String? = nil) {
        self.errorDescription = errorDescription
    }
}

struct Mock {
    static let companyDetail = CompanyDetails(companyName: "SpaceX", summary: "SpaceX designs, manufactures and launches advanced rockets and spacecraft. The company was founded in 2002 to revolutionize space technology, with the ultimate goal of enabling people to live on other planets.", founderName: "Elon Musk", year: 2002, employeesCount: 9500, launchSitesCount: 3, valuation: 74000000000.0)
}

final class DesignCompanyDetailsSectionViewModel: CompanyDetailSectionViewModel {
    @Published var companyDetails: CompanyDetails?
    
    func getCompanyDetails() {
        self.companyDetails = Mock.companyDetail
    }
}
