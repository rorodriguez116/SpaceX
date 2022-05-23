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
    var sectionText: String { get }
    var state: ListState<CompanyDetails> { get }

    init() 
    
    func getCompanyDetails(completion block: (() -> ())?) 
}


class DefaultCompanyDetailsSectionViewModel: CompanyDetailSectionViewModel {
    @Injected var repository: CompanyDetailsRepository
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var state: ListState<CompanyDetails> = .idle

    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        return formatter
    }()
    
    var sectionText: String {
        guard case let .loaded(details) = state else { return "Loading..." }
        
        let valuation = numberFormatter.string(from: NSNumber(value: details.valuation)) ?? "USD \(details.valuation)"
        
        return "\(details.companyName) was founded by \(details.founderName) in \(details.year). It has now \(details.employeesCount) employees, \(details.launchSitesCount) launch sites, and is valued at \(valuation)."
    }
        
    func updateUI(with error: String) {
        self.state = .failed(error)
    }
    
    func updateUI(with details: CompanyDetails) {
        self.state = .loaded(details)
    }
    
    required init() {}
    
    func getCompanyDetails(completion block: (() -> ())? = nil) {
        guard state.canLoad else { return }
        state = .loading
        
        repository.getCompanyDetails()
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.updateUI(with: "Something went wrong.")
                }
                
                block?()
            } receiveValue: { [weak self] details in
                guard let self = self else { return }
                self.updateUI(with: details)
            }
            .store(in: &self.subscriptions)
    }
}
