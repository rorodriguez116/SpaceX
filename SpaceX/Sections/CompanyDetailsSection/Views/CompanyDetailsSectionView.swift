//
//  CompanyDetailsSectionView.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/19/22.
//

import SwiftUI

struct CompanyDetailsSectionView<A: CompanyDetailSectionViewModel>: View {
    @StateObject private var viewmodel = A()

    var body: some View {
        SectionView(title: "COMPANY") {
            if viewmodel.state == .loaded {
                Text(viewmodel.sectionText)
            }
        }
        .onAppear {
            viewmodel.getCompanyDetails()
        }
    }
}
