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
    var launches: [Launch] { get set }
    var sort: SortOrder { get set }
    var status: LaunchStatusFilter { get set }
    var years: [Int] { get set }
    var launchYears: [Int] { get set }
    var state: SectionState { get }

    init()
    
    func getLaunchesList()
}

enum LaunchStatusFilter {
    case successOnly
    case failedOnly
    case all
}

class DefaultLaunchesListSectionViewModel: LaunchesListSectionViewModel {
    @Injected var launchRepository: LaunchRepository
    @Injected var rocketRepository: RocketRepository
    
    private var subscriptions = Set<AnyCancellable>()
    private var launches_ = [Launch]()
    
    @Published var launches = [Launch]()
    
    @Published var sort: SortOrder = .forward
    @Published var status: LaunchStatusFilter = .all
    @Published var years = [Int]()
    
    var launchYears: [Int] = []
    
    @Published private(set) var state: SectionState = .idle
    
    required init() {
        Publishers.CombineLatest3($status, $years, $sort).sink { status, years, sort in
            // Read
            var launches = self.launches_
            
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
            
            // Update model and UI
            self.launches = launches
        }
        .store(in: &self.subscriptions)
    }
    
    func getLaunchesList() {
        guard state.canLoad else { return }
        state = .loading
        
        launchRepository
            .getLaunchesList()
            .then { _launches -> AnyPublisher<[Launch], Error> in
                let ids = _launches.map { $0.rocketId }
                let uniqueIds = Array(Set<String>(ids))
                return self.rocketRepository.getRocketsFor(ids: uniqueIds)
                    .map { rockets in
                        let collection = _launches.compactMap { launch -> Launch in
                            guard let rocket = rockets.first(where: { $0.id == launch.rocketId }) else { return launch }
                            
                            var _launch = launch
                            _launch.rocketName = rocket.name
                            _launch.rocketType = rocket.type
                            
                            return _launch
                        }
                        
                        return collection.sorted { $0.date < $1.date }
                    }
                    .eraseToAnyPublisher()
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.state = .failed("Something went wrong.")
                }
            } receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.launches_ = result
                self.launches = result
                self.launchYears = Array(Set<Int>(result.map { Calendar.current.component(.year, from: $0.date) }))
                self.state = .loaded
            }
            .store(in: &self.subscriptions)
    }
}

final class DesignLaunchesListSectionViewModel: DefaultLaunchesListSectionViewModel {
    required init() {
        super.init()
        
        launchYears = Array(2006..<2023)
    }
    
    override func getLaunchesList() {
        self.launches = Mock.launches
    }
}
