//
//  twentyfourApp.swift
//  twentyfour
//
//  Created by Ziying Zheng on 5/23/25.
//

import SwiftUI

@main
struct TwentyFourApp: App {
    @StateObject private var gameManager = GameManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameManager)
        }
    }
}
