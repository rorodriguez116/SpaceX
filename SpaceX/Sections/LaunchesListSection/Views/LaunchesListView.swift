//
//  LaunchesListView.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/22/22.
//

import SwiftUI

struct LaunchesListView: View {
    let state: ListState<[Launch]>
    
    let dateFormatter = DateFormatter()
    
    let onErrorTapped: () -> ()
    
    func model(for launch: Launch) -> LaunchCellViewModel {
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let fullDate = dateFormatter.string(from: launch.date)
        let split = fullDate.split(separator: " ")
        let timeString = String(split[1])
        let dateString = String(split[0])
        
        return .init(launch: launch, date: dateString, time: timeString)
    }
    
    var body: some View {
        LazyVStack(spacing: 10) {
            switch state {
            case .idle:
                Text("Placeholder")
            case .loading:
                Spacer()
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .accessibility(addTraits: .isButton)
                    .accessibility(identifier: "loadingIndicator")
                
                Spacer()
            case .loaded(let launches):
                ForEach(launches) { launch  in
                    LaunchCellView(model: model(for: launch))
                }
                .padding(.top, 16)
                .accessibility(addTraits: .isButton)
                .accessibility(identifier: "loadedList")
                
            case .failed(let message):
                ErrorCell(message: message, onButtonTap: onErrorTapped)
                    .padding(.top, 60)
            }
        }
        
    }
}

struct LaunchesListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LaunchesListView(state: .loading) {
                
            }
            
            LaunchesListView(state: .loaded(Launch.previewLaunches)) {
                
            }
            
            LaunchesListView(state: .failed("This is a preview error message")) {
                
            }
        }
    }
}
