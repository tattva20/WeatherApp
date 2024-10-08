//
//  WeatherAPI.swift
//  Weather
//
//  Created by Octavio Rojas on 10/7/24.
//

import CoreLocation

// Concrete implementation of WeatherService using OpenWeatherMap API
class WeatherAPI: WeatherService {

    // Retrieve API key from Info.plist
    private var apiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "OpenWeatherAPIKey") as? String else {
            fatalError("OpenWeatherAPIKey not found in Info.plist")
        }
        return key
    }
    
    // Retrieve Base URL from Info.plist
    private var baseURL: String {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "OpenWeatherBaseURL") as? String else {
            fatalError("OpenWeatherBaseURL not found in Info.plist")
        }
        return url
    }
    
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherData? {
        // Construct the full URL with query parameters
        let urlString = "\(baseURL)?lat=\(lat)&lon=\(lon)&appid=\(apiKey)"
        guard let url = URL(string: urlString) else {
            return nil
        }
        // Perform the network request
        let (data, _) = try await URLSession.shared.data(from: url)
        // Decode the JSON data into WeatherData model
        let decodedData = try JSONDecoder().decode(WeatherData.self, from: data)
        return decodedData
    }
}
