//
//  WeatherDataModelTests.swift
//  WeatherTests
//
//  Created by Octavio Rojas on 10/8/24.
//

import XCTest
@testable import Weather

final class WeatherDataModelTests: XCTestCase {

    func testWeatherDataDecoding() throws {
            // Given
            let jsonString = """
            {
                "coord": {"lon": -122.4194,"lat": 37.7749},
                "weather": [{"id":800,"main":"Clear","description":"clear sky","icon":"01d"}],
                "base": "stations",
                "main": {
                    "temp": 293.15,
                    "feels_like": 293.15,
                    "temp_min": 290.15,
                    "temp_max": 296.15,
                    "pressure": 1013,
                    "humidity": 50,
                    "sea_level": 1013,
                    "grnd_level": 1009
                },
                "visibility": 10000,
                "wind": {"speed":5.0,"deg":200},
                "clouds": {"all":1},
                "dt": 1627846800,
                "sys": {"type":1,"id":5122,"country":"US","sunrise":1627823367,"sunset":1627874881},
                "timezone": -25200,
                "id": 5391959,
                "name": "San Francisco",
                "cod": 200
            }
            """
            let jsonData = try XCTUnwrap(jsonString.data(using: .utf8), "Failed to convert jsonString to Data.")

            // When
            let decoder = JSONDecoder()
            let weatherData = try decoder.decode(WeatherData.self, from: jsonData)

            // Then
            XCTAssertEqual(weatherData.name, "San Francisco")
            XCTAssertEqual(weatherData.coord.lat, 37.7749)
            XCTAssertEqual(weatherData.coord.lon, -122.4194)
            XCTAssertEqual(weatherData.weather.first?.main, "Clear")
            XCTAssertEqual(weatherData.main.temp, 293.15)
        }

}
