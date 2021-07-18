//
//  Extensions.swift
//  Word Bomb
//
//  Created by Brandon Thio on 5/7/21.
//

import Foundation
import MultipeerKit


extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

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

extension Array {
    mutating func enqueue(_ element: Element) {
        self.append(element)
    }
    
    mutating func dequeue() -> Element? {
        self.count == 0 ? nil : self.removeFirst()
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
            if player.livesLeft > 0 { num += 1 }
        }
        
        return num
    }

    mutating func nextPlayer(_ currentPlayer: Player) -> Player {
        // if two players left do not rotate order for UI -> only remove the player if no lives left
        if self.count == 2 && self.first!.livesLeft > 0 {
            if currentPlayer == self.first! { return self.last! }
            else { return self.first!}
        }
        
        // cycle current player to back of queue if still playing
        if let currentPlayer = self.dequeue(), currentPlayer.livesLeft > 0 {
            self.enqueue(currentPlayer)
        }
        return self.first! // there will always be at least 1 player in the array
    }
//
//    func prev(_ currentPlayer: Player) -> Player {
//        var prevIndex = currentPlayer.id
//        repeat {
//
//            prevIndex -= 1
//
//            switch prevIndex < 0 {
//            case true:
//                prevIndex = self.count-1
//            case false:
//                break
//            }
//
//        }  while self[prevIndex].livesLeft == 0
//
//        return self[prevIndex]
//    }
    
    mutating func reset() {
        for player in self {
            player.reset()
        }
    }
}

extension Collection where Index == Int {

    subscript(back i: Int) -> Iterator.Element {
        let backBy = i + 1
        return self[self.index(self.endIndex, offsetBy: -backBy)]
    }
}
