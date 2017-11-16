//
//  NBAData.swift
//  Meetup
//
//  Created by Kevin Nguyen on 11/16/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

struct Player {
    var name: String
    var number: String
}

struct Team {
    var name: String
    var players: [Player]
    var collapsed: Bool
    
    init(name: String, players: [Player], collapsed: Bool = false) {
        self.name = name
        self.players = players
        self.collapsed = collapsed
    }
}

var teamsData: [Team] = [
    Team(name: "Warriors", players: [
        Player(name: "Stephen Curren", number: "30"),
        Player(name: "Kevin Durant", number: "35"),
        Player(name: "Klay Thompson", number: "11"),
        ]),
    Team(name: "Lakers", players: [
        Player(name: "Lonzo Ball", number: "2")
        ])
]
