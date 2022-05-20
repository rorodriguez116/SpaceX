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
    var sectionText: String { get }
    init() 
    
    func getCompanyDetails()
}


final class DefaultCompanyDetailsSectionViewModel: CompanyDetailSectionViewModel {
    @Injected var repository: CompanyDetailsRepository
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var companyDetails: CompanyDetails?
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        return formatter
    }()
    
    var sectionText: String {
        guard let details = companyDetails else { return "Loading..." }
        
        let valuation = numberFormatter.string(from: NSNumber(value: details.valuation)) ?? "USD \(details.valuation)"
        
        return "\(details.companyName) was founded by \(details.founderName) in \(details.year). It has now \(details.employeesCount) employees, \(details.launchSitesCount) launch sites, and is valued at \(valuation)."
    }
    
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
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        return formatter
    }()
    
    var sectionText: String {
        guard let details = companyDetails else { return "Loading..." }
        
        let valuation = numberFormatter.string(from: NSNumber(value: details.valuation)) ?? "USD \(details.valuation)"
        
        return "\(details.companyName) was founded by \(details.founderName) in \(details.year). It has now \(details.employeesCount) employees, \(details.launchSitesCount) launch sites, and is valued at \(valuation)."
    }
    
    func getCompanyDetails() {
        self.companyDetails = Mock.companyDetail
    }
}
