//
//  NBA.swift
//  Meetup
//
//  Created by Kevin Nguyen on 1/8/18.
//  Copyright © 2018 Kevin Nguyen. All rights reserved.
//
import Foundation

// MARK: - NBA Players
public struct PlayersFeed: Codable {
    public let league: PlayersCollection
    
    public struct PlayersCollection: Codable {
        public let players: [NBAPlayer]
        
        enum CodingKeys: String, CodingKey {
            case players = "standard"
        }
    }
}

public struct NBAPlayer: Codable {
    public let firstName, lastName, jersey, teamId, pos, heightFeet, heightInches, weightPounds : String
    
    var name : String {
        return [ firstName, lastName ].flatMap({$0}).joined(separator:" ")
    }
}

// MARK: - NBA Teams
public struct TeamsFeed: Codable {
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

// MARK: - NBA Teams Config
public struct TeamsConfigFeed: Codable {
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

