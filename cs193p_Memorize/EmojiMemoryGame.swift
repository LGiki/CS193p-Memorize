//
//  EmojiMemorizeGame.swift
//  cs193p_Memorize
//
//  Created by LGiki on 2025/2/1.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    private static let emojis = ["👻", "🕷️", "🎃", "😈", "☺️", "🐱", "😊", "😗", "😛", "👾", "🤖", "👽", "🤡", "👺"]
    
    @Published private var model: MemoryGame<String> = MemoryGame(numberOfPairsOfCards: 8) { pairIndex in
        if emojis.indices.contains(pairIndex) {
            return emojis[pairIndex]
        } else {
            return "⁉️"
        }
    }
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    // MARK: - Intents
    
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
}
