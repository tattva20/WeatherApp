//
//  LocationManaging.swift
//  Weather
//
//  Created by Octavio Rojas on 10/8/24.
//

import CoreLocation

protocol LocationManaging {
    func requestCurrentLocation() async throws -> CLLocationCoordinate2D
    func getCoordinates(for city: String) async throws -> CLLocationCoordinate2D
    func getCityName(for coordinates: CLLocationCoordinate2D) async throws -> String
}
