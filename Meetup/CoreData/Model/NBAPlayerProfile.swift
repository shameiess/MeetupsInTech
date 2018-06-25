//
//  NBAPlayerProfile.swift
//  Meetup
//
//  Created by Kevin Nguyen on 6/14/18.
//  Copyright © 2018 Kevin Nguyen. All rights reserved.
//

public struct NBAPlayerProfile: Codable {
    public let league: LeagueStandard

    public struct LeagueStandard: Codable {
        public let standard: PlayerProfile

        enum CodingKeys: String, CodingKey {
            case standard = "standard"
        }
    }
}

public struct PlayerProfile: Codable {
    public let teamId: String?
    public let stats: Stats?
}

public struct Stats: Codable {
    let latest, careerSummary: CareerSummary
    let regularSeason: RegularSeason
}

public struct CareerSummary: Codable {
    let tpp, ftp, fgp, ppg: String
    let rpg, apg, bpg, mpg: String
    let spg, assists, blocks, steals: String
    let turnovers, offReb, defReb, totReb: String
    let fgm, fga, tpm, tpa: String
    let ftm, fta, pFouls, points: String
    let gamesPlayed, gamesStarted, plusMinus, min: String
    let dd2, td3: String
    let seasonYear, seasonStageID: Int?
    let topg, teamID: String?

    enum CodingKeys: String, CodingKey {
        case tpp, ftp, fgp, ppg, rpg, apg, bpg, mpg, spg, assists, blocks, steals, turnovers, offReb, defReb, totReb, fgm, fga, tpm, tpa, ftm, fta, pFouls, points, gamesPlayed, gamesStarted, plusMinus, min, dd2, td3, seasonYear
        case seasonStageID = "seasonStageId"
        case topg
        case teamID = "teamId"
    }
}

public struct RegularSeason: Codable {
    let season: [Season]
}

public struct Season: Codable {
    let seasonYear: Int
    let teams: [CareerSummary]
    let total: CareerSummary
}
