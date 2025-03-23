//
//  CardView.swift
//  cs193p_Memorize
//
//  Created by LGiki on 2025/3/7.
//

import SwiftUI

struct CardView: View {
    typealias Card = MemoryGame<String>.Card
    
    let card: Card
    
    init(_ card: Card) {
        self.card = card
    }
    
    var body: some View {
        TimelineView (.animation) { timeline in
            if card.isFaceUp || !card.isMatched {
                Pie(endAngle: .degrees(card.bonusPercentRemaining * 360))
                    .opacity(Constants.Pie.opacity)
                    .overlay(cardContents.padding(Constants.Pie.inset))
                    .padding(Constants.inset)
                    .cardify(isFaceUp: card.isFaceUp)
                    .transition(.scale )
            } else {
                Color.clear
            }
        }
    }
    
    var cardContents: some View { 
        Text(card.content)
            .font(.system(size: Constants.FontSize.largest))
            .minimumScaleFactor(Constants.FontSize.scaleFactor)
            .multilineTextAlignment(.center)
            .aspectRatio(1, contentMode: .fit)
            .rotationEffect(.degrees(card.isMatched ? 360 : 0))
            .animation(.spin(duration: 1), value: card.isMatched)
    }
    
    private struct Constants {
        static let inset: CGFloat = 5
        struct FontSize {
            static let largest: CGFloat = 200
            static let smallest: CGFloat = 10
            static let scaleFactor = smallest / largest
        }
        struct Pie {
            static let opacity: CGFloat = 0.5
            static let inset: CGFloat = 5
        }
    }
}

extension Animation {
    static func spin(duration: TimeInterval) -> Animation {
        .linear(duration: duration).repeatForever(autoreverses: false)
    }
}

struct CardView_Previews: PreviewProvider {
    typealias Card = MemoryGame<String>.Card
    
    static var previews: some View {
        VStack {
            HStack {
                CardView(Card(
                    content: "X",
                    id: "preview1"
                ))
                CardView(Card(
                    isFaceUp: true,
                    content: "X",
                    id: "preview2"
                ))
                .aspectRatio(4/3, contentMode: .fit)
            }
            HStack {
                CardView(Card(
                    isFaceUp: true,
                    isMatched: true,
                    content: "This is a very long string and I hope it fits",
                    id: "preview3"
                ))
                CardView(Card(
                    isMatched: true,
                    content: "X",
                    id: "preview4"
                ))
            }
        }
        
        .foregroundColor(.orange)
        .padding()
    }
}
