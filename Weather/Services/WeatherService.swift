//
//  WeatherService.swift
//  Weather
//
//  Created by Octavio Rojas on 10/7/24.
//

// Protocol defining the weather service interface
protocol WeatherService {
    // Function to fetch weather data based on latitude and longitude
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherData?
}
