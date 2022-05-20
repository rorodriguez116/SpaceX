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

    func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
            
            Spacer()
            
            Text(value)
        }
    }
    
    var body: some View {
        SectionView(title: "LAUNCHES") {
            VStack {
                ForEach(viewmodel.launches) { launch  in
                    HStack(alignment: .top) {
                        KFImage(launch.missionImageUrl)
                            .resizable()
                            .frame(width: 45, height: 45, alignment: .center)
                        
                        VStack {
                            detailRow(label: "Mission", value: launch.missionName)
                            detailRow(label: "Date/time", value: launch.date.formatted(date: .abbreviated, time: .standard))
                            detailRow(label: "Rocket", value: launch.rocketName + "/" + launch.rocketType)
                            detailRow(label: "Days since:", value: "10000")
                        }
                        
                        if launch.status != nil {
                            Circle()
                                .foregroundColor(launch.status! == .success ? .green : .red)
                                .frame(width: 20, height: 20, alignment: .center)
                        }
                    }
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
