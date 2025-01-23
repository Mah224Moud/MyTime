//
//  TimeFormatter.swift
//  MyTime
//
//  Created by Mamoudou DIALLO on 23/01/2025.
//

import Foundation

struct TimeFormatter {
    
    /// Formate la différence entre une date donnée et maintenant en chaîne lisible
    /// - Parameter date: Date de référence
    /// - Returns: Chaîne formatée comme "Il y a 2 heures"
    static func timeDifference(from date: Date) -> String {
        let now = Date()
        let difference = Calendar.current.dateComponents([.second, .minute, .hour, .day, .weekOfYear, .month, .year],
                                                         from: date,
                                                         to: now)
        
        if let years = difference.year, years > 0 {
            return years == 1 ? "il y a 1 an" : "il y a \(years) ans"
        }
        
        if let months = difference.month, months > 0 {
            return months == 1 ? "il y a 1 mois" : "il y a \(months) mois"
        }
        
        if let weeks = difference.weekOfYear, weeks > 0 {
            return weeks == 1 ? "il y a 1 semaine" : "il y a \(weeks) semaines"
        }
        
        if let days = difference.day, days > 0 {
            return days == 1 ? "il y a 1 jour" : "il y a \(days) jours"
        }
        
        if let hours = difference.hour, hours > 0 {
            return hours == 1 ? "il y a 1 heure" : "il y a \(hours) heures"
        }
        
        if let minutes = difference.minute, minutes > 0 {
            return minutes == 1 ? "il y a 1 minute" : "il y a \(minutes) minutes"
        }
        
        if let seconds = difference.second, seconds > 0 {
            return seconds == 1 ? "il y a 1 seconde" : "il y a \(seconds) secondes"
        }
        
        return "À l'instant"
    }
    
    /// Calcule les composants temporels entre deux dates
    /// - Parameters:
    ///   - startDate: Date de début
    ///   - endDate: Date de fin
    /// - Returns: Tuple avec jours, heures, minutes, secondes
    static func timeComponents(from startDate: Date, to endDate: Date) -> (days: Int, hours: Int, minutes: Int, seconds: Int) {
        let diff = Calendar.current.dateComponents([.day, .hour, .minute, .second],
                                                   from: startDate,
                                                   to: endDate)
        return (
            days: abs(diff.day ?? 0),
            hours: abs(diff.hour ?? 0),
            minutes: abs(diff.minute ?? 0),
            seconds: abs(diff.second ?? 0)
        )
    }
}
