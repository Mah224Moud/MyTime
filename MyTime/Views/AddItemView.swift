//
//  AddItemView.swift
//  MyTime
//
//  Created by Mamoudou DIALLO on 23/01/2025.
//
import Foundation
import SwiftData
import SwiftUI

struct AddItemView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var isPositive: Bool = true
    @State private var selectedDate: Date = Date()
    
    var onAdd: (String, Date) -> Void
    
    var body: some View {
        NavigationStack {
            BackgroundView(gradient: Themes.formViewTheme) {
                Form {
                    Section(header: Text("Détails de l'événement")) {
                        TextField("Nom", text: $name)
                        
                        Picker("Type de compteur", selection: $isPositive) {
                            Text("À partir de maintenant").tag(true)
                            Text("Depuis une date spécifique").tag(false)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        if !isPositive {
                            DatePicker(
                                "Date et heure",
                                selection: $selectedDate,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Ajouter un événement")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Annuler") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Ajouter") {
                            let finalDate = isPositive ? Date() : selectedDate
                            let eventName = name.isEmpty ? "Non renseigné" : name
                            onAdd(eventName, finalDate)
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AddItemView { _, _ in }
        .modelContainer(for: EventItem.self, inMemory: true)
}
