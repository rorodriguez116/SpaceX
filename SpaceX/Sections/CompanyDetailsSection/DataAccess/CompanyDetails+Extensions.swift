//
//  CompanyDetails+Extensions.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/19/22.
//

import Foundation

extension CompanyDetails: Decodable {
    enum CodingKeys: String, CodingKey {
        case summary = "summary"
        case companyName = "name"
        case founderName = "founder"
        case year = "founded"
        case employeesCount = "employees"
        case launchSitesCount = "launch_sites"
        case valuation = "valuation"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        companyName = try values.decode(String.self, forKey: .companyName)
        summary = try values.decode(String.self, forKey: .summary)
        founderName = try values.decode(String.self, forKey: .founderName)
        year = try values.decode(Int.self, forKey: .year)
        employeesCount = try values.decode(Int.self, forKey: .employeesCount)
        launchSitesCount = try values.decode(Int.self, forKey: .launchSitesCount)
        valuation = try values.decode(Double.self, forKey: .valuation)
    }
}
