//
//  Item.swift
//  MyTime
//
//  Created by Mamoudou DIALLO on 22/12/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
