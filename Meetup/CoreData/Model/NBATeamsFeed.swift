//
//  NBATeamsFeed.swift
//  Meetup
//
//  Created by Kevin Nguyen on 6/14/18.
//  Copyright © 2018 Kevin Nguyen. All rights reserved.
//

public struct NBATeamsFeed: Codable {
    public let league: TeamsCollection
    
    public struct TeamsCollection: Codable {
        public let teams: [NBATeam]
        
        enum CodingKeys: String, CodingKey {
            case teams = "standard"
        }
    }
}

public struct NBATeam: Codable {
    public let isNBAFranchise : Bool
    public let fullName,teamId : String
}
