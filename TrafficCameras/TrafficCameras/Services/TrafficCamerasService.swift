//
//  TrafficCamerasService.swift
//  TrafficCameras
//
//  Created by Dzmitry Herasiuk on 18.06.21.
//

import Foundation
import Combine

class TrafficCamerasService {
    private let api = TrafficCamerasAPI.shared
}

extension TrafficCamerasService: CanGetCameras {

    func getCameras() -> AnyPublisher<[Camera], Never> {
        return
            api
            .fetchCameras()
            .map { camerasDTO in
                camerasDTO.map { Camera(dto: $0)}
            }.eraseToAnyPublisher()
    }
}

private extension Camera {

    init(dto: CameraDTO) {
        guard let imageURL = URL(string: dto.cameraUrl.url) else {
            preconditionFailure("URL must be")
        }
        self.init(imageURL: imageURL,
                  description: dto.cameraUrl.description,
                  quadrant: dto.quadrant,
                  cameraLocation: dto.cameraLocation)
    }
}
