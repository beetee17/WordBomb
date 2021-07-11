//
//  Player.swift
//  Word Bomb
//
//  Created by Brandon Thio on 28/6/21.
//  Copyright © 2021 Brandon Thio. All rights reserved.
//

import Foundation


class Player: Codable {
    
    var score:Int = 0
    var name:String
    var id:Int
    var ranOutOfTime:Bool
    
    
    init(name:String, id:Int) {
        if name == "Player" {
            self.name = "\(name) \(id+1)"
        }
        else {
            self.name = name
        }
        self.id = id
        ranOutOfTime = false
    }
    
    func didRunOutOfTime() {
        ranOutOfTime = true
    }
    
    func reset() {
        score = 0
        ranOutOfTime = false
    }
    
}
