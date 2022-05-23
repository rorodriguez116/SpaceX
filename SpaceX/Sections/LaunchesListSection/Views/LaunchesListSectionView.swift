//
//  LaunchesSectionView.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/19/22.
//

import SwiftUI
import Kingfisher
import Resolver

struct LaunchesListSectionView<T: LaunchesListSectionViewModel>: View {
    @StateObject private var viewmodel = T()
    
    var body: some View {
        SectionView(title: "LAUNCHES") {
            LaunchesListView(state: viewmodel.state) {
                viewmodel.getLaunchesList()
            }
            .accessibility(addTraits: .isButton)
            .accessibilityIdentifier("launchesList")
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Section(header: Text("Sort")) {
                        Picker(selection: $viewmodel.sort, label: Text("Sort")) {
                            Text("ASC").tag(SortOrder.forward)
                            Text("DESC").tag(SortOrder.reverse)
                        }
                        .accessibilityIdentifier("sortingPicker")
                    }
                    
                    Section(header: Text("Filter")) {
                        Picker(selection: $viewmodel.status, label: Text("Status")) {
                            Text("All")
                                .tag(LaunchFilter.Status.all)
                            
                            Text("Successful")
                                .tag(LaunchFilter.Status.successOnly)
                        
                            Text("Failed")
                                .tag(LaunchFilter.Status.failedOnly)
                        }
                        .accessibilityIdentifier("fontPicker")
                        
                        Text("Years")
                            .contextMenu {
                                MultiYearSelectorView(years: viewmodel.launchYears, selectedYears: $viewmodel.years)
                            }
                    }
                }
            label: {
                Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
            }
            .accessibility(addTraits: .isButton)
            .accessibilityIdentifier("menu")
                
            }
        }
        .onAppear {
            viewmodel.getLaunchesList()
        }
    }
}

struct LaunchesListSectionView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchesListSectionView<DesignLaunchesListSectionViewModel>()
    }
}
