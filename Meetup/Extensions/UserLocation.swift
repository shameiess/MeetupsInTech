//
//  UserLocation.swift
//  Meetup
//
//  Created by Kevin Nguyen on 10/3/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation)
    func tracingLocationDidFailWithError(error: NSError)
}

final class UserLocation: NSObject, CLLocationManagerDelegate {

    static let sharedInstance = UserLocation()
    
    private var locationManager = CLLocationManager()
    var delegate: LocationServiceDelegate?
//    private var requested: Bool = false

    var currentLocation: CLLocation? {
        didSet {
            
        }
    }
    var latitude: Double?
    var longitude: Double?
    
    private override init() {
        super.init()
        self.requestLocation()
//        if CLLocationManager.authorizationStatus() == .notDetermined {
//            self.requestLocation()
//        }
    }
    
    private func requestLocation() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
//        self.requested = true
    }
    
    func startUpdatingLocation() {
        print("Starting User Location Updates")
        self.locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        print("Stop User Location Updates")
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        self.currentLocation = location
        self.delegate?.tracingLocation(currentLocation: self.currentLocation!)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("UserLocation locationManager failed with error: \(error.localizedDescription)")
    }

}
