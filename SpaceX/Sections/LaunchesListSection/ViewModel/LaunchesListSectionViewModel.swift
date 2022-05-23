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
    var status: LaunchFilter.Status { get set }
    var years: [Int] { get set }
    var launchYears: [Int] { get set }
    var state: ListState<[Launch]> { get }

    init()
    
    func getLaunchesList()
}

final class DefaultLaunchesListSectionViewModel: LaunchesListSectionViewModel {
    @Injected private var launchRepository: LaunchRepository
    @Injected private var rocketRepository: RocketRepository
    
    private var subscriptions = Set<AnyCancellable>()
    private var launches = [Launch]()
     
    @Published var launchYears: [Int] = []
    @Published var sort: SortOrder = .forward
    @Published var status: LaunchFilter.Status = .all
    @Published var years = [Int]()
    @Published var state: ListState<[Launch]> = .idle
    
    init() {
        self.setupSubscriptions()
    }
    
    var getLaunchesListWithMatchingRocketDataPublisher: AnyPublisher<[Launch], Error> {
        state = .loading

        return launchRepository
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
            if !self.launches.isEmpty {
                // Update model and UI
                let launches = self.applySortAndFilters(launches: self.launches, status: status, years: years, sort: sort)
                let launchesFilterByStatus = self.applySortAndFilters(launches: self.launches, status: status, years: [], sort: sort)
                
                self.updateUI(with: launches, resultByStatus: launchesFilterByStatus)
            }
        }
        .store(in: &self.subscriptions)
    }
    
    private func applySortAndFilters(launches: [Launch], status: LaunchFilter.Status, years: [Int], sort: SortOrder) -> [Launch] {
        LaunchFilter.applySortAndFilters(launches: launches, status: status, years: years, sort: sort)
    }
    
    /// Returns a list of updated launches containing new data of its corresponding rockets.
    private func matchRocketsToLaunches(rockets: [Rocket], launches: [Launch]) -> [Launch] {
        RocketMatcher.matchRocketsToLaunches(rockets: rockets, launches: launches)
    }
    
    func updateUI(with result: [Launch], resultByStatus: [Launch]) {
        self.state = .loaded(result)
        self.launchYears = Array(Set<Int>(resultByStatus.map { Calendar.current.component(.year, from: $0.date) })).sorted(by: <)
    }
    
    func updateUI(with errorMessage: String) {
        self.state = .failed(errorMessage)
    }
    
    func getLaunchesList() {
        getLaunchesListWithMatchingRocketDataPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.updateUI(with: "Something went wrong.")
                }
            } receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.launches = result
                self.updateUI(with: result, resultByStatus: result)
            }
            .store(in: &self.subscriptions)
    }
}
