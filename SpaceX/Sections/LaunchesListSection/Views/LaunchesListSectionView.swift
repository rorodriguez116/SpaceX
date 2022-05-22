//
//  LaunchesSectionView.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/19/22.
//

import SwiftUI
import Kingfisher
import Resolver

struct LaunchesListSectionView: View {
    @StateObject private var viewmodel = DefaultLaunchesListSectionViewModel(launchRepository: Resolver.resolve(), rocketRepository: Resolver.resolve())
    
    var body: some View {
        SectionView(title: "LAUNCHES") {
            LaunchesListView(state: viewmodel.state) {
                viewmodel.getLaunchesList()
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Section(header: Text("Sort")) {
                        Picker(selection: $viewmodel.sort, label: Text("Sorting options")) {
                            Text("ASC").tag(SortOrder.forward)
                            Text("DESC").tag(SortOrder.reverse)
                        }
                    }
                    
                    Section(header: Text("Filter")) {
                        Picker(selection: $viewmodel.status, label: Text("Sorting options")) {
                            Text("All")
                                .tag(LaunchStatusFilter.all)
                            
                            Text("Successful")
                                .tag(LaunchStatusFilter.successOnly)
                        
                            Text("Failed")
                                .tag(LaunchStatusFilter.failedOnly)
                        }
                        
                        Text("Years")
                            .contextMenu {
                                MultiYearSelectorView(years: viewmodel.launchYears, selectedYears: $viewmodel.years)
                            }
                    }
                }
            label: {
                Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
            }
            }
        }
        .onAppear {
            viewmodel.getLaunchesList()
        }
    }
}

struct LaunchesListSectionView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchesListSectionView()
    }
}
