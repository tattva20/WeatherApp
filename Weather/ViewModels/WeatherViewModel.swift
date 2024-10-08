//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Octavio Rojas on 10/7/24.
//

import SwiftUI

// ViewModel to handle weather data fetching and state management
class WeatherViewModel: ObservableObject {

    // Published properties to update the UI
    @Published var weatherData: WeatherData?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentCity: String?

    // References to the weather service and location manager
    var weatherService: WeatherService
    var locationManager: LocationManaging

    init(weatherService: WeatherService, locationManager: LocationManaging) {
        self.locationManager = locationManager
        self.weatherService = weatherService
    }
    
    // Function to load weather data for a given city
    func loadWeather(for city: String) async {
        await MainActor.run {
            self.isLoading = true
            self.errorMessage = nil
        }
        do {
            // Get coordinates for the city
            let coordinates = try await locationManager.getCoordinates(for: city)
            // Fetch weather data using the coordinates
            if let weatherResponse = try await weatherService.fetchWeather(lat: coordinates.latitude, lon: coordinates.longitude) {
                await MainActor.run {
                    self.weatherData = weatherResponse
                    isLoading = false
                    errorMessage = nil
                    // Save the last searched city
                    UserDefaults.standard.set(city, forKey: "LastSearchedCity")
                }
            } else {
                await MainActor.run {
                    errorMessage = "Cannot retrieve weather data"
                    isLoading = false
                }
            }
        } catch {
            await MainActor.run {
                // Handle errors and update the error message
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
    
    // Function to load weather data based on the current location
    func loadCurrentLocation() async {
        await MainActor.run {
            self.isLoading = true
            self.errorMessage = nil
        }
        do {
            // Request current location coordinates
            let coordinates = try await locationManager.requestCurrentLocation()
            // Get the city name from the coordinates
            let city = try await locationManager.getCityName(for: coordinates)
            await MainActor.run {
                self.currentCity = city
                self.isLoading = false
                self.errorMessage = nil
            }
        } catch {
            await MainActor.run {
                // Handle errors and update the error message
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
