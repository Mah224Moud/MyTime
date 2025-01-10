import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [EventItem]

    @State private var showAddForm = false

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        CounterDetailView(event: item) // Utilisation de la nouvelle vue avec le compteur
                    } label: {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(timeDifference(from: item.timestamp))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: { showAddForm = true }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddForm) {
                AddItemView { name, date in
                    addItem(name: name, date: date)
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

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

    private func timeDifference(from date: Date) -> String {
        let now = Date()
        let difference = Calendar.current.dateComponents([.day, .hour], from: now, to: date)
        if let days = difference.day, let hours = difference.hour {
            if date > now {
                return "\(days) jours et \(hours) heures restants"
            } else {
                return "\(abs(days)) jours et \(abs(hours)) heures écoulés"
            }
        }
        return "Inconnu"
    }
}

struct CounterDetailView: View {
    let event: EventItem // L'événement à afficher

    @State private var currentTime: Date = Date() // L'heure actuelle mise à jour en temps réel
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 20) {
                Text(event.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Depuis le")
                    .font(.title)
                    .foregroundColor(.white)
                Text(event.timestamp.formatted(date: .long, time: .shortened))
                    .font(.title)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            
            Text("⏳⏳⏳")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.top, 40)
            

            HStack(spacing: 20) {
                timeBox(value: timeDifference().days, unit: "J")
                    .frame(maxWidth: .infinity)
                timeBox(value: timeDifference().hours, unit: "H")
                    .frame(maxWidth: .infinity)
                timeBox(value: timeDifference().minutes, unit: "M")
                    .frame(maxWidth: .infinity)
                timeBox(value: timeDifference().seconds, unit: "S")
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)


            Button("Réinitialiser") {
                currentTime = Date()
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding(.top, 20)
        }
        .onReceive(timer) { _ in
            currentTime = Date()
        }
        .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.orange]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
    }
    private func timeDifference() -> (days: Int, hours: Int, minutes: Int, seconds: Int) {
        let diff = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: event.timestamp, to: currentTime)
        return (days: abs(diff.day ?? 0), hours: abs(diff.hour ?? 0), minutes: abs(diff.minute ?? 0), seconds: abs(diff.second ?? 0))
    }

    private func timeBox(value: Int, unit: String) -> some View {
        VStack {
            Text("\(value)")
                .font(.system(size: 48, weight: .bold, design: .rounded))
            Text(unit)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }
}

struct AddItemView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var isPositive: Bool = true
    @State private var selectedDate: Date = Date()

    var onAdd: (String, Date) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Détails de l'événement")) {
                    TextField("Nom", text: $name)

                    Picker("Type de compteur", selection: $isPositive) {
                        Text("À partir de maintenant").tag(true)
                        Text("Depuis une date spécifique").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    if !isPositive {
                        DatePicker("Date et heure", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                    }
                }
            }
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
                        onAdd(name, finalDate)
                        dismiss()
                    }
                }
            }
        }
    }
}

@Model
class EventItem {
    var id: UUID = UUID()
    var name: String
    var timestamp: Date

    
    init(id: UUID = UUID(), name: String, timestamp: Date) {
        self.id = id
        self.name = name
        self.timestamp = timestamp
    }
}

#Preview {
    ContentView()
        .modelContainer(for: EventItem.self, inMemory: true)
}
