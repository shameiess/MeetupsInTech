//
//  MeetupClient.swift
//  Meetup
//
//  Created by Kevin Nguyen on 11/11/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MeetupClient: NSObject {

    static let sharedInstance = MeetupClient(apiKey: "266354163543e605a2ee2a23306e4e")
    let apiKey: String
    
    private init(apiKey: String) {
        self.apiKey = apiKey
    }

    func get(_ url: String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //print("JSON: \(json)")
                success(json)
            case .failure(let error):
                failure(error)
                print(error)
            }
        }
    }
    
    func getMeetupsBy(topic: String, lat: String, lon: String) -> String {
        let url = "https://api.meetup.com/2/open_events?&sign=true&photo-host=public&lat=\(lat)&topic=\(topic)&lon=\(lon)&key=\(self.apiKey)"
        return url
    }
    
    func getAPIKey() -> String {
        let path = Bundle.main.path(forResource: "Info", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        return dict!.object(forKey: "YelpAPIKey") as! String
    }
    
}
