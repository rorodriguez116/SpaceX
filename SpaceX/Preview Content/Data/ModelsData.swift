//
//  Mock.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/19/22.
//

import Foundation

extension Launch {
    static var previewLaunches: [Launch] {
        let bundle = Bundle(for: DefaultCompanyDetailsSectionViewModel.self)
        guard let url = bundle.url(forResource: "Launch", withExtension: "json") else { return [] }
        let data = try! Data(contentsOf: url)
        let launches = try! JSONDecoder().decode([Launch].self, from: data)
        return launches
    }
    
    static var previewLaunch: Launch {
        let index = Int.random(in: 0..<previewLaunches.count)
        return previewLaunches[index]
    }
}

extension Rocket {
    static var previewRockets: [Rocket] {
        let bundle = Bundle(for: DefaultCompanyDetailsSectionViewModel.self)
        guard let url = bundle.url(forResource: "Rockets", withExtension: "json") else { return [] }
        let data = try! Data(contentsOf: url)
        let rockets = try! JSONDecoder().decode([Rocket].self, from: data)
        return rockets
    }
    
    static var previewRocket: Rocket {
        let index = Int.random(in: 0..<previewRockets.count)
        return previewRockets[index]
    }
}

extension CompanyDetails {
    static let previewCompanyDetails = CompanyDetails(companyName: "SpaceX", summary: "SpaceX designs, manufactures and launches advanced rockets and spacecraft. The company was founded in 2002 to revolutionize space technology, with the ultimate goal of enabling people to live on other planets.", founderName: "Elon Musk", year: 2002, employeesCount: 9500, launchSitesCount: 3, valuation: 74000000000.0)
}
