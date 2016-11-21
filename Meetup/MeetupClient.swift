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
    
    class func requestGETURL(_ strURL: String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        Alamofire.request(strURL).validate().responseJSON { response in
            
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

}
