//
//  GradientStyles.swift
//  MyTime
//
//  Created by Mamoudou DIALLO on 24/01/2025.
//

import SwiftUI

struct Themes {
    // Définition centrale des dégradés
    static var mainViewTheme: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [.white, .yellow, .red]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    static var formViewTheme: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [.white, .yellow, .red]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// Configuration globale de la barre de navigation
struct NavigationBarAppearance {
    static func setup(textColor: UIColor, buttonColor: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: textColor]
        appearance.backgroundColor = .clear
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().tintColor = buttonColor
    }
}
