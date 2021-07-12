//
//  BinarySearch.swift
//  Word Bomb
//
//  Created by Brandon Thio on 5/7/21.
//

import Foundation
import MultipeerKit

// Binary Search Extension for Array
extension Array where Element: Comparable {
    
    func search(element: Element) -> Int {
        
        var low = 0
        var high = count - 1
        var mid = Int(high / 2)
        
        while low <= high {
            
            let midElement = self[mid]
            
            if element == midElement {
                return mid
            }
            else if element < midElement {
                high = mid - 1
            }
            else {
                low = mid + 1
            }
            
            mid = (low + high) / 2
        }
        
        return -1
    }
}


extension Array where Element == Peer {
    func find(_ peer: Peer) -> Int? {
        for i in self.indices {
            if self[i].id == peer.id { return i }
        }
        return nil
    }
}

extension Array where Element == Player {
    func find(_ player: Player) -> Int? {
        for i in self.indices {
            if self[i].id == player.id { return i }
        }
        return nil
    }
    
    func numPlaying() -> Int {
        var num = 0
        for player in self {
            if player.livesLeft != 0 { num += 1 }
        }
        
        return num
    }

    func next(_ currentPlayer: Player) -> Player {
        print("Num players: \(self.count)")
        
        var nextPlayerID = (currentPlayer.id + 1) % self.count
        while self[nextPlayerID].livesLeft == 0 {
            // get next player that has not run out of time
            nextPlayerID = (nextPlayerID + 1) % self.count
        }
        return self[nextPlayerID]
    }
    
    func prev(_ currentPlayer: Player) -> Player {
        let prevIndex = currentPlayer.id - 1
        switch prevIndex < 0 {
        case true:
            return self[self.count-1]
        case false:
            return self[prevIndex]
        }
    }
    
    func reset() {
        for player in self {
            player.reset()
        }
    }
}
