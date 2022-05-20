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
        repository.getCompanyDetails()
            .receive(on: RunLoop.main)
            .sink { completion in
                print(completion)
            } receiveValue: { details in
                print(details)
                self.companyDetails = details
            }
            .store(in: &self.subscriptions)
    }
}

final class DesignCompanyDetailsSectionViewModel: CompanyDetailSectionViewModel {
    @Published var companyDetails: CompanyDetails?
    
    func getCompanyDetails() {
        self.companyDetails = Mock.companyDetail
    }
}
