import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

struct ProfileView: View {
    @Binding var isLoggedIn: Bool
    @State private var profileImage: UIImage? = nil
    @State private var userEvents: [Event] = []
    @State private var loading = true
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    // Vooraf gedefinieerde profielfoto's
    private let defaultProfileImages: [String] = [
        "profile1", // Zorg ervoor dat deze afbeeldingen in je asset catalog staan
        "profile2",
        "profile3"
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            // Profielfoto-sectie
            VStack {
                if let profileImage = profileImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                }
            }
            .padding()
            
            // Vooraf gedefinieerde profielfoto's weergeven
            Text("Kies een Profielfoto")
                .font(.headline)
                .padding(.top)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(defaultProfileImages, id: \.self) { imageName in
                        Button(action: {
                            selectProfileImage(named: imageName)
                        }) {
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                        }
                    }
                }
                .padding()
            }

            // Gebruikersevents tonen
            Text("Mijn Events")
                .font(.headline)
                .padding(.top)

            if loading {
                ProgressView("Laden...")
                    .padding()
            } else {
                // Eventlijst met styling aanpassingen
                List(userEvents) { event in
                    NavigationLink(destination: EventDetailView(event: event)) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(event.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text("Locatie: \(event.location)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("Datum: \(event.date, style: .date)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                    }
                    .listRowBackground(Color.clear) // Zorgt voor transparante achtergrond in lijst
                }
                .listStyle(PlainListStyle())
                .padding(.horizontal)
                .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)) // Lichtgrijze achtergrond
            }
            
            // Uitlog-knop
            Button(action: logOut) {
                Text("Uitloggen")
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 1))
            }
            .padding()
        }
        .onAppear {
            fetchProfileImage()
            fetchUserEvents()
        }
        .navigationTitle("Profiel")
    }
    
    // MARK: - Methoden

    // Selecteer een profielfoto
    private func selectProfileImage(named imageName: String) {
        if let image = UIImage(named: imageName) {
            profileImage = image
            uploadProfileImage(image)
        }
    }

    // Laad profielfoto uit Firebase Storage
    private func fetchProfileImage() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let profileImageRef = storage.reference(withPath: "profile_images/\(userId).jpg")
        profileImageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let data = data, let image = UIImage(data: data) {
                self.profileImage = image
            } else {
                print("Error loading profile image: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    // Upload profielfoto naar Firebase Storage
    private func uploadProfileImage(_ image: UIImage) {
        guard let userId = Auth.auth().currentUser?.uid,
              let imageData = image.jpegData(compressionQuality: 0.5) else { return }

        let profileImageRef = storage.reference(withPath: "profile_images/\(userId).jpg")
        profileImageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Error uploading profile image: \(error.localizedDescription)")
            } else {
                self.profileImage = image
                print("Profile image successfully uploaded.")
            }
        }
    }

    // Laad events die door de gebruiker zijn aangemaakt
    private func fetchUserEvents() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("events").whereField("createdBy", isEqualTo: userId).getDocuments { snapshot, error in
            if let documents = snapshot?.documents {
                self.userEvents = documents.compactMap { document in
                    try? document.data(as: Event.self)
                }
                self.loading = false
            } else {
                print("Error fetching user events: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    // Uitlogfunctie
    private func logOut() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
