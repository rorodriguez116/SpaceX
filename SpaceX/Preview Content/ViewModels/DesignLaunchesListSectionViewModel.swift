//
//  DesignLaunchesListSectionViewModel.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/22/22.
//

import Foundation
import Combine

final class DesignLaunchesListSectionViewModel: LaunchesListSectionViewModel {
    private var subscriptions = Set<AnyCancellable>()
    private var launches = [Launch]()
    
    @Published var sort: SortOrder = .forward
    @Published var status: LaunchFilter.Status = .all
    @Published var years = [Int]()
    
    var launchYears: [Int] = []
    
    @Published var state: ListState<[Launch]> = .idle

    init() {
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        Publishers.CombineLatest3($status, $years, $sort).sink { status, years, sort in
            // Update model and UI
            if !self.launches.isEmpty {
                let launches = LaunchFilter.applySortAndFilters(launches: self.launches, status: status, years: years, sort: sort)
                self.state = .loaded(launches)
            }
        }
        .store(in: &self.subscriptions)
    }
    
    func getLaunchesList() {
        self.state = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            var result = Launch.previewLaunches
            let rockets = Rocket.previewRockets
            result = RocketMatcher.matchRocketsToLaunches(rockets: rockets, launches: result)
            self.launchYears = Array(Set<Int>(result.map { Calendar.current.component(.year, from: $0.date) })).sorted(by: <)
            self.launches = result
            self.state = .loaded(result)
        }
    }
}
