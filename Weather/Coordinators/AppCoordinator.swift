//
//  AppCoordinator.swift
//  Weather
//
//  Created by Octavio Rojas on 10/7/24.
//

import SwiftUI

// AppCoordinator class that manages navigation and view presentation
class AppCoordinator: ObservableObject, Coordinator {
    
    // Published property to update the current view
    @Published var currentView: AnyView?
    // Reference to the WeatherViewModel
    var weatherViewModel: WeatherViewModel

    init(weatherViewModel: WeatherViewModel) {
        self.weatherViewModel = weatherViewModel
        // Set the initial view to HomeView with the coordinator and view model
        self.currentView = AnyView(
            HomeView(coordinator: self)
                .environmentObject(weatherViewModel)
        )
    }
    
    // Start function required by the Coordinator protocol
    func start() -> some View {
        currentView
    }
    
    // Function to navigate to the DetailView with weather data
    func goToDetail(with weatherData: WeatherData) {
        self.currentView = AnyView(
            DetailView(coordinator: self, weatherData: weatherData)
                .environmentObject(weatherViewModel)
        )
    }
    
    // Function to navigate back to the HomeView
    func goBack() {
        self.currentView = AnyView(
            HomeView(coordinator: self)
                .environmentObject(weatherViewModel)
        )
    }
}
