//
//  Model.swift
//  TrafficCameras
//
//  Created by Dzmitry Herasiuk on 18.06.21.
//

import Foundation

struct Camera: Identifiable {
    let id = UUID()
    let imageURL: URL
    let description: String
    let quadrant: String
    let cameraLocation: String
}
