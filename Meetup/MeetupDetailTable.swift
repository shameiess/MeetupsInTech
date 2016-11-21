//
//  MeetupDetailTable.swift
//  Meetup
//
//  Created by Kevin Nguyen on 11/17/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

import UIKit
import MapKit

class MeetupDetailTable: UITableViewController {
    
    var meetup: Meetup?
    
    @IBOutlet weak var meetupTitle: UILabel!
    @IBOutlet weak var meetupDescription: UILabel!
    
    @IBAction func urlButton(_ sender: Any) {
        UIApplication.shared.openURL((meetup?.meetupUrl)!)
    }
    
    @IBAction func commentsButton(_ sender: Any) {
        performSegue(withIdentifier: "commentsTable", sender: self)
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = meetup?.meetupName
        self.meetupTitle.text = meetup?.meetupName
        self.meetupDescription.text = meetup?.meetupDescription?.html2String
        self.mapView.delegate = self
        drawMapPin(meetup: meetup!)
        if (meetup?.latitude != nil && meetup?.longitude != nil) {
            let center = CLLocationCoordinate2D(latitude: (meetup?.latitude)!, longitude: (meetup?.longitude)!)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 200
        }
        if (indexPath.row == 1) {
            return 100
        }
        if (indexPath.row == 2) {
            return UITableViewAutomaticDimension
        }
        if (indexPath.row == 3) {
            return UITableViewAutomaticDimension
        } else {
            return 200
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 200
        }
        if (indexPath.row == 1) {
            return 100
        }
        if (indexPath.row == 2) {
            return UITableViewAutomaticDimension
        }
        if (indexPath.row == 3) {
            return UITableViewAutomaticDimension
        } else {
            return 200
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "commentsTable") {
            let nextView = segue.destination as! CommentsView
            nextView.event_id = meetup?.meetupId
        }
    }
    
    func drawMapPin(meetup: Meetup) {
        if ((meetup.longitude != nil) && (meetup.longitude != nil)) {
            let coordinate = CLLocationCoordinate2DMake(meetup.latitude!, meetup.longitude!)
            let annotation = CustomAnnotation(title: meetup.meetupName!, subtitle: meetup.address!, coordinate: coordinate, meetup: meetup)
            self.mapView.addAnnotation(annotation)
        }
    }
    
}

extension MeetupDetailTable: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var view: MKPinAnnotationView?
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationId") as? MKPinAnnotationView {
            view = dequeuedView
            view?.annotation = annotation
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotationId")
            view?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            view?.canShowCallout = true
            view?.animatesDrop = true
        }
        return view
    }
}
