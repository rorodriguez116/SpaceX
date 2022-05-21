//
//  LaunchCellViewModel.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/20/22.
//

import Foundation

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
    var status: Launch.Status { launch.status }
    var daysLabel: String { "Days \(daysDiff < 0 ? "since" : "from") now:" }
    var daysDiffString: String { String(abs(daysDiff)) }
    var wikipediaUrl: URL? { launch.wikiUrl }
    var articleUrl: URL? { launch.articleUrl }
    var youtubeId: String? { launch.videoId }
}
