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
    @Injected var repository: LaunchRepository
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var launches = [Launch]()
    
    init() {}
    
    func getLaunchesList() {
        repository.getLaunchesList()
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
