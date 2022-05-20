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
    
    init()
    
    func getLaunchesList()
}

enum LaunchStatusFilter {
    case successOnly
    case failedOnly
    case all
}

final class DefaultLaunchesListSectionViewModel: LaunchesListSectionViewModel {
    @Injected var launchRepository: LaunchRepository
    @Injected var rocketRepository: RocketRepository
    
    private var subscriptions = Set<AnyCancellable>()
    private var launches_ = [Launch]()
    
    @Published var launches = [Launch]()
    
    @Published var sort: SortOrder = .forward
    @Published var status: LaunchStatusFilter = .all
    @Published var years = [Int]()
    
    init() {
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
        launchRepository
            .getLaunchesList()
            .then { _launches -> AnyPublisher<[Launch], Error> in
                let ids = _launches.map { $0.rocketId }
                return self.rocketRepository.getRocketsFor(ids: ids)
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
            .sink { completion in
                print(completion)
            } receiveValue: { details in
                print(details)
                self.launches_ = details
                self.launches = details
            }
            .store(in: &self.subscriptions)
    }
}

final class DesignLaunchesListSectionViewModel: LaunchesListSectionViewModel {
    @Published var launches = [Launch]()
    
    @Published var sort: SortOrder = .forward
    @Published var status: LaunchStatusFilter = .all
    @Published var years = [Int]()
    
    private var subscriptions = Set<AnyCancellable>()

    init() {        
        $sort.sink { sort in
            self.launches = self.launches.sorted { a, b in
                if sort == .forward {
                    return a.date < b.date
                } else {
                    return a.date > b.date
                }
            }
        }
        .store(in: &self.subscriptions)
        
        $status.sink { status in
            
        }
        .store(in: &self.subscriptions)
        
        $years.sink { years in
            
        }
        .store(in: &self.subscriptions)
    }
    
    func getLaunchesList() {
        self.launches = Mock.launches
    }
}
