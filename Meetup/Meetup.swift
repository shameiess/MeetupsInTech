//
//  Meetup.swift
//  Meetup
//
//  Created by Kevin Nguyen on 11/11/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON
import MapKit

class Meetup: NSObject {
    
    let meetupId: String?
    let meetupName: String?
    let meetupDescription: String?
    let meetupUrl: URL?
    
    let distance: Double?
    let timestamp: Double?
    
    let address: String?
    let latitude: Double?
    let longitude: Double?
    
    init(meetupId: String?, meetupName: String?, meetupDescription: String?, meetupUrl: URL?, distance: Double?, timestamp: Double?, address: String?, latitude: Double?, longitude: Double?) {
        self.meetupId = meetupId
        self.meetupName = meetupName
        self.meetupDescription = meetupDescription
        self.meetupUrl = meetupUrl
        
        self.distance = distance
        self.timestamp = timestamp
        
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
    class func meetupURLBuilder(lat: String, lon: String, topic: String) -> String {
        let url = "https://api.meetup.com/2/open_events?&sign=true&photo-host=public&lat=" + lat + "&topic=" + topic + "&lon=" + lon + "&key=266354163543e605a2ee2a23306e4e"
        return url
    }
    
    class func meetupsFromJSON(json: JSON) -> [Meetup]? {
        var meetups = [Meetup]()
        
        if let results = json["results"].array {
            
            for i in 0..<results.count {
                print(results[i])
                let meetupid = results[i]["id"].string
                let meetupName = results[i]["name"].string
                let meetupDescription = results[i]["description"].string
                let meetupUrl = URL(string: results[i]["event_url"].string!)
                let distance = results[i]["distance"].double
                let timestamp = results[i]["time"].double
                let address = results[i]["venue"]["address_1"].string
                let latitude = results[i]["venue"]["lat"].double
                let longitude = results[i]["venue"]["lon"].double
        
                let meetup = Meetup(meetupId: meetupid, meetupName: meetupName, meetupDescription: meetupDescription, meetupUrl: meetupUrl, distance: distance, timestamp: timestamp, address: address, latitude: latitude, longitude: longitude)
                
                meetups.append(meetup)
            }
        }
        return meetups
    }
    
    struct MeetupComment {
        //let member_id: String?
        //let event_comment_id: String?
        let event_id: String?
        let comment: String?
        let time: Double?
        let member_name: String?
    }
    
    class func commentsfromMeetup(json: JSON) -> [MeetupComment]? {
        var comments = [MeetupComment]()
        if let results = json["results"].array {
            for i in 0..<results.count {
                let event_id = results[i]["event_id"].string
                let comment = results[i]["comment"].string
                let time = results[i]["time"].double
                let member_name = results[i]["member_name"].string

                let meetupComment = MeetupComment(event_id: event_id, comment: comment, time: time, member_name: member_name)
                comments.append(meetupComment)
            }
        }
        return comments
    }
}
