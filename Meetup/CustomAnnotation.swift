//
//  CustomAnnotation.swift
//  Meetup
//
//  Created by Kevin Nguyen on 11/15/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var meetup: Meetup?
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, meetup: Meetup?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.meetup = meetup
    }

}
