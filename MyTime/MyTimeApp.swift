//
//  MyTimeApp.swift
//  MyTime
//
//  Created by Mamoudou DIALLO on 22/12/2024.
//

import SwiftUI
import SwiftData

@main
struct MyTimeApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            EventItem.self, // Utilisation de la classe correcte
        ])
        let container = try! ModelContainer(for: schema)
        return container
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer) // Injection du conteneur
        }
    }
}
