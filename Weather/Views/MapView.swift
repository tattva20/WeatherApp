//
//  MapView.swift
//  Weather
//
//  Created by Octavio Rojas on 10/8/24.
//

import SwiftUI
import MapKit

// MapView is a SwiftUI view that wraps an MKMapView (a UIKit view) using UIViewRepresentable.
// This allows us to integrate a UIKit component into our SwiftUI app.
struct MapView: UIViewRepresentable {
    // Coordinates to display on the map
    var coordinate: CLLocationCoordinate2D
    
    // Creates and returns an MKMapView instance.
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        // Assign the coordinator as the delegate to handle MKMapViewDelegate methods.
        mapView.delegate = context.coordinator
        return mapView
    }
    
    // Updates the MKMapView when the SwiftUI view's state changes.
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Set the region to display on the map
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 10000, // The north-to-south distance (in meters) to display.
            longitudinalMeters: 10000 // The east-to-west distance (in meters) to display.
        )
        
        // Set the region on the map view, with animation.
        uiView.setRegion(region, animated: true)
        
        // Remove existing annotations
        uiView.removeAnnotations(uiView.annotations)
        
        // Add a pin annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Location"
        uiView.addAnnotation(annotation)
    }
    
    // Creates the coordinator that acts as the delegate for the MKMapView.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Coordinator class to manage MKMapViewDelegate methods.
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        // Optionally, customize annotation accessibility
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            
            let identifier = "MapPin"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                // Accessibility traits can be added here if needed
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
    }
}
