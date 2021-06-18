//
//  TrafficCamerasTests.swift
//  TrafficCamerasTests
//
//  Created by Dzmitry Herasiuk on 16.06.21.
//

import XCTest
import Combine
@testable import TrafficCameras

class TrafficCamerasTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []

    func testSorting() {
        let sortedNumbers = [1, 2, 3]
        let mixNumbers = [3,2,5]
        let sortedLetters = ["A", "B", "C"]
        XCTAssertTrue(sortedNumbers.isSorted(<))
        XCTAssertFalse(sortedNumbers.isSorted(>))
        XCTAssertFalse(mixNumbers.isSorted(<))
        XCTAssertFalse(mixNumbers.isSorted(>))
        XCTAssertTrue(sortedLetters.isSorted(<))
        XCTAssertFalse(sortedLetters.isSorted(>))
    }

    func testSortigCameraDTOModel() {
        let camera1 = CameraDTO(cameraUrl: .init(url: "http://trafficcam.calgary.ca/loc70.jpg", description: .empty),
                                quadrant: "NE",
                                cameraLocation: "16 Avenue / 19 Street NE",
                                point: .init(type: PointType.point, coordinates: [-114.0140245, 51.067037300000003]))
        let camera2 = CameraDTO(cameraUrl: .init(url: "http://trafficcam.calgary.ca/loc38.jpg", description: .empty),
                                quadrant: "NE",
                                cameraLocation: "16 Avenue / 36 Street NE",
                                point: .init(type: PointType.point, coordinates: [-113.98141459999999, 51.066944999999997]))
        let camera3 = CameraDTO(cameraUrl: .init(url: "http://trafficcam.calgary.ca/loc70.jpg", description: .empty),
                                quadrant: "NW",
                                cameraLocation: "16 Avenue / 19 Street NE",
                                point: .init(type: PointType.point, coordinates: [-114.0140245, 51.067037300000003]))
        let sortingCameras = [camera1, camera2, camera3]
        XCTAssertTrue(sortingCameras.isSorted(<))
        let sortingCamerasBack = [camera3, camera2, camera1]
        XCTAssertTrue(sortingCamerasBack.isSorted(>))
    }

    func testSortinDataFromAPI() {
        let api = TrafficCamerasAPI.shared

        var cameras = [CameraDTO]()
        let expectation = self.expectation(description: "Awaiting cameras")

        api.fetchCameras()
            .sink { receivedCameras in
                cameras = receivedCameras
                expectation.fulfill()
            }.store(in: &cancellables)

        wait(for: [expectation], timeout: 10)

        XCTAssertFalse(cameras.isEmpty)
        XCTAssertTrue(cameras.isSorted(<))
    }

    // TODO: Add sorting testing to the TrafficCamerasViewModel entity

}

private extension Array {

    func isSorted(_ onOrder: (Element, Element) -> Bool) -> Bool {
        for i in 1 ..< count {
            if !onOrder(self[i-1], self[i]) {
                return false
            }
        }
        return true
    }
}
