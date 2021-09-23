//
//  ContentView.swift
//  spell-checker
//
//  Created by Andrey Galitskov on 23.09.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var text: String = ""
    var body: some View {
        VStack(alignment: .leading) {
            TextField(
                "Enter text",
                text: $text,
                onCommit: {
                    fixAll()
                }
            )
        }
    }
    
    func onCommit(text: String) {
        print(text)
    }
    
    let dictionary = ["aaaa", "bbbb"]
    
    let maxDist = 0.5
    
    func getDist(word: String, word2: String) -> Int {
        let short: String = word.count < word2.count ? word.lowercased() : word2.lowercased()
        let long: String = word.count >= word2.count ? word.lowercased() : word2.lowercased()
        
        var dist = Int(1e9)
        
        for shift in 0..<long.count {
            var curDist = 0
            for i in 0..<short.count {
                if (short.get(i: i) != long.get(i: (i + shift) % long.count)) {
                    curDist += 1
                }
            }
            dist = min(dist, curDist)
        }
        
        dist += abs(long.count - short.count)
        
        return dist
    }
    
    func getBest(word: String) -> String {
        var bestWord = ""
        var bestDist: Int = Int(1e9)
        
        for word2 in dictionary {
            let dist = getDist(word: word, word2: word2)
            if (dist < bestDist) {
                bestDist = dist
                bestWord = word2
            }
        }
        
        return bestWord
    }
    
    func fixAll() {
        let words = text.split(separator: " ")
        var result: [String] = []
        for word in words {
            let best = getBest(word: String(word))
            if (Double(getDist(word: String(word), word2: best)) / Double(best.count) < maxDist) {
                print(word + " changes to " + best)
                result += [best]
            } else {
                result += [String(word)]
            }
        }
        text = ""
        result.forEach {
            text += $0
            text += " "
        }
    }
}

extension String {
    func get (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
}
