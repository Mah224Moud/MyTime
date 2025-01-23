//
//  CounterDetailView.swift
//  MyTime
//
//  Created by Mamoudou DIALLO on 23/01/2025.
//

import Foundation
import SwiftUI
import SwiftData

struct CounterDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var event: EventItem
    @State private var currentTime = Date()
    
    init(event: EventItem) {
        self.event = event
    }
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var isEditing = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.white, .yellow, .red]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            mainContent
        }
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(timer) { currentTime = $0 }
    }
    
    // MARK: - Main Content
    private var mainContent: some View {
        VStack(spacing: 20) {
            headerSection
            timeGridSection
            resetButton
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(radius: 10)
        )
        .padding()
        .toolbar { editButton }
        .sheet(isPresented: $isEditing) { editSheet }
    }
    
    // MARK: - Components
    private var headerSection: some View {
        VStack(spacing: 10) {
            Text(event.name)
                .font(.system(size: 32, weight: .bold))
                .multilineTextAlignment(.center)
            
            Text("Depuis le")
                .font(.title2)
            
            Text(event.timestamp.formatted(date: .long, time: .shortened))
                .font(.title3)
        }
        .foregroundStyle(.black)
    }
    
    private var timeGridSection: some View {
        let components = TimeFormatter.timeComponents(from: event.timestamp, to: currentTime)
        
        return HStack(spacing: 15) {
            timeBox(value: components.days, unit: components.days == 1 ? "Jour" : "Jours")
            timeBox(value: components.hours, unit: components.hours == 1 ? "Heure" : "Heures")
            timeBox(value: components.minutes, unit: components.minutes == 1 ? "Minute" : "Minutes")
            timeBox(value: components.seconds, unit: components.seconds == 1 ? "Seconde" : "Secondes")
        }
    }
    
    private var resetButton: some View {
        Button(action: resetCounter) {
            Text("Réinitialiser")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Capsule().fill(Color.pink))
        }
    }
    
    private var editButton: some View {
        Button("Modifier") { isEditing = true }
            .font(.headline)
            .font(.headline)
    }
    
    private var editSheet: some View {
        EditEventView(event: event) { newName, newDate in
            event.name = newName
            event.timestamp = newDate
            try? modelContext.save()
        }
    }
    
    // MARK: - Methods
    private func resetCounter() {
        withAnimation {
            event.timestamp = Date()
            try? modelContext.save()
        }
    }
    
    private func timeBox(value: Int, unit: String) -> some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.system(size: 28, weight: .black, design: .rounded))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 2)
            
            Text(unit)
                .font(.system(size: 12, weight: .semibold))
                .fixedSize()
        }
        .frame(width: 80, height: 80)
        .padding(0.5)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThickMaterial)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

// MARK: - Preview
#Preview {
    CounterDetailView(event: EventItem(name: "Anniversaire", timestamp: Date()))
        .modelContainer(for: EventItem.self, inMemory: true)
}
