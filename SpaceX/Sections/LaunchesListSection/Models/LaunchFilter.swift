//
//  LaunchFilter.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/22/22.
//

import Foundation

struct LaunchFilter {
    enum Status {
        case successOnly
        case failedOnly
        case all
    }
    
    static func applySortAndFilters(launches: [Launch], status: Status, years: [Int], sort: SortOrder) -> [Launch] {
        // Read
        var launches = launches
        
        // Filter by status
        if !(status == .all)  {
            launches = launches.filter { status == .successOnly ? $0.status == .success : $0.status == .failure }
        }
        
        // Filter by years selected
        if !years.isEmpty {
            launches = launches.filter { years.contains(Calendar.current.component(.year, from: $0.date)) }
        }
        
        // Sort
        launches = launches.sorted { a, b in
            if sort == .forward {
                return a.date < b.date
            } else {
                return a.date > b.date
            }
        }
        
        return launches
    }
}
