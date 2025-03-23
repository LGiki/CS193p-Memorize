//
//  cs193p_MemorizeApp.swift
//  cs193p_Memorize
//
//  Created by LGiki on 2025/1/24.
//

import SwiftUI

@main
struct cs193p_MemorizeApp: App {
    @StateObject var game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(emojiMemoryGame: game)
        }
    }
}
