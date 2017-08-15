//
//  MapViewController.swift
//  DropItLikeItsClock
//
//  Created by Jeff Kelley on 5/19/17.
//  Copyright © 2017 Jeff Kelley. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

import Alamofire

import ClockUI

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            mapView?.showsUserLocation = true
            mapView?.userTrackingMode = .follow
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        default:
            break
        }
        
    }
    
    lazy var locationManager: CLLocationManager? = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    
    @IBAction func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        guard let mapView = mapView else { fatalError() }
        
        let point = sender.location(in: mapView)
        
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        
        Alamofire.request("https://maps.googleapis.com/maps/api/timezone/json?location=\(coordinate.latitude),\(coordinate.longitude)&timestamp=\(Int(Date().timeIntervalSince1970))&sensor=true").responseJSON { response in
            if let json = response.result.value as? [String: Any],
                let timeZoneID = json["timeZoneId"] as? String,
                let timeZone = TimeZone(identifier: timeZoneID) {
                let annotation = ClockAnnotation(coordinate: coordinate,
                                                 timeZone: timeZone)
                
                mapView.addAnnotation(annotation)
            }
        }
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ClockAnnotation {
            if let annotationView = mapView
                .dequeueReusableAnnotationView(withIdentifier: "clock")
                as? ClockAnnotationView {
                annotationView.annotation = annotation
                return annotationView
            }
            else {
                let annotationView = ClockAnnotationView(annotation: annotation,
                                                         reuseIdentifier: "clock")
                
                return annotationView
            }
        }
                
        return nil
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            mapView?.showsUserLocation = true
        default:
            mapView?.showsUserLocation = false
        }
    }
    
}
