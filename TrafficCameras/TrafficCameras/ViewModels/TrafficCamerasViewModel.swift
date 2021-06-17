//
//  TrafficCamerasViewModel.swift
//  TrafficCameras
//
//  Created by Dzmitry Herasiuk on 17.06.21.
//

import Combine

class TrafficCamerasViewModel: ObservableObject {

    @Published var cameras: [Camera] = [] {
        didSet {
            print(cameras)
        }
    }

    private let api = TrafficCamerasAPI.shared

    init() {
        api.fetchCameras()
            .assign(to: \.cameras, on: self)
            .store(in: &cancellableSet)

    }

    private var cancellableSet: Set<AnyCancellable> = []
}
