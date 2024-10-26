import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
//haaa
struct EventListView: View {
    @State private var events: [Event] = []
    private let db = Firestore.firestore()

    var body: some View {
        List(events) { event in
            VStack(alignment: .leading) {
                Text(event.name)
                    .font(.headline)
                Text(event.description)
                    .font(.subheadline)
            }
        }
        .onAppear {
            fetchEvents()
        }
    }

    private func fetchEvents() {
        guard let user = Auth.auth().currentUser else {
            print("No user is logged in.")
            return
        }

        db.collection("events")
            .whereField("createdBy", isEqualTo: user.uid)  // Filter alleen de events van de ingelogde gebruiker
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    return
                }
                
                // Documenten laden met een uniek ID
                self.events = snapshot?.documents.compactMap { document in
                    try? document.data(as: Event.self)
                } ?? []
            }
    }
}
