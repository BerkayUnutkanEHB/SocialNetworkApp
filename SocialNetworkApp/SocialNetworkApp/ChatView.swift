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
            // Logo en Titel
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .padding(.top, 20)
                
                Text("Chat")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            .padding(.bottom, 20)

            // Kiezen van de ontvanger
            Picker("Kies een ontvanger", selection: $selectedRecipient) {
                ForEach(users, id: \.self) { user in
                    Text(user)
                        .tag(user)
                        .foregroundColor(user == selectedRecipient ? .blue : .black) // Geef de geselecteerde ontvanger een duidelijke kleur
                        .fontWeight(user == selectedRecipient ? .bold : .regular) // Maak de geselecteerde ontvanger vetgedrukt
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.horizontal)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)

            // Berichtlijst
            List(messages) { message in
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(message.senderEmail)
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)

                        Text(message.text)
                            .padding(10)
                            .background(message.senderId == Auth.auth().currentUser?.uid ? Color.blue.opacity(0.1) : Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundColor(.primary)
                    }
                    Spacer()
                }
                .padding(.vertical, 5)
            }
            .onAppear(perform: {
                observeMessages()
                loadUsers()
            })
            .listStyle(PlainListStyle())
            .background(Color.white)

            // Berichtinvoer en verzendknop
            HStack {
                TextField("Typ je bericht...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading)
                
                Button(action: {
                    sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .padding(.trailing)
            }
            .padding()
            .background(Color.blue.opacity(0.05))
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
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                return
            }

            if let documents = snapshot?.documents {
                let currentUserEmail = Auth.auth().currentUser?.email ?? ""
                self.users = documents.compactMap { document in
                    let email = document.get("email") as? String
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
            "recipientEmail": selectedRecipient
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
