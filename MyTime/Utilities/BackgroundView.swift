//
//  BackgroundView.swift
//  MyTime
//
//  Created by Mamoudou DIALLO on 24/01/2025.
//

import SwiftUI

struct BackgroundView<Content: View>: View {
    let gradient: LinearGradient
    let content: Content
    
    init(gradient: LinearGradient, @ViewBuilder content: () -> Content) {
        self.gradient = gradient
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            gradient
                .ignoresSafeArea()
            
            content
        }
    }
}
