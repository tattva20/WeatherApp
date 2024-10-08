//
//  WeatherUITests.swift
//  WeatherUITests
//
//  Created by Octavio Rojas on 10/7/24.
//

import XCTest

final class WeatherUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app = XCUIApplication()

        // Add an interruption monitor to handle location permission alerts
        addUIInterruptionMonitor(withDescription: "Location Permission") { alert -> Bool in
            if alert.buttons["Allow While Using App"].exists {
                alert.buttons["Allow While Using App"].tap()
                return true
            }
            if alert.buttons["Don’t Allow"].exists {
                alert.buttons["Don’t Allow"].tap()
                return true
            }
            return false
        }

        // Launch the app
        app.launch()

        // Trigger the interruption monitor by interacting with the app
        // For example, tapping the screen to ensure the alert is presented
        app.tap()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // Test searching for weather in a city
    func testSearchCityWeather() throws {
        let cityTextField = app.textFields["enter_city_textfield"]
        XCTAssertTrue(cityTextField.exists, "City text field should exist")

        cityTextField.clearText()
        cityTextField.tap()
        cityTextField.typeText("San Francisco")

        let getWeatherButton = app.buttons["get_weather_report_button"]
        XCTAssertTrue(getWeatherButton.exists, "Get Weather Report button should exist")
        getWeatherButton.tap()

        let weatherLabel = app.staticTexts["weather_in_label"]
        XCTAssertTrue(weatherLabel.waitForExistence(timeout: 10), "Weather details should be displayed for San Francisco")
    }

}

extension XCUIElement {
    /// Clears the text of a text field by deleting each character.
    func clearText() {
        guard let stringValue = self.value as? String else {
            return
        }
        self.tap()
        for _ in stringValue {
            self.typeText(XCUIKeyboardKey.delete.rawValue)
        }
    }
}
