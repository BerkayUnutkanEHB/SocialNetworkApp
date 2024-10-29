import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct EventListView: View {
    @State private var events: [Event] = []
    private let db = Firestore.firestore()

    var body: some View {
        NavigationView {
            List(events) { event in
                NavigationLink(destination: EventDetailView(event: event)) {
                    VStack(alignment: .leading) {
                        Text(event.name)
                            .font(.headline)
                        Text(event.description)
                            .font(.subheadline)
                            .lineLimit(2) // Optioneel: Limiteer de beschrijving tot 2 regels
                    }
                }
            }
            .navigationTitle("Events")
            .onAppear {
                fetchEvents()
            }
        }
    }

    private func fetchEvents() {
        guard let user = Auth.auth().currentUser else {
            print("No user is logged in.")
            return
        }

        db.collection("events")
            .whereField("createdBy", isEqualTo: user.uid)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    return
                }
                
                self.events = snapshot?.documents.compactMap { document in
                    try? document.data(as: Event.self)
                } ?? []
            }
    }
}
