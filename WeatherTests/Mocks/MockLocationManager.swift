//
//  MockLocationManager.swift
//  WeatherTests
//
//  Created by Octavio Rojas on 10/8/24.
//

import CoreLocation
@testable import Weather

class MockLocationManager: LocationManaging {
    var shouldReturnError = false
    var mockCoordinates: CLLocationCoordinate2D?
    var mockCityName: String?
    
    func requestCurrentLocation() async throws -> CLLocationCoordinate2D {
        if shouldReturnError {
            throw NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock location error"])
        }
        guard let coordinates = mockCoordinates else {
            throw NSError(domain: "MockError", code: 2, userInfo: [NSLocalizedDescriptionKey: "No coordinates provided"])
        }
        return coordinates
    }
    
    func getCoordinates(for city: String) async throws -> CLLocationCoordinate2D {
        if shouldReturnError {
            throw NSError(domain: "MockError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Mock geocoding error"])
        }
        guard let coordinates = mockCoordinates else {
            throw NSError(domain: "MockError", code: 4, userInfo: [NSLocalizedDescriptionKey: "No coordinates for city"])
        }
        return coordinates
    }
    
    func getCityName(for coordinates: CLLocationCoordinate2D) async throws -> String {
        if shouldReturnError {
            throw NSError(domain: "MockError", code: 5, userInfo: [NSLocalizedDescriptionKey: "Mock reverse geocoding error"])
        }
        guard let cityName = mockCityName else {
            throw NSError(domain: "MockError", code: 6, userInfo: [NSLocalizedDescriptionKey: "No city name for coordinates"])
        }
        return cityName
    }
}
