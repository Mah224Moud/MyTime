//
//  EditEventView.swift
//  MyTime
//
//  Created by Mamoudou DIALLO on 23/01/2025.
//

import Foundation
import SwiftUI
import SwiftData

struct EditEventView: View {
    @Bindable var event: EventItem
    var onSave: (String, Date) -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var newName: String
    @State private var newDate: Date
    
    init(event: EventItem, onSave: @escaping (String, Date) -> Void) {
        self._event = Bindable(wrappedValue: event)
        self.onSave = onSave
        self._newName = State(initialValue: event.name)
        self._newDate = State(initialValue: event.timestamp)
    }
    
    var body: some View {
        NavigationStack {
            BackgroundView(gradient: Themes.formViewTheme) {
                ZStack {
                    Form {
                        Section("Modifier l'événement") {
                            TextField("Nom", text: $newName)
                                .foregroundColor(.black)
                                .background(.white)
                            DatePicker(
                                "Date et heure",
                                selection: $newDate,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                            .foregroundColor(.black)
                            .background(.white)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .navigationTitle("Éditer l'événement")
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            saveButton
                        }
                        ToolbarItem(placement: .cancellationAction) {
                            cancelButton
                        }
                    }
                }
            }
        }
    }
    
    
    private var saveButton: some View {
        Button("Sauvegarder") {
            onSave(newName, newDate)
            dismiss()
        }
        .disabled(newName.isEmpty)
    }
    
    private var cancelButton: some View {
        Button("Annuler") {
            dismiss()
        }
    }
}

#Preview {
    EditEventView(event: EventItem(name: "Test", timestamp: Date())) { _, _ in }
        .modelContainer(for: EventItem.self, inMemory: true)
}
