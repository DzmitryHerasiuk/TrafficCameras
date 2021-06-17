//
//  Camera.swift
//  TrafficCameras
//
//  Created by Dzmitry Herasiuk on 17.06.21.
//

struct Camera: Decodable {
    let cameraUrl: CameraURL
    let quadrant: String
    let cameraLocation: String
    let point: Point

    enum CodingKeys: String, CodingKey {
        case cameraUrl = "camera_url"
        case quadrant
        case cameraLocation = "camera_location"
        case point
    }
}

struct CameraURL: Decodable {
    let url: String
    let description: String
}

struct Point: Decodable {
    let type: PointType
    let coordinates: [Double]
}

enum PointType: String, Decodable {
    case point = "Point"
}

//enum Quadrant: String, Decodable {
//    case N = "NW/NE"
//    case NE = "NE"
//    case E = "NE/SE" // TODO: check?
//    case SE = "SE"
//    case S = "SW/SE"
//    case SW = "SW"
//    case W = "SW/NW" // TODO: check?
//    case NW = "NW"
//}
