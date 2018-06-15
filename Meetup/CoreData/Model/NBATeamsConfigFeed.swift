//
//  NBATeamsConfigFeed.swift
//  Meetup
//
//  Created by Kevin Nguyen on 6/14/18.
//  Copyright © 2018 Kevin Nguyen. All rights reserved.
//

public struct NBATeamsConfigFeed: Codable {
    public let teams: TeamConfigCollection
    
    public struct TeamConfigCollection: Codable {
        public let teamConfigs: [NBATeamConfig]
        
        enum CodingKeys: String, CodingKey {
            case teamConfigs = "config"
        }
    }
}

public struct NBATeamConfig: Codable {
    public let teamId, primaryColor, secondaryColor : String
}
