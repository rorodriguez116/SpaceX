//
//  ContentView.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/19/22.
//

import SwiftUI
import Combine
import Resolver

struct ContentView<A: CompanyDetailSectionViewModel>: View {
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    CompanyDetailsSectionView<A>()
                    LaunchesListSectionView()
                }
                .padding(.top, 16)
                .padding(.bottom, 100)
            }
            .navigationTitle("SpaceX")
        }
        .colorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView<DesignCompanyDetailsSectionViewModel>()
            .colorScheme(.dark)
    }
}
