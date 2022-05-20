//
//  LaunchesSectionView.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/19/22.
//

import SwiftUI
import Kingfisher

extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: to)
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
        
        return numberOfDays.day!
    }
}

struct LaunchCellView: View {
    struct LaunchCellViewModel {
        private let launch: Launch
        private let date: String
        private let time: String
        
        init(launch: Launch, date: String, time: String) {
            self.launch = launch
            self.date = date
            self.time = time
            self.daysDiff = Calendar.current.numberOfDaysBetween(Date(), and: launch.date)
        }
        
        private let daysDiff: Int

        var missionImageUrl: URL? { launch.missionImageUrl }
        var missionName: String { launch.missionName }
        var dateTime: String { date + " at " + time }
        var rocketInfo: String {  launch.rocketName + " / " + launch.rocketType }
        var status: Launch.Status? { launch.status }
        var daysLabel: String { "Days \(daysDiff < 0 ? "since" : "from") now:" }
        var daysDiffString: String { String(abs(daysDiff)) }

    }
    
    let model: LaunchCellViewModel
    
    func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
            
            Spacer()
            
            Text(value)
        }
    }
    
    var body: some View {
        HStack(alignment: .top) {
            KFImage(model.missionImageUrl)
                .resizable()
                .frame(width: 45, height: 45, alignment: .center)
            
            VStack {
                detailRow(label: "Mission:", value: model.missionName)
                detailRow(label: "Date / time:", value: model.dateTime)
                detailRow(label: "Rocket:", value: model.rocketInfo)
                detailRow(label: model.daysLabel, value: model.daysDiffString)
            }
            
            if model.status != nil {
                Circle()
                    .foregroundColor(model.status! == .success ? .green : .red)
                    .frame(width: 20, height: 20, alignment: .center)
            }
        }

    }
}

struct LaunchesListSectionView<A: LaunchesListSectionViewModel>: View {
    @StateObject private var viewmodel = A()
    
    let dateFormatter = DateFormatter()
    
    func model(for launch: Launch) -> LaunchCellView.LaunchCellViewModel {
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let fullDate = dateFormatter.string(from: launch.date)
        let split = fullDate.split(separator: " ")
        let timeString = String(split[1])
        let dateString = String(split[0])
        
        return .init(launch: launch, date: dateString, time: timeString)
    }
    
    var body: some View {
        SectionView(title: "LAUNCHES") {
            VStack {
                ForEach(viewmodel.launches) { launch  in
                    LaunchCellView(model: model(for: launch))
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
