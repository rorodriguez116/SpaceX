//
//  CompanyDetails.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/19/22.
//

import Foundation

struct CompanyDetails: Equatable {
    /// The name of the company.
    let companyName: String
    /// A summary of the company.
    let summary: String?
    /// The name of the company's founder
    let founderName: String
    /// The year the company was founded.
    let year: Int
    /// The number of employees the company has.
    let employeesCount: Int
    /// The number of launch sites the company has.
    let launchSitesCount: Int
    /// The company's valuation in USD.
    let valuation: Double
}

