//
//  HomeView.swift
//  Weather
//
//  Created by Octavio Rojas on 10/7/24.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var viewModel: WeatherViewModel
    @State private var city = UserDefaults.standard.string(forKey: "LastSearchedCity") ?? ""
    @State private var showErrorAlert = false
    
    var coordinator: AppCoordinator
    
    var body: some View {
        // Use GeometryReader to get the available size
        GeometryReader { geometry in
            let isPortrait = geometry.size.height >= geometry.size.width
            
            Group {
                if isPortrait {
                    // Portrait orientation or compact width size class
                    portraitLayout
                } else {
                    // Landscape orientation or regular width size class
                    landscapeLayout
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onAppear {
                if city.isEmpty {
                    loadCurrentLocation()
                }
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text(NSLocalizedString("error_title", comment: "Error title")),
                    message: Text(viewModel.errorMessage ?? "Unknown error"),
                    dismissButton: .default(Text(NSLocalizedString("ok_button", comment: "OK")))
                )
            }
        }
    }
    
    // Portrait layout using VStack
    var portraitLayout: some View {
        VStack {
            Spacer()
            
            Text(NSLocalizedString("weather_app_title", comment: "Title for the Weather App"))
                .font(.largeTitle)
                .padding()
                .accessibilityAddTraits(.isHeader)
                .accessibilityLabel(NSLocalizedString("weather_app_title", comment: "Title for the Weather App"))
                .accessibilityIdentifier("weather_app_title")
            
            Text(NSLocalizedString("please_enter_city", comment: "Please enter a city"))
                .font(.headline)
                .padding(.top)
                .accessibilityLabel(NSLocalizedString("please_enter_city", comment: "Prompt to enter city"))
                .accessibilityIdentifier("please_enter_city_prompt")
            
            TextField(NSLocalizedString("enter_city_placeholder", comment:  "Placeholder for city input"), text: $city)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .padding(.bottom)
                .accessibilityLabel(NSLocalizedString("enter_city_placeholder", comment: "Placeholder for city input"))
                .accessibilityIdentifier("enter_city_textfield")
                .accessibilityHint(NSLocalizedString("enter_city_hint", comment: "Hint for city input"))
            
            Button(action: getWeather) {
                Text(NSLocalizedString("get_weather_report", comment: "Button to get weather report"))
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .accessibilityLabel(NSLocalizedString("get_weather_report", comment: "Button to get weather report"))
            .accessibilityIdentifier("get_weather_report_button")
             .accessibilityHint(NSLocalizedString("get_weather_report_hint", comment: "Hint for get weather report button"))
            Spacer()
        }
    }
    
    // Landscape layout using HStack
    var landscapeLayout: some View {
        HStack {
            Spacer()
            VStack {
                Text(NSLocalizedString("weather_app_title", comment: "Title for the Weather App"))
                    .font(.largeTitle)
                    .padding()
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityLabel(NSLocalizedString("weather_app_title", comment: "Title for the Weather App"))
                    .accessibilityIdentifier("weather_app_title")
                
                Text(NSLocalizedString("please_enter_city", comment: "Prompt to enter city"))
                    .font(.headline)
                    .padding(.top)
                    .accessibilityLabel(NSLocalizedString("please_enter_city", comment: "Prompt to enter city"))
                    .accessibilityIdentifier("please_enter_city_prompt")
                
                TextField(NSLocalizedString("enter_city_placeholder", comment: "Placeholder for city input"), text: $city)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.bottom)
                    .accessibilityLabel(NSLocalizedString("enter_city_placeholder", comment: "Placeholder for city input"))
                    .accessibilityIdentifier("enter_city_textfield")
                    .accessibilityHint(NSLocalizedString("enter_city_hint", comment: "Hint for city input"))
                
                Button(action: getWeather) {
                    Text(NSLocalizedString("get_weather_report", comment: "Button to get weather report"))
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .accessibilityLabel(NSLocalizedString("get_weather_report", comment: "Button to get weather report"))
                .accessibilityIdentifier("get_weather_report_button")
                .accessibilityHint(NSLocalizedString("get_weather_report_hint", comment: "Hint for get weather report button"))
            }
            .frame(maxWidth: 400)
            
            Spacer()
        }
    }
    
    // Function to load current location weather
    func loadCurrentLocation() {
        Task {
            await viewModel.loadCurrentLocation()
            if let locationCity = viewModel.currentCity {
                self.city = locationCity
                await viewModel.loadWeather(for: locationCity)
                if let weatherData = viewModel.weatherData {
                    coordinator.goToDetail(with: weatherData)
                } else if let _ = viewModel.errorMessage {
                    showErrorAlert = true
                }
            } else if let _ = viewModel.errorMessage {
                showErrorAlert = true
            }
        }
    }
    
    // Function to get weather for the entered city
    func getWeather() {
        Task {
            await viewModel.loadWeather(for: city)
            if let weatherData = viewModel.weatherData {
                coordinator.goToDetail(with: weatherData)
            } else if let _ = viewModel.errorMessage {
                showErrorAlert = true
            }
        }
    }
}

#Preview {
    let locationManager = LocationManager()
    let service = WeatherAPI()
    let viewModel = WeatherViewModel(weatherService: service, locationManager: locationManager)
    let coordinator = AppCoordinator(weatherViewModel: viewModel)
    
    return HomeView(coordinator: coordinator)
        .environmentObject(viewModel)
}
