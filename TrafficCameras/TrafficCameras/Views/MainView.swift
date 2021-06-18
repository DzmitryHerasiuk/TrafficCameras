//
//  MainView.swift
//  TrafficCameras
//
//  Created by Dzmitry Herasiuk on 16.06.21.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var model = TrafficCamerasViewModel(service: TrafficCamerasService())

    var body: some View {
        VStack {
            Text(model.title)
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.all)
                .background(Color.gray)
            List(model.cameras) { camera in
                VStack {
                    Text(camera.cameraLocation)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    Text(camera.imageURL.absoluteString)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.top)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
