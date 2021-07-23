//
//  Data.swift
//  Word Bomb
//
//  Created by Brandon Thio on 5/7/21.
//

import Foundation

// Loading of Data

func loadWordSets(_ mode: GameMode) -> (words:[String], wordSets:[String: [String]])  {
    
    var wordSets: [String: [String]] = [:]
    var words: [String] = []
    
    do {
        print("loading \(String(describing: mode.dataFile))")
        let path = Bundle.main.path(forResource: mode.dataFile, ofType: "txt", inDirectory: "Data")
        print(path ?? "no path found")
        
        let rawData = try String(contentsOfFile: path!, encoding: String.Encoding.utf8).components(separatedBy: "\n")
        
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
    }
    
    catch let error {
        Swift.print("Fatal Error: \(error.localizedDescription)")
    }
    
    return (words, wordSets)
}


func loadSyllables(_ mode: GameMode) -> [(String, Int)] {
    var syllables = [(String, Int)]()
    
    if let queryFile = mode.queryFile {
        
        do {
            let path = Bundle.main.path(forResource: queryFile, ofType: "txt", inDirectory: "Data")
            let string = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            
            let items = string.components(separatedBy: "\n")
            
            for item in items {
                let components = item.components(separatedBy: " ")
                if components.count == 2 {
                    let syllable = components[0]

                    let frequency = Int(components[1])!
                    syllables.append((syllable, frequency))
                }
                else {
                    print(components)
                }
            }
            
        }
        
        catch let error {
            Swift.print("Fatal Error: \(error.localizedDescription)")
        }
    }
    
    return syllables
    
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

func encodeDict(_ dictionary: [String: String]) -> Data? {
    do {
        let data = try JSONEncoder().encode(dictionary)
        print("ENCODED JSON \(String(data: data, encoding: .utf8))")
        return data
        
    } catch {
        print("could not encode GK data")
        print(error.localizedDescription)
        return nil
    }
}


