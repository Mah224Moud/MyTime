//
//  EventItem.swift
//  MyTime
//
//  Created by Mamoudou DIALLO on 23/01/2025.
//

import Foundation
import SwiftData

@Model
final class EventItem {
    var id: UUID
    var name: String
    var timestamp: Date
    
    init(id: UUID = UUID(), name: String, timestamp: Date) {
        self.id = id
        self.name = name
        self.timestamp = timestamp
    }
}
