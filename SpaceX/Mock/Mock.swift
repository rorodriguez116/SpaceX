//
//  Mock.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/19/22.
//

import Foundation

struct Mock {
    static let companyDetail = CompanyDetails(companyName: "SpaceX", summary: "SpaceX designs, manufactures and launches advanced rockets and spacecraft. The company was founded in 2002 to revolutionize space technology, with the ultimate goal of enabling people to live on other planets.", founderName: "Elon Musk", year: 2002, employeesCount: 9500, launchSitesCount: 3, valuation: 74000000000.0)
    
    static var launches: [Launch] {
        let bundle = Bundle(for: DefaultCompanyDetailsSectionViewModel.self)
        guard let url = bundle.url(forResource: "Launch", withExtension: "json") else { return [] }
        let data = try! Data(contentsOf: url)
        let launches = try! JSONDecoder().decode([Launch].self, from: data)
        return launches
    }
}
