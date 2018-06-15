//
//  NBAData.swift
//  Meetup
//
//  Created by Kevin Nguyen on 11/16/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

struct NBAFranchise {
    var name: NBATeam
    var players: [NBAPlayer]
    var collapsed: Bool
    
    init(name: NBATeam, players: [NBAPlayer], collapsed: Bool = true) {
        self.name = name
        self.players = players
        self.collapsed = collapsed
    }
}
