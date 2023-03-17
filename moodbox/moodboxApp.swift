//
//  moodboxApp.swift
//  moodbox
//
//  Created by 牧云踏歌 on 2023/3/13.
//

import SwiftUI

@main
struct moodboxApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
//            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
