//
//  Livescore.swift
//  SportReader
//
//  Created by  Arian Niaki on 5/24/1395 AP.
//  Copyright © 1395 AP  Arian Niaki. All rights reserved.
//

import UIKit


class Livescore {
    var team2: String
    var team1: String
    var livescore: String
    var matchstatus: String
    var gameDate: String
    var gameTime: String
    var stage: String
    
    
    // MARK: Initialization
    
    init(team1: String,team2: String, livescore:String, matchstatus:String, gameDate:String,  gameTime:String, stage:String) {
        self.team1 = team1
        self.team2 = team2
        self.livescore = livescore
        self.matchstatus = matchstatus
        self.gameDate = gameDate
        self.gameTime = gameTime
        self.stage = stage
        
        
    }
}
