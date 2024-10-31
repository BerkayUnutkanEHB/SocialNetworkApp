import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct ChatView: View {
    @State private var messageText: String = ""
    @State private var messages: [ChatMessage] = []
    private var db = Firestore.firestore()

    var body: some View {
        VStack {
            // Titel van de chat
            Text("Chat")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
                .foregroundColor(.blue) // Kleur van de titel

            List(messages) { message in
                HStack {
                    Text(message.senderEmail)
                        .fontWeight(.bold)
                        .foregroundColor(.blue) // Kleur van de afzender
                    Spacer()
                    Text(message.text)
                        .padding(10)
                        .background(message.senderId == Auth.auth().currentUser?.uid ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2)) // Achtergrondkleur per afzender
                        .cornerRadius(10)
                        .foregroundColor(.black)
                }
                .padding(.horizontal)
            }
            .onAppear(perform: observeMessages)
            .listStyle(PlainListStyle()) // Maak de lijst eenvoudiger

            HStack {
                TextField("Typ je bericht...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    sendMessage()
                }) {
                    Text("Verzend")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .background(Color.white) // Achtergrondkleur van de chat
        .navigationTitle("") // Geen titel in de navigatiebalk
        .navigationBarHidden(true) // Verberg de navigatiebalk
    }

    // Berichten observeren
    private func observeMessages() {
        db.collection("messages").order(by: "timestamp").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents: \(error?.localizedDescription ?? "")")
                return
            }
            self.messages = documents.compactMap { document -> ChatMessage? in
                let data = document.data()
                guard let senderId = data["senderId"] as? String,
                      let senderEmail = data["senderEmail"] as? String,
                      let text = data["text"] as? String,
                      let timestamp = data["timestamp"] as? Timestamp else { return nil }

                return ChatMessage(id: document.documentID, senderId: senderId, senderEmail: senderEmail, text: text, timestamp: timestamp)
            }
        }
    }

    // Berichten verzenden
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        let userId = Auth.auth().currentUser?.uid ?? "unknown"
        let userEmail = Auth.auth().currentUser?.email ?? "Onbekend" // Haal de e-mail op
        let messageData: [String: Any] = [
            "senderId": userId,
            "senderEmail": userEmail,
            "text": messageText,
            "timestamp": Timestamp()
        ]
        
        db.collection("messages").document(UUID().uuidString).setData(messageData) { error in
            if let error = error {
                print("Error sending message: \(error.localizedDescription)")
            }
        }
        
        messageText = "" // Reset het invoerveld
    }
}

// MARK: - ChatMessage Struct
struct ChatMessage: Identifiable {
    let id: String
    let senderId: String
    let senderEmail: String
    let text: String
    let timestamp: Timestamp
}
