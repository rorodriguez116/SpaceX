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
    var state: SectionState { get }

    init() 
    
    func getCompanyDetails()
}


class DefaultCompanyDetailsSectionViewModel: CompanyDetailSectionViewModel {
    @Injected var repository: CompanyDetailsRepository
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var companyDetails: CompanyDetails?
    @Published var state: SectionState = .idle

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
    
    required init() {}
    
    func getCompanyDetails() {
        guard state.canLoad else { return }
        state = .loading
        
        repository.getCompanyDetails()
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.state = .failed("Something went wrong.")
                }
            } receiveValue: { [weak self] details in
                guard let self = self else { return }
                
                self.companyDetails = details
                self.state = .loaded
            }
            .store(in: &self.subscriptions)
    }
}
