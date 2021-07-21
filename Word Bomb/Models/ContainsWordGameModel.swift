//
//  ContainsWordGameModel.swift
//  Word Bomb
//
//  Created by Brandon Thio on 5/7/21.
//

import Foundation

struct ContainsWordGameModel: WordGameModel {
    var data: [String]
    var queries: [(String, Int)]
    var queriesCopy: [(String, Int)]
    
    var usedWords = Set<Int>()
    
    var pivot: Int
    var numTurns = 0
    var numTurnsBeforeDifficultyIncrease = 2
    //    var difficultyMultiplier = UserDefaults.standard.double(forKey: "Difficulty Multiplier")
    var syllableDifficulty = UserDefaults.standard.double(forKey: "Syllable Difficulty")
    
    init(data: [String], queries: [(String, Int)]) {
        self.data = data
        self.queries = queries
        self.queriesCopy = queries
        self.pivot = queries.bisect(at: Int(syllableDifficulty*100.0))
    }
    
    mutating func process(_ input: String, _ query: String? = nil) -> (status: String, query: String?) {
        let searchResult = data.search(element: input)
        //        return ("correct", getRandQuery(input))
        if usedWords.contains(searchResult) {
            print("\(input.uppercased()) ALREADY USED")
            return ("used", nil)
            
        }
        
        else if (searchResult != -1) && input.contains(query!) {
            print("\(input.uppercased()) IS CORRECT")
            usedWords.insert(searchResult)
            return ("correct", getRandQuery(input))
        }
        
        else {
            print("\(input.uppercased()) IS WRONG")
            return ("wrong", nil)
            
        }
        
    }
    
    mutating func reset() {
        usedWords = Set<Int>()
        queries = queriesCopy
        numTurns = 0
    }
    
    mutating func getRandQuery(_ input: String? = nil) -> String {
        
        var query = weightedRandomElement(items: queries).trim()
        
        while query.count == 0 {
            // prevent blank query
            query = weightedRandomElement(items: queries).trim()
            print("getting random query \(query)")
        }
        print("GOT RANDOM QUERY \(query)")
        
        
        // pivot at some percentage of max element, defined by syllableDifficulty
        if numTurns % numTurnsBeforeDifficultyIncrease == 0 {
            updateSyllableWeights(pivot: pivot)
        }
        
        numTurns += 1
        return query
        
    }
    
    mutating func updateSyllableWeights(pivot: Int) {
        
        for i in queries.indices {
            switch i == pivot {
            case true: break
            case false:
                let weight = queries[i].1
                let originalOffset = Double(abs(queriesCopy[i].1 - queriesCopy[pivot].1))
                let currentOffset = Double(abs(queries[i].1 - queries[pivot].1))
                
                if i < pivot {
                    
                    queries[i] = (queries[i].0, min(queriesCopy.last!.1, weight + Int(currentOffset*0.05) + Int(originalOffset*0.1)))
                    
                }
                
                else {
                    queries[i] = (queries[i].0, max(0, weight - Int(currentOffset*0.05) - Int(originalOffset*0.1)))
                }
            }
            
            
            //            if i < 600 && i > 590{
            //                print(queries[i])
            //
            //            }
            
        }
        //        print("pivot \(queries[pivot])")
        
    }
    
}

