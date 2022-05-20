//
//  CompanyDetailsSectionView.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/19/22.
//

import SwiftUI

struct CompanyDetailsSectionView<A: CompanyDetailSectionViewModel>: View {
    @StateObject private var viewmodel = A()

    var sectionText: String {
        guard let details = viewmodel.companyDetails else { return "Loading..." }
        
        return "\(details.companyName) was founded by \(details.founderName) in \(details.year). It has now \(details.employeesCount), \(details.launchSitesCount) launch sites, and is valued at USD \(details.valuation)"
    }
    
    var body: some View {
        SectionView(title: "COMPANY") {
            Text(sectionText)
        }
        .onAppear {
            viewmodel.getCompanyDetails()
        }
    }
}
