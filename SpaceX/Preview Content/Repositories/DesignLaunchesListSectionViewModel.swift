////
////  DesignLaunchesListSectionViewModel.swift
////  SpaceX
////
////  Created by Rolando Rodriguez on 5/22/22.
////
//
//import Foundation
//import Combine
//
//final class DesignLaunchesListSectionViewModel: LaunchesListSectionViewModel {
//    private var launches_ = [Launch]()
//    private var subscriptions = Set<AnyCancellable>()
//
//    @Published var launches = [Launch]()
//
//    @Published var sort: SortOrder = .forward
//    @Published var status: LaunchStatusFilter = .all
//    @Published var years = [Int]()
//
//    var launchYears: [Int] = []
//
//    @Published var state: SectionState = .idle
//
//    init() {
//        Publishers.CombineLatest3($status, $years, $sort).sink { status, years, sort in
//            // Read
//            var launches = self.launches_
//
//            // Filter by status
//            if !(status == .all)  {
//                launches = launches.filter { status == .successOnly ? $0.status == .success : $0.status == .failure }
//            }
//
//            // Filter by years selected
//            if !years.isEmpty {
//                launches = launches.filter { years.contains(Calendar.current.component(.year, from: $0.date)) }
//            }
//
//            // Sort
//            launches = launches.sorted { a, b in
//                if sort == .forward {
//                    return a.date < b.date
//                } else {
//                    return a.date > b.date
//                }
//            }
//
//            // Update model and UI
//            self.launches = launches
//        }
//        .store(in: &self.subscriptions)
//    }
//
//    func getLaunchesList() {
//        guard state.canLoad else { return }
//        self.state = .loading
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
//            let result = Launch.previewLaunches
//            self.launches_ = result
//            self.launches = result
//            self.launchYears = Array(Set<Int>(result.map { Calendar.current.component(.year, from: $0.date) }))
//            self.state = .loaded
//        }
//    }
//}
