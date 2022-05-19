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
          CompanyDetailsSectionView<A>()
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView<DesignCompanyDetailsSectionViewModel>()
    }
}
