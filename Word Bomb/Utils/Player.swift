//
//  Player.swift
//  Word Bomb
//
//  Created by Brandon Thio on 28/6/21.
//  Copyright © 2021 Brandon Thio. All rights reserved.
//

import Foundation


class Player: Codable, Equatable {
    
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id
    }

    var score:Int = 0
    var name:String
    var id:Int
    var livesLeft = UserDefaults.standard.integer(forKey: "Player Lives")
    
    
    init(name:String, id:Int) {
        if name == "Player" {
            self.name = "\(name) \(id+1)"
        }
        else {
            self.name = name
        }
        self.id = id
        
    }
    
    func didRunOutOfTime() {
        livesLeft -= 1
    }
    
    func reset() {
        score = 0
        livesLeft = UserDefaults.standard.integer(forKey: "Player Lives")
    }
    
}
