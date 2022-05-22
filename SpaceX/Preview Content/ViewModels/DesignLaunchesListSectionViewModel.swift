//
//  DesignLaunchesListSectionViewModel.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/22/22.
//

import Foundation

final class DesignLaunchesListSectionViewModel: DefaultLaunchesListSectionViewModel {
    required init() {
        super.init()
        
        launchYears = Array(2006..<2023)
    }
    
    override func getLaunchesList() {
        guard state.canLoad else { return }
        self.state = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.launches = Launch.previewLaunches
            self.state = .loaded
        }
    }
}
