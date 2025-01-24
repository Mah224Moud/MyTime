//
//  ContentView.swift
//  MyTime
//
//  Created by Mamoudou DIALLO on 23/01/2025.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \EventItem.timestamp, order: .reverse) private var items:
    [EventItem]
    
    @State private var showAddForm = false
    @State private var refreshID = UUID()
    
    var body: some View {
        NavigationSplitView {
            BackgroundView(gradient: Themes.mainViewTheme) {
                List {
                    ForEach(items) { item in
                        NavigationLink {
                            CounterDetailView(event: item)
                        } label: {
                            EventRowView(item: item)
                                .listRowBackground(Color.clear)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .scrollContentBackground(.hidden)
                .id(refreshID)
                .refreshable { refreshID = UUID() }
                .navigationTitle("Mes Événements")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        addButton
                    }
                }
                .preferredColorScheme(.light)
                .sheet(isPresented: $showAddForm) {
                    AddItemView { name, date in
                        addItem(name: name, date: date)
                    }
                }
            }
        } detail: {
            BackgroundView(gradient: Themes.formViewTheme) {
                Text("Sélectionnez un événement")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
        }
    }
    
    // MARK: - Components
    private var addButton: some View {
        Button(action: { showAddForm = true }) {
            Label("Ajouter", systemImage: "plus")
        }
    }
    
    // MARK: - Methods (inchangés)
    private func addItem(name: String, date: Date) {
        withAnimation {
            let newItem = EventItem(name: name, timestamp: date)
            modelContext.insert(newItem)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

// MARK: - Subviews (modifié pour la visibilité)
struct EventRowView: View {
    let item: EventItem
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.name)
                .font(.headline)
                .lineLimit(1)
                .foregroundColor(.black)
            
            Text(TimeFormatter.timeDifference(from: item.timestamp))
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Preview
#Preview {
    ContentView()
        .modelContainer(for: EventItem.self, inMemory: true)
}
