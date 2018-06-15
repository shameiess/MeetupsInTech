//
//  NBAPlayersFeed.swift
//  Meetup
//
//  Created by Kevin Nguyen on 6/14/18.
//  Copyright © 2018 Kevin Nguyen. All rights reserved.
//

public struct NBAPlayersFeed: Codable {
    public let league: PlayersCollection
    
    public struct PlayersCollection: Codable {
        public let players: [NBAPlayer]
        
        enum CodingKeys: String, CodingKey {
            case players = "standard"
        }
    }
}

public struct NBAPlayer: Codable {
    public let firstName, lastName, personId, jersey, teamId, pos, heightFeet, heightInches, weightPounds : String
    
    var name : String {
        return [ firstName, lastName ].flatMap({$0}).joined(separator:" ")
    }
}
