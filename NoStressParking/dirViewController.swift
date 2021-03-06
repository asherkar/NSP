//
//  dirViewController.swift
//  NoStressParking
//
//  Created by Bhavesh Shah on 11/11/18.
//  Copyright © 2018 Bhavesh Shah. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class dirViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapKitView: MKMapView!
    
    var coordinate: CLLocationCoordinate2D! = nil
    var finalxcor = 0.0
    var finalycor = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locationManager = CLLocationManager()

        // Can use both when app is open and when app is in background.
        locationManager.requestAlwaysAuthorization()
        
        // Only use when app is open.
        //locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        mapKitView.delegate = self
        mapKitView.showsScale = true
        mapKitView.showsPointsOfInterest = true
        mapKitView.showsUserLocation = true

        //let sourceCoordinates = locationManager.location?.coordinate
        let sourceCoordinates = coordinate
        let destCoordinates = CLLocationCoordinate2DMake(finalxcor, finalycor)
        
        let sourcePlacemark = MKPlacemark (coordinate: sourceCoordinates!)
        let destPlacemark = MKPlacemark (coordinate: destCoordinates)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destItem = MKMapItem(placemark: destPlacemark)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceItem
        directionRequest.destination = destItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate(completionHandler: {
            response, error in
            guard let response = response else {
                if let error = error {
                    print("Something Went Wrong")
                }
                return
            }
            
            let route = response.routes[0]
            self.mapKitView.add(route.polyline, level: .aboveRoads)
            
            let rekt = route.polyline.boundingMapRect
            self.mapKitView.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
            })
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        
        return renderer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
