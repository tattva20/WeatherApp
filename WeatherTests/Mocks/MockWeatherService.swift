//
//  MockWeatherService.swift
//  WeatherTests
//
//  Created by Octavio Rojas on 10/8/24.
//

import Foundation
@testable import Weather

class MockWeatherService: WeatherService {
    var shouldReturnError = false
    var weatherData: WeatherData?

    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherData? {
        if shouldReturnError {
            throw NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
        }
        return weatherData
    }
}
