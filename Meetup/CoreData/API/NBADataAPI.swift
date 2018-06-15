//
//  NBADataAPI.swift
//  Meetup
//
//  Created by Kevin Nguyen on 6/14/18.
//  Copyright © 2018 Kevin Nguyen. All rights reserved.
//

import UIKit
import Alamofire

class NetworkRequester {
    private let decoder = JSONDecoder()
    
    func requestForCodable<T: Decodable>(_ request: URLRequestConvertible, success: @escaping (T?) -> Void, failure: @escaping (Error) -> Void) {
        Alamofire.request(request).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                let result = try? self.decoder.decode(T.self, from: data)
                success(result)
            case .failure(let error):
                failure(error)
            }
        }
    }
}

enum Router: URLRequestConvertible {
    case players(parameters: Parameters)
    case player(personId: String)
    case teams(parameters: Parameters)
    case teamsConfig(parameters: Parameters)
    
    static let baseURLString = "https://data.nba.net/10s/prod"
    
    var method: HTTPMethod {
        switch self {
        case .players:
            return .get
        case .player:
            return .get
        case .teams:
            return .get
        case .teamsConfig:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .players:
            return "/v1/2017/players.json"
        case .player(let personId):
            return "/v1/2017/players/\(personId)_profile.json"
        case .teams:
            return "/v1/2017/teams.json"
        case .teamsConfig:
            return "/2017/teams_config.json"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        var encoder: ParameterEncoding
        switch method {
        case .get, .delete:
            encoder = URLEncoding.default
        default:
            encoder = JSONEncoding.default
        }
        urlRequest = try encoder.encode(urlRequest, with: nil)
        return urlRequest
    }
    
    
}

class NBADataAPI: NSObject {
    func fetchPlayers(success: @escaping (NBAPlayersFeed?) -> Void, failure: @escaping (Error) -> Void) {
        NetworkRequester().requestForCodable(Router.players(parameters: [:]), success: { (feed: NBAPlayersFeed?) in
            success(feed)
        }, failure: { (error) in
            failure(error)
        })
    }
    
//    func fetchPlayer(personId: String, success: @escaping (Any?) -> Void, failure: @escaping (Error) -> Void) {
//        NetworkRequester().requestForCodable(Router.player(personId: personId), success: { (feed: Any?) in
//            success(feed)
//        }, failure: { (error) in
//            failure(error)
//        })
//    }
    
    func fetchTeams(success: @escaping (NBATeamsFeed?) -> Void, failure: @escaping (Error) -> Void) {
        NetworkRequester().requestForCodable(Router.teams(parameters: [:]), success: { (feed: NBATeamsFeed?) in
            success(feed)
        }, failure: { (error) in
            failure(error)
        })
    }
    
    func fetchTeamsConfig(success: @escaping (NBATeamsConfigFeed?) -> Void, failure: @escaping (Error) -> Void) {
        NetworkRequester().requestForCodable(Router.teamsConfig(parameters: [:]), success: { (feed: NBATeamsConfigFeed?) in
            success(feed)
        }, failure: { (error) in
            failure(error)
        })
    }
}
