//
//  EmojiMemoryGameView.swift
//  cs193p_Memorize
//
//  Created by LGiki on 2025/1/24.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    typealias Card = MemoryGame<String>.Card
    
    @ObservedObject var emojiMemoryGame: EmojiMemoryGame
    
    private let cardAspectRatio: CGFloat = 2/3
    private let dealAnimation: Animation = .easeInOut(duration: 0.5)
    private let dealInterval: TimeInterval = 0.15
    
    var body: some View {
        VStack {
            cards.foregroundColor(emojiMemoryGame.color)
            HStack {
                score
                Spacer()
                deck.foregroundColor(emojiMemoryGame.color)
                Spacer()
                shuffle
            }
        }
        .padding()
    }
    
    private var score: some View {
        Text("Score: \(emojiMemoryGame.score)")
    }
    
    private var shuffle: some View {
        Button("Shuffle") {
            withAnimation {
                emojiMemoryGame.shuffle()
            }
        }
    }
    
    private var cards: some View {
        AspectVGrid (emojiMemoryGame.cards, aspectRatio: cardAspectRatio) { card in
            if isDealt(card) {
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .padding(4)
                    .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                    .zIndex(scoreChange(causedBy: card) != 0 ? 1 : 0)
                    .onTapGesture {
                        choose(card)
                    }
            }
        }
    }
    
    @Namespace private var dealingNamespace
    
    private let deckWidth: CGFloat = 50
    
    private var deck: some View {
        ZStack {
            ForEach(undealCards) { card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: deckWidth, height: deckWidth / cardAspectRatio)
        .onTapGesture {
            deal()
        }
    }
    
    private func deal() {
        var delay: TimeInterval = 0
        for card in emojiMemoryGame.cards {
            withAnimation(dealAnimation.delay(delay)) {
                _ = dealt.insert(card.id)
            }
            delay += dealInterval
        }
    }
    
    @State private var dealt = Set<Card.ID>()
    
    private func isDealt(_ card: Card) -> Bool {
        dealt.contains(card.id)
    }
    
    private var undealCards: [Card] {
        emojiMemoryGame.cards.filter { !isDealt($0) }
    }
    
    private func choose(_ card: Card) {
        withAnimation {
            let scoreBeforeChoosing = emojiMemoryGame.score
            emojiMemoryGame.choose(card)
            let scoreChange = emojiMemoryGame.score - scoreBeforeChoosing
            lastScoreChange = (scoreChange, card.id)
        }
    }
    
    @State private var lastScoreChange = (0, causedByCardId: "")
    
    private func scoreChange(causedBy card: Card) -> Int {
        let (amount, id) = lastScoreChange
        return id == card.id ? amount : 0
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(emojiMemoryGame: EmojiMemoryGame())
    }
}
