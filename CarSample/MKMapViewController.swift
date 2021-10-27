//
//  MKMapViewController.swift
//  CarSample
//
//  Created by MAC240 on 22/10/21.
//

import UIKit
import MapKit
import CoreLocation



class MKMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    let mapView = MKMapView()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lat = currentLocation?.coordinate.latitude ?? 0.0
        let long = currentLocation?.coordinate.longitude ?? 0.0
        let center = CLLocationCoordinate2D(latitude: 23.030357 , longitude: 72.517845)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        mapView.addAnnotation(annotation)
        
        self.determineCurrentLocation()
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true

        mapView.center = view.center
        
    }
    
    func determineCurrentLocation()
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            
            if CLLocationManager.locationServicesEnabled() {
                //locationManager.startUpdatingHeading()
                locationManager.startUpdatingLocation()
            }
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let userLocation:CLLocation = locations[0] as CLLocation
            
            // Call stopUpdatingLocation() to stop listening for location updates,
            // other wise this function will be called every time when user location changes.
            //manager.stopUpdatingLocation()
            
            let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            mapView.setRegion(region, animated: true)
            
            // Drop a pin at user's Current Location
            let myAnnotation: MKPointAnnotation = MKPointAnnotation()
            myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
            myAnnotation.title = "Current location"
            mapView.addAnnotation(myAnnotation)
        }
        
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
        {
            print("Error \(error)")
        }
        
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
        {
            if let annotationTitle = view.annotation?.title
            {
                print("User tapped on annotation with title: \(annotationTitle)")
            }
        }
}
