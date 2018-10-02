//
//  MapViewController.swift
//  Yelp
//
//  Created by Joseph Andy Feidje on 10/1/18.
//  Copyright © 2018 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var rateImageView: UIImageView!
    @IBOutlet weak var imageDescriptionView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager : CLLocationManager!
    
    var restaurants: [Business] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rest = restaurants[0]
        var centerLocation = CLLocation(latitude: rest.latitude!, longitude: rest.longitude!)
        print("longitude --------------------->>",rest.longitude,"------------latutude ",rest.latitude)
        
        // Do any additional setup after loading the view.
        // set the region to display, this also sets a correct zoom level
        // set starting center location in San Francisco
//        centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
//        print("------------------------------>>>> ",centerLocation)
        goToLocation(location: centerLocation)
        imageDescriptionView.setImageWith(rest.imageURL!)
        rateImageView.image = rest.ratingImage
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: false)
        }
    }
    
    // add an Annotation with a coordinate: CLLocationCoordinate2D
    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "An annotation!"
        mapView.addAnnotation(annotation)
    }

    // add an annotation with an address: String
    func addAnnotationAtAddress(address: String, title: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count != 0 {
                    let coordinate = placemarks.first!.location!
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate.coordinate
                    annotation.title = title
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }
    
//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        let identifier = "customAnnotationView"
//        
//        // custom image annotation
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//        if (annotationView == nil) {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//        }
//        else {
//            annotationView!.annotation = annotation
//        }
//        annotationView!.image = UIImage(named: "customAnnotationImage")
//        
//        return annotationView
//    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "customAnnotationView"
        // custom pin annotation
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        else {
            annotationView!.annotation = annotation
        }
        annotationView!.pinTintColor = UIColor.green
        
        return annotationView
    }
}
