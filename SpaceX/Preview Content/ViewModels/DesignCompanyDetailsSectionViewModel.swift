//
//  DesignCompanyDetailsSectionViewModel.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/22/22.
//

import Foundation
import Combine

final class DesignCompanyDetailsSectionViewModel: DefaultCompanyDetailsSectionViewModel {
    
    override func getCompanyDetails() {
        guard state.canLoad else { return }
        self.state = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.state = .loaded(CompanyDetails.previewCompanyDetails)
        }
    }
}
