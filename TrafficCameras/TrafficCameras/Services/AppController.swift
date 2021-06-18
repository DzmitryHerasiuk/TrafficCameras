//
//  AppController.swift
//  TrafficCameras
//
//  Created by Dzmitry Herasiuk on 18.06.21.
//

import Combine
import Foundation
import UIKit

class AppController: ObservableObject {
    @Published var isActive = false

    private var observers = [NSObjectProtocol]()

    init() {
        observers.append(
            NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { _ in
                self.isActive = true
                print("-= app is active")
            }
        )
        observers.append(
            NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { _ in
                self.isActive = false
                print("-= app is inactive")
            }
        )
    }

    deinit {
        observers.forEach(NotificationCenter.default.removeObserver)
    }
}
