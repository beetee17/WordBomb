//
//  Trie.swift
//  Word Bomb
//
//  Created by Brandon Thio on 28/7/21.
//  Reference: https://www.raywenderlich.com/892-swift-algorithm-club-swift-trie-data-structure

import Foundation

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

class TrieNode<T: Hashable> {
  var value: T?
  weak var parent: TrieNode?
  var children: [T: TrieNode] = [:]
  var isTerminating = false
  
  init(value: T? = nil, parent: TrieNode? = nil) {
    self.value = value
    self.parent = parent
  }
  
  func add(child: T) {
    guard children[child] == nil else { return }
    children[child] = TrieNode(value: child, parent: self)
  }
}

class Trie {
  typealias Node = TrieNode<Character>
  fileprivate let root: Node
  
  init() {
    root = Node()
  }
}

extension Trie {
  func insert(_ word: String) {
    guard !word.isEmpty else { return }
    
    let word = word.trim()
    var currentNode = root
    
    var currentIndex = 0
  
    while currentIndex < word.count {
        let character = Character(word[currentIndex])
      
      if let child = currentNode.children[character] {
        currentNode = child
      } else {
        currentNode.add(child: character)
        currentNode = currentNode.children[character]!
      }
      
      currentIndex += 1
      
      
      if currentIndex == word.count {
        currentNode.isTerminating = true
      }
    }
  }
  
  func search(_ word: String) -> Bool {
    guard !word.isEmpty else { return false }
    
    let word = word.trim()
    var currentNode = root
    
    var currentIndex = 0
    
    while currentIndex < word.count, let child = currentNode.children[Character(word[currentIndex])] {
      currentIndex += 1
      currentNode = child
    }
    
    if currentIndex == word.count && currentNode.isTerminating {
      return true
    } else {
      return false
    }
  }
}
