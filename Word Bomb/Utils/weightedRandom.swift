//
//  weightedRandom.swift
//  Word Bomb
//
//  Created by Brandon Thio on 19/7/21.
// Credits https://codereview.stackexchange.com/questions/112605/weighted-probability-problem-in-swift

import Foundation

// maybe adapt to allow floating point weights

func weightedRandomElement<T>(items: [(T, UInt)]) -> T {

    let total = items.map { $0.1 }.reduce(0, +)
    precondition(total > 0, "The sum of the weights must be positive")

    let rand = UInt(arc4random_uniform(UInt32(total)))

    var sum = UInt(0)
    for (element, weight) in items {
        sum += weight
        if rand < sum {
            return element
        }
    }

    fatalError("This should never be reached")
}

//is called like
//let colors : [(String, UInt)] = [("Red", 20), ("Blue", 50), ("Green", 70)]
//let color = weightedRandomElement(colors)
