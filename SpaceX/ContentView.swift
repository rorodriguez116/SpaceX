//
//  ContentView.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/19/22.
//

import SwiftUI
import Combine
import Resolver

struct ContentView<A: CompanyDetailSectionViewModel, B: LaunchesListSectionViewModel>: View {
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    CompanyDetailsSectionView<A>()
                    LaunchesListSectionView<B>()
                }
                .padding(.bottom, 100)
            }
            .navigationTitle("SpaceX")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView<DesignCompanyDetailsSectionViewModel, DesignLaunchesListSectionViewModel>()
    }
}
