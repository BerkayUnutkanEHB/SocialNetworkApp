import SwiftUI
import Firebase
import FirebaseAuth

struct EventDetailView: View {
    let event: Event
    @State private var isParticipating: Bool = false
    @State private var participationMessage: String = ""
    @State private var participants: [String] = [] // Lijst van deelnemers

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(event.name)
                .font(.largeTitle)
                .bold()
            Text("Beschrijving: \(event.description)")
            Text("Locatie: \(event.location)")
            Text("Aangemaakt door: \(event.createdBy)")
            Text("Datum: \(event.date, style: .date)")
            Text("Tijd: \(event.time)")

            // Deelnamebericht
            if !participationMessage.isEmpty {
                Text(participationMessage)
                    .font(.subheadline)
                    .foregroundColor(.green)
            }

            // Weergeven van deelnemers
            Text("Deelnemers:")
                .font(.headline)
                .padding(.top, 20)

            ForEach(participants, id: \.self) { participant in
                Text(participant)
            }

            // Knoppen voor deelname
            HStack {
                Spacer() // Voorafgaand aan de knop voor uitlijning
                Button(action: participateInEvent) {
                    Text("Deelname Gaat")
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Spacer()

                Button(action: {
                    isParticipating = false
                    participationMessage = "\(Auth.auth().currentUser?.email ?? "Deze gebruiker") gaat niet deelnemen."
                }) {
                    Text("Deelname Gaat Niet")
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer() // Achterafgaand aan de knop voor uitlijning
            }
            .padding(.top, 20)

            Spacer()
        }
        .padding()
        .navigationTitle("Event Details")
        .onAppear(perform: loadParticipants) // Laad deelnemers bij het verschijnen van de view
    }

    // Deelname aan het evenement
    private func participateInEvent() {
        guard let userId = Auth.auth().currentUser?.uid,
              let userEmail = Auth.auth().currentUser?.email else { return }

        // Bericht dat de gebruiker deelneemt aan het evenement
        participationMessage = "\(userEmail) neemt deel aan dit evenement."

        // Voeg deelname toe aan Firestore
        let db = Firestore.firestore()
        let participationRef = db.collection("event_participations").document(UUID().uuidString)

        let participationData: [String: Any] = [
            "userId": userId,
            "userEmail": userEmail,
            "eventId": event.id ?? UUID().uuidString,
            "eventName": event.name,
            "timestamp": Timestamp(date: Date())
        ]

        participationRef.setData(participationData, merge: true) { error in
            if let error = error {
                print("Error saving participation: \(error.localizedDescription)")
            } else {
                isParticipating = true // Gebruiker heeft deelgenomen
                print("Participation saved successfully.")
                loadParticipants() // Herlaad deelnemers om de nieuwe lijst te tonen
            }
        }
    }

    // Functie om deelnemers te laden
    private func loadParticipants() {
        let db = Firestore.firestore()
        let query = db.collection("event_participations").whereField("eventId", isEqualTo: event.id ?? UUID().uuidString)

        query.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching participants: \(error.localizedDescription)")
                return
            }

            // Update de lijst van deelnemers
            participants = snapshot?.documents.compactMap { document in
                return document.get("userEmail") as? String // Verkrijg de e-mail van de deelnemer
            } ?? []
        }
    }
}
