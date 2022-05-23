//
//  Combine+Extensions.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/19/22.
//

import Combine

extension Publisher {
    public func then<T, P>(maxPublishers: Subscribers.Demand = .unlimited, _ transform: @escaping (Self.Output) -> P) ->
    AnyPublisher<T, Self.Failure> where T == P.Output, P : Publisher, Self.Failure == P.Failure {
        self.flatMap(maxPublishers: maxPublishers, transform)
            .eraseToAnyPublisher()
    }
}
