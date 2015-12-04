//
//  ViewController.swift
//  Coffee
//
//  Created by Melissa on 12/4/15.
//  Copyright © 2015 DLHackDay. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var mapView: MKMapView?
    
    var locationManager: CLLocationManager?
    let distanceSpan: Double = 500
    var lastLocation: CLLocation?
    var venues: Results<Venue>?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let mapView = self.mapView {
            mapView.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onVenuesUpdated:"), name: API.notifications.venuesUpdated, object: nil)
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        if locationManager == nil {
            locationManager = CLLocationManager()
            
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager!.requestAlwaysAuthorization()
            locationManager!.distanceFilter = 50
            locationManager!.startUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        if let mapView = self.mapView {
            let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, distanceSpan, distanceSpan)
            mapView.setRegion(region, animated: true)
            
            refreshVenues(newLocation, getDataFromFoursquare: true)
        }
    }
    
    func refreshVenues(location: CLLocation?, getDataFromFoursquare: Bool = false) {
        if location != nil {
            lastLocation = location
        }
        
        if let location = lastLocation {
            if getDataFromFoursquare == true {
                CoffeeAPI.sharedInstance.getCoffeeShopsWithLocation(location)
            }
            
            let realm = try! Realm()
            
            venues = realm.objects(Venue)
            
            for venue in venues! {
                let annotation = CoffeeAnnotation(title: venue.name, subtitle: venue.address, coordinate: CLLocationCoordinate2D(latitude: Double(venue.latitude), longitude: Double(venue.longitude)))
                
                mapView?.addAnnotation(annotation)
            }
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier("annotationIdentifier")
        
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotationIdentifier")
        }
        
        view?.canShowCallout = true
        
        return view
    }
    
    func onVenuesUpdated(notification: NSNotification) {
        refreshVenues(nil)
    }


}

