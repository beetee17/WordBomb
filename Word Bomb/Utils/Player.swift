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
    var ID:Int
    
    
    init(name:String, ID:Int) {
        if name == "Player" {
            self.name = "\(name) \(ID+1)"
        }
        else {
            self.name = name
        }
        self.ID = ID
        
    }
    
}
