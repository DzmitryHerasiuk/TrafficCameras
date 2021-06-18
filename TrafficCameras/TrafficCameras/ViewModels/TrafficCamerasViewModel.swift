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
    private let appController: AppController
    init(service: CanGetCameras, appController: AppController) {
        self.service = service
        self.appController = appController

        appController.$isActive
            .sink {isActive in
                if isActive {
                    service.getCameras()
                        .assign(to: \.cameras, on: self)
                        .store(in: &self.cancellableSet)
                }
            }.store(in: &cancellableSet)
    }

    @Published var cameras: [Camera] = []
    
    private var cancellableSet: Set<AnyCancellable> = []
}

extension TrafficCamerasViewModel {

    var title: String {
        return "Calgary Traffic"
    }
}
