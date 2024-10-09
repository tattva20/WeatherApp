# WeatherApp

## Overview

WeatherApp is a native iOS application built with SwiftUI and UIKit that allows users to search for current weather information in US cities. Leveraging the OpenWeatherMap API, the app provides real-time weather data, including temperature, conditions, wind speed, and more. Additionally, it supports location-based weather retrieval and caches weather icons to enhance performance.

## Features

- **Search for US Cities**: Enter any US city to retrieve current weather details.
- **Real-Time Weather Data**: Displays temperature, weather conditions, wind speed, humidity, and visibility.
- **Weather Icons**: Automatically downloads and caches relevant weather icons for visual representation.
- **Auto-Load Last Searched City**: Remembers the last city searched and loads its weather data upon app launch.
- **Location-Based Weather**: Requests access to the user's location and fetches weather data based on it if permission is granted.
- **Responsive Design**: Supports both portrait and landscape orientations, adapting the UI for different size classes.
- **Accessibility**: Comprehensive accessibility support, including VoiceOver compatibility.
- **Localization**: Prepared for multiple languages, currently supporting English and Spanish.
- **Robust Error Handling**: Gracefully handles errors with user-friendly messages.
- **Unit and UI Testing**: Includes unit tests for ViewModel and Model layers, and UI tests for key interactions.

## Technologies Used

- **SwiftUI & UIKit**: For building the user interface.
- **MVVM-C Architecture**: Model-View-ViewModel-Coordinator pattern for clean code separation.
- **Combine**: For handling asynchronous events and data streams.
- **CoreLocation**: To access the user's location.
- **MapKit**: To display maps within the app.
- **URLSession**: For network requests to the OpenWeatherMap API.
- **NSCache**: To cache downloaded weather icons.
- **XCTest**: For unit and UI testing.

## Installation

### Prerequisites

- **Xcode**: Ensure you have Xcode installed (version 14.0 or later recommended).
- **Git**: To clone the repository.

### Steps

1. **Clone the Repository**

    ```bash
    git clone https://github.com/tattva20/WeatherApp.git
    ```

2. **Navigate to the Project Directory**

    ```bash
    cd WeatherApp
    ```

3. **Open the Project in Xcode**

    ```bash
    open WeatherApp.xcodeproj
    ```

4. **Configure API Key**

    - **Obtain an API Key**:
      - Sign up or log in to [OpenWeatherMap](https://openweathermap.org/api) to obtain your API key.
    
    - **Add API Key to `Info.plist`**:
      - Open `Info.plist` in Xcode.
      - Add a new key `OpenWeatherAPIKey` and set its value to your OpenWeatherMap API key.
      - Ensure that `OpenWeatherBaseURL` is set appropriately, for example:
        ```
        https://api.openweathermap.org/data/2.5/weather
        ```
    
    - **Secure Your API Key**:
      - Make sure that `Info.plist` is included in your `.gitignore` if you prefer not to expose your API key publicly. Alternatively, consider using environment variables or a secure storage method for sensitive information.

5. **Build and Run the App**

    - **Select Target Device**:
      - Choose your desired simulator or connect your physical iOS device.
    
    - **Run the App**:
      - Press **Run** (⌘R) in Xcode to build and launch the application.
    
    - **Grant Location Permissions**:
      - Upon first launch, the app will request access to your location. Granting permission will allow the app to fetch weather data based on your current location automatically.

6. **Using the App**

    - **Search for a City**:
      - Enter the name of a US city in the search field.
      - Tap on **Get Weather Report** to retrieve and display the current weather information.
    
    - **View Weather Details**:
      - The app displays temperature, weather conditions, wind speed, humidity, and more.
      - A weather icon represents the current conditions.
      - A map view shows the location of the city.
    
    - **Auto-Load Last Searched City**:
      - The app remembers the last city you searched for and automatically loads its weather data upon subsequent launches.

7. **Running Tests**

    - **Unit Tests**:
      - Located in the `WeatherTests` target, covering ViewModel and Model layers.
    
    - **UI Tests**:
      - Located in the `WeatherUITests` target, covering key user interactions.
    
    - **Execute Tests**:
      - In Xcode, select the desired test scheme and press **Command + U** or navigate to **Product > Test** to run the tests.

8. **Contributing**

    Contributions are welcome! Please follow these steps to contribute:

    1. **Fork the Repository**
    
    2. **Create a New Branch**
    
        ```bash
        git checkout -b feature/YourFeatureName
        ```
    
    3. **Commit Your Changes**
    
        ```bash
        git commit -m "Add your message here"
        ```
    
    4. **Push to the Branch**
    
        ```bash
        git push origin feature/YourFeatureName
        ```
    
    5. **Create a Pull Request**
    
    Please ensure that your code adheres to the existing coding standards and passes all tests before submitting a pull request.

9. **License**

    This project is licensed under the [MIT License](LICENSE).

10. **Acknowledgements**

    - [OpenWeatherMap](https://openweathermap.org/) for providing the weather API.
    - Apple's SwiftUI and Combine frameworks for enabling modern iOS development.
    - [Swift GitHub .gitignore](https://github.com/github/gitignore/blob/main/Swift.gitignore) for the recommended `.gitignore` settings.

11. **Contact**

    For any inquiries or feedback, please contact [Tattva20](mailto:financieraufc@gmail.com).

