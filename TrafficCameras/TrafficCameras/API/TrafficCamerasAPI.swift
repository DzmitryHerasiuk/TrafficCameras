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
    enum Scheme: String, HasTitle {
        case http
        case https
    }

    static let shared = TrafficCamerasAPI()

    private init() { }

    // add queries, if needed
    private func makeRequest(host: Host, path: String, method: Method) -> URLRequest? {
        var component = URLComponents()
        component.scheme = Scheme.https.title
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
    func fetchCameras() -> AnyPublisher<[CameraDTO], Never> {
        let requestOptional = makeRequest(host: .calgary,
                                          path: "/resource/k7p9-kppz.json",
                                          method: .get)
        guard let request = requestOptional else {
            return
                Just([CameraDTO]())
                .eraseToAnyPublisher()
        }
        request.toLog()
        return
            URLSession.shared.dataTaskPublisher(for: request)
                .map {
                    LogResponse(data: $0.data, response: $0.response).toLog()
                    return $0.data
                }
                .decode(type: [CameraDTO].self, decoder: JSONDecoder())
                .catch { error in
                    return Just([CameraDTO]())
                }
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
    }
}

enum AppError: Error {
    case internalError
    case backendError
}

extension HasTitle where Self: RawRepresentable, RawValue == String {

    var title: String {
        return self.rawValue
    }
}

private struct LogResponse {
    let data: Data
    let response: URLResponse
}

private extension LogResponse {

    func toLog() {
        let response = self.response as? HTTPURLResponse
        let path = response?.url?.absoluteString
        let code = response?.statusCode
        let body = data.toLog()

        let result = [
            " [Response ]",
            " [RespPath   ] \(path.orDash)",
            " [Code   ] \(code.toString.orDash)",
            " [Body   ] \(body.orDash)",
        ]
        .joined(separator: .newLine)
        print(Date.now)
        print(result)
    }
}

private extension URLRequest {

    func toLog() {
        let result = [
            " [Request ]",
            " [URL     ] \((url?.absoluteString).orDash)",
            ]
        .joined(separator: .newLine)
        print(Date.now)
        print(result)
    }
}

extension Error {

    func toLog() {
        print(Date.now)
        print(self)
    }
}

extension Data {

    func toLog() -> String? {
        guard
            let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let json = String(data: data, encoding: .utf8)
        else {
            return nil
        }
        return json
    }
}

extension String {

    static var newLine: String {
        return "\n"
    }

    static var empty: String {
        return ""
    }
}

private extension Optional where Wrapped == String {

    var orDash: String {
        return self ?? "---"
    }
}

private extension Optional where Wrapped == Int {

    var toString: String? {
        return self.map { String($0) }
    }
}

extension Date {

    static var now: Self {
        return Date()
    }
}

