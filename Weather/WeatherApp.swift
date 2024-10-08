//
//  WeatherApp.swift
//  Weather
//
//  Created by Octavio Rojas on 10/7/24.
//

import SwiftUI

@main
struct WeatherApp: App {
    
    // StateObject to hold the AppCoordinator instance
    @StateObject var coordinator: AppCoordinator

    init() {
        // Initialize location manager and weather service
        let locationManager = LocationManager()
        let service = WeatherAPI()
        
        // Initialize the view model with the weather service and location manager
        let viewModel = WeatherViewModel(weatherService: service, locationManager: locationManager)
        
        // Initialize the AppCoordinator with required dependencies
        _coordinator = StateObject(
            wrappedValue: AppCoordinator(weatherViewModel: viewModel))
        
        // Handle launch arguments for UI testing
           #if DEBUG
           let arguments = CommandLine.arguments
           if arguments.contains("-UITesting") {
               if let cityIndex = arguments.firstIndex(of: "-lastSearchedCity"),
                  cityIndex + 1 < arguments.count {
                   let lastCity = arguments[cityIndex + 1]
                   UserDefaults.standard.set(lastCity, forKey: "LastSearchedCity")
               }
           }
           #endif
    }
    
    var body: some Scene {
        WindowGroup {
            // Start the app with ContentView, passing the coordinator
            ContentView(coordinator: coordinator)
        }
    }
}
