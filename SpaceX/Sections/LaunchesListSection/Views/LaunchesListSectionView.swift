//
//  LaunchesSectionView.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/19/22.
//

import SwiftUI
import Kingfisher

struct LaunchesListSectionView<A: LaunchesListSectionViewModel>: View {
    @StateObject private var viewmodel = A()

    let dateFormatter = DateFormatter()
    
    func model(for launch: Launch) -> LaunchCellViewModel {
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let fullDate = dateFormatter.string(from: launch.date)
        let split = fullDate.split(separator: " ")
        let timeString = String(split[1])
        let dateString = String(split[0])
        
        return .init(launch: launch, date: dateString, time: timeString)
    }
    
    var body: some View {
        SectionView(title: "LAUNCHES") {
            LazyVStack(spacing: 10) {
                switch viewmodel.state {
                case .idle:
                    Text("Placeholder")
                case .loading:
                    Spacer()
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                    
                    Spacer()
                case .loaded:
                    ForEach(viewmodel.launches) { launch  in
                        LaunchCellView(model: model(for: launch))
                    }
                    .padding(.top, 16)
                case .failed(let message):
                    ErrorCell(message: message) {
                        viewmodel.getLaunchesList()
                    }
                    .padding(.top, 60)
                }
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
        LaunchesListSectionView<DesignLaunchesListSectionViewModel>()
    }
}
