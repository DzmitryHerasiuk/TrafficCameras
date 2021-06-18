//
//  ContentView.swift
//  TrafficCameras
//
//  Created by Dzmitry Herasiuk on 16.06.21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model = TrafficCamerasViewModel(service: TrafficCamerasService())

    var body: some View {
        List(model.cameras) { camera in
            VStack {
                Text(camera.cameraLocation)
                Text(camera.imageURL.absoluteString)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
