//
//  WeatherData.swift
//  Weather
//
//  Created by Octavio Rojas on 10/7/24.
//

import Foundation

// MARK: - WeatherData
// Model representing the weather data returned by the API
struct WeatherData: Codable {
    
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
    
}

// MARK: - Clouds
// Model for cloud information
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
// Model for geographical coordinates
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
// Model for main weather parameters
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity, seaLevel, grndLevel: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Sys
// Model for system data
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
// Model for weather condition descriptions
struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

// MARK: - Wind
// Model for wind information
struct Wind: Codable {
    let speed: Double
    let deg: Int
}
