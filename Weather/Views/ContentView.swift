//
//  ContentView.swift
//  Weather
//
//  Created by Octavio Rojas on 10/7/24.
//

import SwiftUI

struct ContentView: View {
    // ObservedObject to listen to changes in the coordinator
    @ObservedObject var coordinator: AppCoordinator

    var body: some View {
        // Start the coordinator to determine which view to display
        coordinator.start()
            .accessibilityElement(children: .contain) // Ensures the contained views are accessible
    }
}

#Preview {
    // Preview setup for SwiftUI Canvas
    let locationManager = LocationManager()
    let service = WeatherAPI()
    let viewModel = WeatherViewModel(weatherService: service, locationManager: locationManager)
    return ContentView(coordinator: AppCoordinator(weatherViewModel: viewModel))     
}
