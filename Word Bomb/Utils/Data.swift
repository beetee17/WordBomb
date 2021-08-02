//
//  Data.swift
//  Word Bomb
//
//  Created by Brandon Thio on 5/7/21.
//

import Foundation

// Loading of Data

func loadWordSets(_ filename: String) -> (words:[String], wordSets:[String: [String]])  {
    
    var wordSets: [String: [String]] = [:]
    var words: [String] = []
    
    do {
        print("loading \(String(describing: filename))")
        let path = Bundle.main.path(forResource: filename, ofType: "txt", inDirectory: "Data")
        print(path ?? "no path found")
        
        let rawData = try String(contentsOfFile: path!, encoding: String.Encoding.utf8).components(separatedBy: "\n")
        
        for wordSet in rawData {
            // if more than one variation of the answer => wordSet will be comma separated String
            let variations:[String] = wordSet.components(separatedBy: ", ")
            
            if variations.count > 1 {
                for i in variations.indices {
                    if variations[i].trim().count != 0 {
                        words.append(variations[i])
                        wordSets[variations[i]] = []
                        for j in variations.indices {
                            if i != j {
                                // iterate through all of the other variations
                                wordSets[variations[i]]?.append(variations[j])
                            }
                        }
                    }
                }
            } else {
                if variations[0].trim().count != 0 {
                    words.append(variations[0])
                }
            }
        }
        words.sort()
    }
    
    catch let error {
        Swift.print("Fatal Error: \(error.localizedDescription)")
    }
    
    return (words, wordSets)
}


func loadSyllables(_ filename: String) -> [(String, Int)] {
    var syllables = [(String, Int)]()
    
    
    do {
        let path = Bundle.main.path(forResource: filename, ofType: "txt", inDirectory: "Data")
        let string = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        let items = string.components(separatedBy: "\n")
        
        for item in items {
            let components = item.components(separatedBy: " ")
            if components.count == 2 && components[0].trim().count != 0 {
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
        print("ENCODED JSON \(String(describing: String(data: data, encoding: .utf8)))")
        return data
        
    } catch {
        print("could not encode GK data")
        print(error.localizedDescription)
        return nil
    }
}


