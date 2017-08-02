//
//  YelpBusiness.swift
//  Meetup
//
//  Created by Kevin Nguyen on 7/28/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

import Foundation

struct Yelp: Codable {

    var businesses: [YelpBusiness]

    struct YelpBusiness: Codable {
        var name: String?
        var image_url: String?
//        var address1: String?
//        var city: String?
//        var zip_code: String?
    }
    
    //    private enum CodingKeys: String, CodingKey {
    //        case name = "yelp_name"
    //        case points = "yelp_image_url"
    //        case address1
    //        case city
    //        case zip_code
    //    }
}

 struct GroceryProduct: Codable {
 var name: String
 var points: Int
 var description: String
 }

/*
 let decoder = JSONDecoder()
 let products = try decoder.decode([GroceryProduct].self, from: json)
 
 print("The following products are available:")
 for product in products {
 print("\t\(product.name) (\(product.points) points): \(product.description)")
 }

 */

/*
 {
 "businesses": [
 {
 "id": "golden-star-vietnamese-restaurant-san-francisco",
 "name": "Golden Star Vietnamese Restaurant",
 "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/12vRlFsOsUnu0NgGC7lOCw/o.jpg",
 "is_closed": false,
 "url": "https://www.yelp.com/biz/golden-star-vietnamese-restaurant-san-francisco?adjust_creative=ebyycRPlIjzGKEc74bSX-Q&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=ebyycRPlIjzGKEc74bSX-Q",
 "review_count": 1028,
 "categories": [
 {
 "alias": "vietnamese",
 "title": "Vietnamese"
 },
 {
 "alias": "noodles",
 "title": "Noodles"
 }
 ],
 "rating": 3.5,
 "coordinates": {
 "latitude": 37.7945505827665,
 "longitude": -122.405742555857
 },
 "transactions": [],
 "price": "$",
 "location": {
 "address1": "11 Walter U Lum Pl",
 "address2": "",
 "address3": "",
 "city": "San Francisco",
 "zip_code": "94108",
 "country": "US",
 "state": "CA",
 "display_address": [
 "11 Walter U Lum Pl",
 "San Francisco, CA 94108"
 ]
 },
 "phone": "+14153981215",
 "display_phone": "(415) 398-1215",
 "distance": 989.093282904
 }
 ]
 }
 */
