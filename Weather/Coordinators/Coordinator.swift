//
//  Coordinator.swift
//  Weather
//
//  Created by Octavio Rojas on 10/7/24.
//

import SwiftUI

// Protocol defining the Coordinator pattern
protocol Coordinator {
    // Associated type for the ContentView, which must be a SwiftUI View
    associatedtype ContentView: View
    // Start function to initiate the coordinator's flow
    func start() -> ContentView
}
