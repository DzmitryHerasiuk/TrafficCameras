//
//  TrafficCamerasAPI.swift
//  TrafficCameras
//
//  Created by Dzmitry Herasiuk on 17.06.21.
//

import Foundation
import Combine

protocol HasTitle {
    var title: String { get }
}

class TrafficCamerasAPI {
    enum Host: String, HasTitle {
        case calgary = "data.calgary.ca"
    }
    enum Method: String, HasTitle {
        case get = "GET"
        case post = "POST"
    }
    private let scheme = "https"

    // add queries, if needed
    private func makeRequest(host: Host, path: String, method: Method) -> URLRequest? {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host.title
        component.path = path
        guard let url = component.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.title
        return request
    }
}

extension TrafficCamerasAPI {

    // added processing error if needed
    //https://data.calgary.ca/resource/k7p9-kppz.json
    func fetchCameras() -> AnyPublisher<[Camera], Never> {
        let requestOptional = makeRequest(host: .calgary,
                                          path: "resource/k7p9-kppz.json",
                                          method: .get)
        guard let request = requestOptional else {
            return
                Just([Camera]())
                .eraseToAnyPublisher()
        }
        return
            URLSession.shared.dataTaskPublisher(for: request)
                .map { $0.data }
                .decode(type: [Camera].self, decoder: JSONDecoder())
                .catch { error in Just([Camera]()) }
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
    }
}

extension HasTitle where Self: RawRepresentable, RawValue == String {

    var title: String {
        return self.rawValue
    }
}
