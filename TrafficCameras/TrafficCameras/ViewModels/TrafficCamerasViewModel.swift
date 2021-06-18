//
//  TrafficCamerasViewModel.swift
//  TrafficCameras
//
//  Created by Dzmitry Herasiuk on 17.06.21.
//

import Combine

protocol CanGetCameras {
    func getCameras() -> AnyPublisher<[Camera], Never>
}

class TrafficCamerasViewModel: ObservableObject {
    private let service: CanGetCameras
    init(service: CanGetCameras) {
        self.service = service
        service.getCameras()
            .assign(to: \.cameras, on: self)
            .store(in: &cancellableSet)
    }

    @Published var cameras: [Camera] = [] {
        didSet {
            print(cameras)
        }
    }

    private var cancellableSet: Set<AnyCancellable> = []
}
