//
//  LaunchesListSectionViewModel.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/19/22.
//

import Foundation
import Combine
import Resolver

protocol LaunchesListSectionViewModel: ObservableObject {
    var sort: SortOrder { get set }
    var status: LaunchStatusFilter { get set }
    var years: [Int] { get set }
    var launchYears: [Int] { get set }
    var state: ListState<[Launch]> { get }

    init(launchRepository: LaunchRepository, rocketRepository: RocketRepository)
    
    func getLaunchesList()
}

enum LaunchStatusFilter {
    case successOnly
    case failedOnly
    case all
}

final class DefaultLaunchesListSectionViewModel: LaunchesListSectionViewModel {
    private var launchRepository: LaunchRepository
    private var rocketRepository: RocketRepository
    
    private var subscriptions = Set<AnyCancellable>()
    private var launches = [Launch]()
    
    @Published var sort: SortOrder = .forward
    @Published var status: LaunchStatusFilter = .all
    @Published var years = [Int]()
    
    var launchYears: [Int] = []
    
    @Published var state: ListState<[Launch]> = .idle
    
    init(launchRepository: LaunchRepository, rocketRepository: RocketRepository) {
        self.launchRepository = launchRepository
        self.rocketRepository = rocketRepository
        
        self.setupSubscriptions()
    }
    
    private var getLaunchesListWithMatchingRocketDataPublisher: AnyPublisher<[Launch], Error> {
        launchRepository
            .getLaunchesList()
            .then { _launches -> AnyPublisher<[Launch], Error> in
                let ids = _launches.map { $0.rocketId }
                let uniqueIds = Array(Set<String>(ids))
                return self.rocketRepository.getRocketsFor(ids: uniqueIds)
                    .map { rockets in
                        let collection = self.matchRocketsToLaunches(rockets: rockets, launches: _launches)
                        
                       return collection.sorted { $0.date < $1.date }
                    }
                    .eraseToAnyPublisher()
            }
    }
    
    private func setupSubscriptions() {
        Publishers.CombineLatest3($status, $years, $sort).sink { status, years, sort in
            // Update model and UI
            let launches = self.applySortAndFilters(launches: self.launches, status: status, years: years, sort: sort)
            self.state = .loaded(launches)
        }
        .store(in: &self.subscriptions)
    }
    
    private func applySortAndFilters(launches: [Launch], status: LaunchStatusFilter, years: [Int], sort: SortOrder) -> [Launch] {
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
    
    /// Returns a list of updated launches containing new data of its corresponding rockets.
    private func matchRocketsToLaunches(rockets: [Rocket], launches: [Launch]) -> [Launch] {
        let collection = launches.compactMap { launch -> Launch in
            guard let rocket = rockets.first(where: { $0.id == launch.rocketId }) else { return launch }
            
            var _launch = launch
            _launch.rocketName = rocket.name
            _launch.rocketType = rocket.type
            
            return _launch
        }
        
        return collection
    }
    
    private func updateUI(with result: [Launch]) {
        self.launches = result
        self.launchYears = Array(Set<Int>(result.map { Calendar.current.component(.year, from: $0.date) }))
        self.state = .loaded(self.launches)
    }
    
    
    func getLaunchesList() {
        guard state.canLoad else { return }
        state = .loading
        
        getLaunchesListWithMatchingRocketDataPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.state = .failed("Something went wrong.")
                }
            } receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.updateUI(with: result)
            }
            .store(in: &self.subscriptions)
    }
}
