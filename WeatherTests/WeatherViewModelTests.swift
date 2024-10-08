//
//  WeatherViewModelTests.swift
//  WeatherTests
//
//  Created by Octavio Rojas on 10/7/24.
//

import XCTest
import CoreLocation
@testable import Weather

final class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!
    var mockWeatherService: MockWeatherService!
    var mockLocationManager: MockLocationManager!

    override func setUpWithError() throws {
        super.setUp()
        mockWeatherService = MockWeatherService()
        mockLocationManager = MockLocationManager()
        viewModel = WeatherViewModel(weatherService: mockWeatherService, locationManager: mockLocationManager)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockWeatherService = nil
        mockLocationManager = nil
        super.tearDown()
    }

    func testLoadWeatherSuccess() async {
        // Given
        let expectedWeatherData = WeatherData(
            coord: Coord(lon: -122.4194, lat: 37.7749),
            weather: [Weather(id: 800, main: "Clear", description: "clear sky", icon: "01d")],
            base: "stations",
            main: Main(
                temp: 293.15,
                feelsLike: 293.15,
                tempMin: 290.15,
                tempMax: 296.15,
                pressure: 1013,
                humidity: 50,
                seaLevel: 1013,
                grndLevel: 1009
            ),
            visibility: 10000,
            wind: Wind(speed: 5.0, deg: 200),
            clouds: Clouds(all: 1),
            dt: 1627846800,
            sys: Sys(type: 1, id: 5122, country: "US", sunrise: 1627823367, sunset: 1627874881),
            timezone: -25200,
            id: 5391959,
            name: "San Francisco",
            cod: 200
        )

        mockWeatherService.weatherData = expectedWeatherData
        mockLocationManager.mockCoordinates = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)

        // When
        await viewModel.loadWeather(for: "San Francisco")

        // Then
        XCTAssertEqual(viewModel.weatherData?.name, "San Francisco")
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testLoadWeatherFailure() async {
        // Given
        mockWeatherService.shouldReturnError = true

        // When
        await viewModel.loadWeather(for: "Invalid City")

        // Then
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertNil(viewModel.weatherData)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testLoadCurrentLocationSuccess() async {
        // Given
        mockLocationManager.mockCoordinates = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        mockLocationManager.mockCityName = "San Francisco"

        // When
        await viewModel.loadCurrentLocation()

        // Then
        XCTAssertEqual(viewModel.currentCity, "San Francisco")
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testLoadCurrentLocationFailure() async {
        // Given
        mockLocationManager.shouldReturnError = true

        // When
        await viewModel.loadCurrentLocation()

        // Then
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertNil(viewModel.currentCity)
        XCTAssertFalse(viewModel.isLoading)
    }
    
}
