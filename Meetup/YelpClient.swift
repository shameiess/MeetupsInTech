//
//  YelpClient.swift
//  Meetup
//
//  Created by Kevin Nguyen on 7/28/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

import UIKit

class YelpClient: NSObject {
    
    static let sharedInstance = YelpClient()
    
    func getYelpBusinesses(_ term: String, completionHandler: @escaping ([YelpBusiness]?, Error?) -> Void) {
        let endpoint = "https://api.yelp.com/v3/businesses/search?term=\(term)&latitude=37.786882&longitude=-122.399972"
        guard let url = URL(string: endpoint) else {
            let error = BackendError.urlError(reason: "Unable to construct url: \(endpoint)")
            completionHandler(nil, error)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer QAlfqNfTbjrRRQvniJfuTmy9gGv5yqbKWYWkc2cmPbSCQIzDlFHb6x0akZzSzPCQZCMzN26iunnnjVjEfYUW-e3VaybO34ky4DAgdKl0lm3Hf7I6crCbn2pa1Zd7WXYx", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, reponse, error) in
            guard let responseData = data else {
                print("Error: Did not receive data")
                completionHandler(nil, error)
                return
            }
            guard error == nil else {
                completionHandler(nil, error)
                return }
            
            let decoder = JSONDecoder()
            do {
                print(String(data: responseData, encoding: .utf8) ?? "No response data as string")
                let decodedResponse = try decoder.decode(Yelp.self, from: responseData)
                completionHandler(decodedResponse.businesses, nil)
            } catch {
                print("Error: Trying to convert data to JSON \(error)")
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
}

enum BackendError: Error {
    case urlError(reason: String)
    case objectSerialization(reason: String)
}
