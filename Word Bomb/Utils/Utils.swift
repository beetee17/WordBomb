//
//  GameMode.swift
//  Word Bomb
//
//  Created by Brandon Thio on 5/7/21.
//

import Foundation
import MultipeerConnectivity


struct Defaults {
    static let CountryGame = GameMode(modeName:"COUNTRY", dataFile: "countries", queryFile: nil, instruction: "NAME A COUNTRY", words: nil, queries: nil, gameType: GameType.Exact, id: 1)
    
    static let CountryGameReverse = GameMode(modeName:"COUNTRY", dataFile: "countries", queryFile: nil, instruction: "COUNTRIES STARTING WITH...", words: nil, queries: nil, gameType: GameType.Reverse, id: 2)
    
    static let WordGame = GameMode(modeName: "WORDS", dataFile: "words", queryFile: "syllables", instruction: "WORDS CONTAINING...", words: nil, queries: nil, gameType: GameType.Contains, id: 3)
    
    static let WordGameReverse = GameMode(modeName: "WORDS", dataFile: "words", queryFile: "syllables", instruction: "WORDS STARTING WITH...", words: nil, queries: nil, gameType: GameType.Reverse, id: 4)
    
    static let gameModes = [CountryGame, CountryGameReverse, WordGame, WordGameReverse]
    
    static let gameTypes = [("EXACT", GameType.Exact), ("CONTAINS", GameType.Contains), ("REVERSE", GameType.Reverse)]
}


struct GameMode: Identifiable, Codable {
    var modeName: String
    var dataFile: String?
    var queryFile: String?
    var instruction: String?
    
    // for custom modes
    var words: [String]?
    var queries: [String]?
    
    var gameType: GameType
    var id: Int
    
}

enum GameType: Int, Codable {
    case Exact
    case Contains
    case Reverse
}

enum GameState: Int, Codable {
    case initial, playerInput, playerTimedOut, gameOver
}


enum ViewToShow: Int, Codable {
    case main, gameTypeSelect, modeSelect, game, pauseMenu, multipeer, peersView
}


// MARK: - Loading of Data

func getWordSets(_ rawData:[String]) -> (words:[String], wordSets:[String: [String]])  {
    
    var wordSets: [String: [String]] = [:]
    var words: [String] = []
    
    for wordSet in rawData {
        // if more than one variation of the answer => wordSet will be comma separated String
        let variations:[String] = wordSet.components(separatedBy: ", ")
        if variations.count > 1 {
            for i in variations.indices {
                words.append(variations[i])
                wordSets[variations[i]] = []
                for j in variations.indices {
                    if i != j {
                        // iterate through all of the other variations
                        wordSets[variations[i]]?.append(variations[j])
                    }
                }
            }
        } else { words.append(variations[0]) }
    }
    return (words, wordSets)
}

func loadData(_ mode: GameMode) -> (data: [String: [String]], wordSets: [String: [String]])    {
    
    var data: [String: [String]] = [:]
    var wordSets: [String: [String]] = [:]
    
    do {
        print("loading \(mode.dataFile)")
        let path = Bundle.main.path(forResource: mode.dataFile, ofType: "txt", inDirectory: "Data")
        print(path ?? "no path found")
        let string = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        let Data = getWordSets(string.components(separatedBy: "\n"))
        
        data["data"] = Data.words.sorted()
        wordSets = Data.wordSets
    }
    
    catch let error {
        Swift.print("Fatal Error: \(error.localizedDescription)")
    }
    
    if let queryFile = mode.queryFile {
        
        do {
            let path = Bundle.main.path(forResource: queryFile, ofType: "txt", inDirectory: "Data")
            let string = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)

            data["queries"] = string.components(separatedBy: "\n")
            data["queries"]?.removeLast()
        }
        
        catch let error {
            Swift.print("Fatal Error: \(error.localizedDescription)")
        }
    }
    
    return (data, wordSets)
}

// for custom modes using core data
func encodeStrings(_ data: [String]) -> String {
    if let JSON = try? JSONEncoder().encode(data) {
        return String(data: JSON, encoding: .utf8)!
    } else { return "" }
}

func decodeJSONStringtoArray(_ json: String) -> [String] {
    if let data = try? JSONDecoder().decode([String].self, from: Data(json.utf8)) {
        return data.sorted()
    } else { return [] }
}
