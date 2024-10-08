//
//  DetailView.swift
//  Weather
//
//  Created by Octavio Rojas on 10/7/24.
//

import SwiftUI
import MapKit

struct DetailView: View {
    
    @StateObject private var imageLoader: ImageLoader
    
    var coordinator: AppCoordinator
    var weatherData: WeatherData
    
    // Computed property for the coordinate
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: weatherData.coord.lat,
            longitude: weatherData.coord.lon
        )
    }
    
    init(coordinator: AppCoordinator, weatherData: WeatherData) {
        self.coordinator = coordinator
        self.weatherData = weatherData
        let iconCode = weatherData.weather.first?.icon ?? "01d"
        let urlString = "https://openweathermap.org/img/wn/\(iconCode)@2x.png"
        let url = URL(string: urlString)
        _imageLoader = StateObject(wrappedValue: ImageLoader(url: url))
    }
    
    var body: some View {
        GeometryReader { geometry in
            Group {
                let isPortrait = geometry.size.height >= geometry.size.width
                
                if isPortrait {
                    // Portrait layout
                    portraitLayout
                } else {
                    // Landscape layout
                    landscapeLayout
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    // Portrait layout using VStack
    var portraitLayout: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(String(format: NSLocalizedString("weather_in", comment: "Title showing weather in a city"), weatherData.name))
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityLabel(NSLocalizedString("weather_in", comment: "Title showing weather in a city"))
                    .accessibilityIdentifier("weather_in_label")
                
                if let image = imageLoader.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .accessibilityIdentifier("weather_icon_image")
                } else {
                    ProgressView()
                        .frame(width: 100, height: 100)
                        .padding()
                        .accessibilityIdentifier("weather_icon_loading")
                }
                Text(String(format: NSLocalizedString("temperature_label", comment: "Label for temperature"), kelvinToFahrenheit(weatherData.main.temp)))
                    .font(.title2)
                    .accessibilityLabel(String(format: NSLocalizedString("temperature_label_accessibility", comment: "Accessibility label for temperature"), kelvinToFahrenheit(weatherData.main.temp)))
                    .accessibilityIdentifier("temperature_label")
                Text(String(format: NSLocalizedString("condition_label", comment: "Label for condition"), weatherData.weather.first?.description.capitalized ?? NSLocalizedString("n_a", comment: "Not Available")))
                    .font(.title2)
                    .accessibilityLabel(String(format: NSLocalizedString("condition_label_accessibility", comment: "Accessibility label for condition"), weatherData.weather.first?.description.capitalized ?? NSLocalizedString("n_a", comment: "Not Available")))
                    .accessibilityIdentifier("condition_label")
                
                MapView(coordinate: coordinate)
                    .frame(height: 200)
                    .cornerRadius(10)
                    .padding()
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(String(format: NSLocalizedString("map_label", comment: "Label for map"), weatherData.name))
                    .accessibilityIdentifier("location_mapview")
                    .accessibilityHint(NSLocalizedString("map_hint", comment: "Hint for map interaction"))
                                    
                Button(action: {
                    coordinator.goBack()
                }) {
                    Text(NSLocalizedString("go_back_button", comment: "Button to go back"))
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .accessibilityLabel(NSLocalizedString("go_back_button", comment: "Button to go back"))
                .accessibilityHint(NSLocalizedString("go_back_hint", comment: "Hint for go back button"))
                .accessibilityIdentifier("go_back_button")
                .padding(.bottom)
            }
        }
    }
    
    // Landscape layout using HStack
    var landscapeLayout: some View {
        ScrollView {
            HStack {
                VStack {
                    Text(String(format: NSLocalizedString("weather_in", comment: "Title showing weather in a city"), weatherData.name))
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityLabel(String(format: NSLocalizedString("weather_in", comment: "Title showing weather in a city"), weatherData.name))
                        .accessibilityIdentifier("weather_in_label")
                    
                    if let image = imageLoader.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .accessibilityHidden(true)
                            .accessibilityIdentifier("weather_icon_image")
                    } else {
                        ProgressView()
                            .frame(width: 100, height: 100)
                            .padding()
                            .accessibilityHidden(true)
                            .accessibilityIdentifier("weather_icon_loading")
                    }
                    
                    Text(String(format: NSLocalizedString("temperature_label", comment: "Label for temperature"), kelvinToFahrenheit(weatherData.main.temp)))
                        .font(.title3)
                        .accessibilityLabel(String(format: NSLocalizedString("temperature_label_accessibility", comment: "Accessibility label for temperature"), kelvinToFahrenheit(weatherData.main.temp)))
                        .accessibilityIdentifier("temperature_label")
                                      
                    Text(String(format: NSLocalizedString("condition_label", comment: "Label for condition"), weatherData.weather.first?.description.capitalized ?? NSLocalizedString("n_a", comment: "Not Available")))
                        .font(.title3)
                        .accessibilityLabel(String(format: NSLocalizedString("condition_label_accessibility", comment: "Accessibility label for condition"), weatherData.weather.first?.description.capitalized ?? NSLocalizedString("n_a", comment: "Not Available")))
                        .accessibilityIdentifier("condition_label")
                }
                .accessibilityElement(children: .combine)
                
                MapView(coordinate: coordinate)
                    .frame(height: 250)
                    .cornerRadius(10)
                    .padding()
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(String(format: NSLocalizedString("map_label", comment: "Label for map"), weatherData.name))
                    .accessibilityIdentifier("location_mapview")
                    .accessibilityHint(NSLocalizedString("map_hint", comment: "Hint for map interaction"))
            }
            
            Button(action: {
                coordinator.goBack()
            }) {
                Text(NSLocalizedString("go_back_button", comment: "Button to go back"))
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .accessibilityLabel(NSLocalizedString("go_back_button", comment: "Button to go back"))
            .accessibilityHint(NSLocalizedString("go_back_hint", comment: "Hint for go back button"))
            .accessibilityIdentifier("go_back_button")
        }
        .frame(maxWidth: 630)
    }
    
    // Function to convert temperature from Kelvin to Fahrenheit
    func kelvinToFahrenheit(_ kelvin: Double) -> String {
        let fahrenheit = (kelvin - 273.15) * 9 / 5 + 32
        return String(format: "%.1f", fahrenheit)
    }
}

#Preview {
    let locationManager = LocationManager()
    let service = WeatherAPI()
    let viewModel = WeatherViewModel(weatherService: service, locationManager: locationManager)
    let coordinator = AppCoordinator(weatherViewModel: viewModel)
    let weatherData = WeatherData(
        coord: Coord(lon: -122.4194, lat: 37.7749),
        weather: [Weather(id: 800, main: "Clear", description: "clear sky", icon: "01d")],
        base: "stations",
        main: Main(temp: 293.15, feelsLike: 293.15, tempMin: 290.15, tempMax: 296.15, pressure: 1013, humidity: 50, seaLevel: 1013, grndLevel: 1009),
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
    return DetailView(coordinator: coordinator, weatherData: weatherData)
}
