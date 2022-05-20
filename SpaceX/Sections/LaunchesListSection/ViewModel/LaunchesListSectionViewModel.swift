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
    
    init()
    
    func getLaunchesList()
}

final class DefaultLaunchesListSectionViewModel: LaunchesListSectionViewModel {
    @Injected var launchRepository: LaunchRepository
    @Injected var rocketRepository: RocketRepository
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var launches = [Launch]()
    
    init() {}
    
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
                        
                        return collection
                    }
                    .eraseToAnyPublisher()
            }
            .receive(on: RunLoop.main)
            .sink { completion in
                print(completion)
            } receiveValue: { details in
                print(details)
                self.launches = details
            }
            .store(in: &self.subscriptions)
    }
}

final class DesignLaunchesListSectionViewModel: LaunchesListSectionViewModel {
    @Published var launches = [Launch]()
    
    func getLaunchesList() {
        self.launches = Mock.launches
    }
}
