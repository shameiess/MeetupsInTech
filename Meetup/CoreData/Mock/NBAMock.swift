//
//  NBAMock.swift
//  Meetup
//
//  Created by Kevin Nguyen on 6/14/18.
//  Copyright © 2018 Kevin Nguyen. All rights reserved.
//

import UIKit

class NBAMock: NSObject {
    
    func getNBAData(completion: ([NBAPlayer], [NBATeam], [NBATeamConfig]) -> () ) {
        
        var nbaplayers = [NBAPlayer]()
        var nbateams = [NBATeam]()
        var nbateamsconfig = [NBATeamConfig]()
        
        let playersPath = Bundle.main.path(forResource: "players", ofType: "json")
        let playersURL = URL(fileURLWithPath: playersPath!)
        do {
            let data = try Data(contentsOf: playersURL)
            let response = try JSONDecoder().decode(NBAPlayersFeed.self, from: data)
            nbaplayers = response.league.players
        } catch {
            print(error)
        }
        
        let teamsPath = Bundle.main.path(forResource: "teams", ofType: "json")
        let teamsURL = URL(fileURLWithPath: teamsPath!)
        do {
            let data = try Data(contentsOf: teamsURL)
            let response = try JSONDecoder().decode(NBATeamsFeed.self, from: data)
            nbateams = response.league.teams.filter{ $0.isNBAFranchise == true}
        } catch {
            print(error)
        }
        
        let teamsConfigPath = Bundle.main.path(forResource: "teams_config", ofType: "json")
        let teamsConfigURL = URL(fileURLWithPath: teamsConfigPath!)
        do {
            let data = try Data(contentsOf: teamsConfigURL)
            let response = try JSONDecoder().decode(NBATeamsConfigFeed.self, from: data)
            nbateamsconfig = response.teams.teamConfigs
        } catch {
            print(error)
        }
        
        completion(nbaplayers, nbateams, nbateamsconfig)
    }
    
    func getKevinDurantProfile(completion: @escaping ((NBAPlayerProfile) -> ())) {
        let teamsConfigPath = Bundle.main.path(forResource: "201142_profile", ofType: "json")
        let teamsConfigURL = URL(fileURLWithPath: teamsConfigPath!)
        do {
            let data = try Data(contentsOf: teamsConfigURL)
            let response = try JSONDecoder().decode(NBAPlayerProfile.self, from: data)
            print(response)
            completion(response)
        } catch {
            print(error)
        }
    }
}
