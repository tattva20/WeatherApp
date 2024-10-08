//
//  LocationManager.swift
//  Weather
//
//  Created by Octavio Rojas on 10/7/24.
//

import CoreLocation

// Class to manage location-related functionalities
class LocationManager: NSObject, LocationManaging {
    
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()
    // Continuation to handle async location updates
    private var locationContinuation: CheckedContinuation<CLLocationCoordinate2D, Error>?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    // Function to request the user's current location
    func requestCurrentLocation() async throws -> CLLocationCoordinate2D {
        return try await withCheckedThrowingContinuation { continuation in
            self.locationContinuation = continuation
            
            switch manager.authorizationStatus {
            case .notDetermined:
                // Request authorization if not determined
                manager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse, .authorizedAlways:
                // Request location if authorized
                manager.requestLocation()
            case .restricted, .denied:
                // Handle denied or restricted access
                continuation.resume(throwing: NSError(domain: "LocationError", code: 1, userInfo: [
                    NSLocalizedDescriptionKey: "Location access denied. Please enable location services in Settings."
                ]))
                self.locationContinuation = nil
            @unknown default:
                // Handle unknown cases
                continuation.resume(throwing: NSError(domain: "LocationError", code: 2, userInfo: [
                    NSLocalizedDescriptionKey: "Unknown authorization status."
                ]))
                self.locationContinuation = nil
            }
        }
    }
    
    // Function to get coordinates for a given city name
    func getCoordinates(for city: String) async throws -> CLLocationCoordinate2D {
        return try await withCheckedThrowingContinuation { continuation in
            // Geocode the city name to get coordinates
            geocoder.geocodeAddressString(city) { (placemarks, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                if let placemark = placemarks?.first,
                   let location = placemark.location {
                    continuation.resume(returning: location.coordinate)
                } else {
                    continuation.resume(throwing: NSError(domain: "GeocodingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No location found for city"]))
                }
            }
        }
    }
    
    // Function to get the city name from coordinates
    func getCityName(for coordinates: CLLocationCoordinate2D) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
            // Reverse geocode to get placemark information
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                if let placemark = placemarks?.first {
                    if let city = placemark.locality {
                        continuation.resume(returning: city)
                    } else {
                        continuation.resume(throwing: NSError(domain: "ReverseGeocodingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "City name not found"]))
                    }
                } else {
                    continuation.resume(throwing: NSError(domain: "ReverseGeocodingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No placemarks found"]))
                }
            }
        }
    }
    
}

// Extension to conform to CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    // Delegate method called when locations are updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first, let continuation = locationContinuation {
            continuation.resume(returning: location.coordinate)
            locationContinuation = nil
        }
    }
    
    // Delegate method called when location updates fail
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let continuation = locationContinuation {
            continuation.resume(throwing: error)
            locationContinuation = nil
        }
    }
    
    // Delegate method called when authorization status changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            // Request location if authorized
            manager.requestLocation()
        case .denied, .restricted:
            // Handle denied or restricted access
            if let continuation = locationContinuation {
                continuation.resume(throwing: NSError(domain: "LocationError", code: 1, userInfo: [
                    NSLocalizedDescriptionKey: "Location access denied. Please enable location services in Settings."
                ]))
                self.locationContinuation = nil
            }
        case .notDetermined:
            // Do nothing; authorization request is in progress
            break
        @unknown default:
            // Handle unknown cases
            if let continuation = locationContinuation {
                continuation.resume(throwing: NSError(domain: "LocationError", code: 2, userInfo: [
                    NSLocalizedDescriptionKey: "Unknown authorization status."
                ]))
                self.locationContinuation = nil
            }
        }
    }
}
