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
        let schema = Schema([EventItem.self])
        let container = try! ModelContainer(for: schema)
        return container
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
                .environment(\.locale, Locale(identifier: "fr"))
        }
    }
}
