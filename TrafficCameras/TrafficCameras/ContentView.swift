//
//  ContentView.swift
//  TrafficCameras
//
//  Created by Dzmitry Herasiuk on 16.06.21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model = TrafficCamerasViewModel()

    var body: some View {
        Text("Hello, world!")
            .font(.footnote)
            .foregroundColor(Color.red)
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
