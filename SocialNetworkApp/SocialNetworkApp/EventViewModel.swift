import Foundation
import FirebaseFirestore

class EventViewModel: ObservableObject {
    private var db = Firestore.firestore()
    @Published var events: [Event] = []

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
            }
        }
    }
}
