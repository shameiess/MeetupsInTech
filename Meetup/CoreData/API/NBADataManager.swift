//
//  NBADataManager.swift
//  Meetup
//
//  Created by Kevin Nguyen on 6/14/18.
//  Copyright © 2018 Kevin Nguyen. All rights reserved.
//

import UIKit

class NBADataManager: NSObject {

    func getNBAData(completion: @escaping ([NBAPlayer], [NBATeam], [NBATeamConfig]) -> () ) {
        
        var nbaplayers = [NBAPlayer]()
        var nbateams = [NBATeam]()
        var nbateamsconfig = [NBATeamConfig]()
        
        let dispatchGroup = DispatchGroup()
        
        // Fetch Teams
        dispatchGroup.enter()
        NBADataAPI().fetchTeams(success: { (teamsFeed) in
            if let teamsFeed = teamsFeed {
                nbateams = teamsFeed.league.teams.filter{ $0.isNBAFranchise == true}
            }
            dispatchGroup.leave()
        }, failure: { error in
            print(error)
            dispatchGroup.leave()
        })
        
        // Fetch Players
        dispatchGroup.enter()
        NBADataAPI().fetchPlayers(success: { (playersFeed) in
            if let playersFeed = playersFeed {
                nbaplayers = playersFeed.league.players
            }
            dispatchGroup.leave()
        }, failure: { error in
            print(error)
            dispatchGroup.leave()
        })
        
        // Fetch TeamsConfig
        dispatchGroup.enter()
        // Due to coding issues with the newer https://data.nba.net/10s/prod/2017/teams_config.json, we'll put it from Mock
//        NBADataAPI().fetchTeamsConfig(success: { (teamsConfigFeed) in
//            if let teamsConfigFeed = teamsConfigFeed {
//                nbateamsconfig = teamsConfigFeed.teams.teamConfigs
//            }
//            dispatchGroup.leave()
//        }, failure: { error in
//            print(error)
//            dispatchGroup.leave()
//        })
        let teamsConfigPath = Bundle.main.path(forResource: "teams_config", ofType: "json")
        let teamsConfigURL = URL(fileURLWithPath: teamsConfigPath!)
        do {
            let data = try Data(contentsOf: teamsConfigURL)
            let response = try JSONDecoder().decode(NBATeamsConfigFeed.self, from: data)
            nbateamsconfig = response.teams.teamConfigs
        } catch {
            print(error)
        }
        dispatchGroup.leave()
        
        dispatchGroup.notify(queue: .main) {
			completion(nbaplayers, nbateams, nbateamsconfig)
        }
    }
}
