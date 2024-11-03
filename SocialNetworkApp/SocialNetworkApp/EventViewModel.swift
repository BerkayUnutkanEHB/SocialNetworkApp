import Foundation
import FirebaseFirestore

class EventViewModel: ObservableObject {
    private var db = Firestore.firestore()
    @Published var events: [Event] = []
    
    // Voeg een eigenschap toe voor de huidige sorteeroptie
    @Published var sortOption: SortOption = .nearest

    enum SortOption: String, CaseIterable {
        case nearest = "Dichtstbijzijnde Datum"
        case farthest = "Verste Datum"
        case alphabetical = "Alfabetisch"
    }

    func saveEvent(name: String, description: String, date: Date, time: String, location: String, createdBy: String) {
        let newEvent = Event(id: nil, name: name, description: description, date: date, time: time, location: location, createdBy: createdBy)
        
        do {
            let _ = try db.collection("events").addDocument(from: newEvent)
        } catch {
            print("Error saving event: \(error)")
        }
    }

    func fetchEvents() {
        db.collection("events").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching events: \(error)")
                return
            }
            
            if let snapshot = snapshot {
                self.events = snapshot.documents.compactMap { document in
                    try? document.data(as: Event.self)
                }
                // Sorteer evenementen direct na het ophalen
                self.sortEvents()
            }
        }
    }

    func sortEvents() {
        switch sortOption {
        case .nearest:
            events.sort { $0.date < $1.date }
        case .farthest:
            events.sort { $0.date > $1.date }
        case .alphabetical:
            events.sort { $0.name < $1.name }
        }
    }
}
