//
//  MapView.swift
//  Meetup
//
//  Created by Kevin Nguyen on 11/16/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import NotificationCenter

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    var meetups = [Meetup]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if (CLLocationManager.authorizationStatus() == .notDetermined) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.centerMapByCurrentLocation(sender:)), name: .centerMapByCurrentLocation, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.refreshTopic), name: .updateTopic, object: nil)
    }
    
    func refreshTopic(notification: Notification) {
        let annotationsToRemove = self.mapView.annotations.filter { $0 !== self.mapView.userLocation }
        mapView.removeAnnotations(annotationsToRemove)
        
        let topic = notification.userInfo?["topic"]
        let lat = locationManager.location?.coordinate.latitude.description
        let lon = locationManager.location?.coordinate.longitude.description
        let url = Meetup.meetupURLBuilder(lat: lat!, lon: lon!, topic: topic as! String)
        MeetupClient.requestGETURL(url, success: {
            (JSONResponse) -> Void in
            self.meetups = Meetup.meetupsFromJSON(json: JSONResponse)!
            for meetup in self.meetups {
                self.drawMapPin(meetup: meetup)
            }
            
            NotificationCenter.default.post(name: .meetups, object: self.meetups)
            
        }) { (error) -> Void in
            print(error)
        }
    }
    
    func drawMapPin(meetup: Meetup) {
        if ((meetup.longitude != nil) && (meetup.longitude != nil)) {
            let coordinate = CLLocationCoordinate2DMake(meetup.latitude!, meetup.longitude!)
            let annotation = CustomAnnotation(title: meetup.meetupName!, subtitle: meetup.address!, coordinate: coordinate, meetup: meetup)
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func centerMapByCurrentLocation(sender: AnyObject) {
        if let location = self.locationManager.location {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailsMap") {
            let nextView = segue.destination as! MeetupDetailTable
            let annotation = sender as! CustomAnnotation
            nextView.meetup = annotation.meetup
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let id = "annotationId"
        var annotationView: MKPinAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKPinAnnotationView {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        } else {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: id)
            annotationView?.pinTintColor = UIColor.blue
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView?.canShowCallout = true
            annotationView?.animatesDrop = true
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "detailsMap", sender: view.annotation as? CustomAnnotation)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        manager.stopUpdatingLocation()

        let lat = location.coordinate.latitude.description
        let lon = location.coordinate.longitude.description
        let url = Meetup.meetupURLBuilder(lat: lat, lon: lon, topic: "technology")
        
        MeetupClient.requestGETURL(url, success: {
            (JSONResponse) -> Void in
            self.meetups = Meetup.meetupsFromJSON(json: JSONResponse)!
            for meetup in self.meetups {
                self.drawMapPin(meetup: meetup)
            }
            
            NotificationCenter.default.post(name: .meetups, object: self.meetups)
            
        }) { (error) -> Void in
            print(error)
        }
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        self.mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error.localizedDescription)")
    }
}
