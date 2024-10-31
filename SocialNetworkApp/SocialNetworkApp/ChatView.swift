import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct ChatView: View {
    @State private var messageText: String = ""
    @State private var messages: [ChatMessage] = []
    @State private var selectedRecipient: String = ""
    @State private var users: [String] = [] // Lijst van gebruikers
    private var db = Firestore.firestore()

    var body: some View {
        VStack {
            // Titel van de chat
            Text("Chat")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
                .foregroundColor(.green)

            // Kiezen van de ontvanger
            Picker("Kies een ontvanger", selection: $selectedRecipient) {
                ForEach(users, id: \.self) { user in
                    Text(user).tag(user)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            List(messages) { message in
                // Berichten met verschillende stijlen
                HStack {
                    Text(message.senderEmail)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    Spacer()
                    Text(message.text)
                        .padding(10)
                        .background(message.senderId == Auth.auth().currentUser?.uid ? Color.green.opacity(0.3) : Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                }
                .padding(.horizontal)
            }
            .onAppear(perform: {
                observeMessages()
                loadUsers() // Laad gebruikers bij het opstarten
            })
            .listStyle(PlainListStyle())

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
        .background(Color.white)
        .navigationTitle("")
        .navigationBarHidden(true)
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
                      let timestamp = data["timestamp"] as? Timestamp,
                      let recipientEmail = data["recipientEmail"] as? String,
                      (recipientEmail == selectedRecipient || senderEmail == selectedRecipient) else { return nil }

                return ChatMessage(id: document.documentID, senderId: senderId, senderEmail: senderEmail, text: text, timestamp: timestamp)
            }
        }
    }

    // Laad geregistreerde gebruikers
    private func loadUsers() {
        // Hier neem je aan dat je een collectie "users" hebt in Firestore
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                return
            }

            // Haal gebruikers op en sluit de ingelogde gebruiker uit
            if let documents = snapshot?.documents {
                let currentUserEmail = Auth.auth().currentUser?.email ?? ""
                self.users = documents.compactMap { document in
                    let email = document.get("email") as? String
                    // Voeg alleen de gebruikers toe die niet de huidige gebruiker zijn
                    return email != currentUserEmail ? email : nil
                }
            }
        }
    }

    // Berichten verzenden
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        let userId = Auth.auth().currentUser?.uid ?? "unknown"
        let userEmail = Auth.auth().currentUser?.email ?? "Onbekend"

        let messageData: [String: Any] = [
            "senderId": userId,
            "senderEmail": userEmail,
            "text": messageText,
            "timestamp": Timestamp(),
            "recipientEmail": selectedRecipient // Voeg de ontvanger toe aan de database
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
