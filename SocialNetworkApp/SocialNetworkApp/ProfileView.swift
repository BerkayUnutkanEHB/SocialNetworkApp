import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

struct ProfileView: View {
    @Binding var isLoggedIn: Bool
    @State private var profileImage: UIImage? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var imagePickerPresented = false
    @State private var userEvents: [Event] = []
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    var body: some View {
        VStack {
            // Profielfoto-sectie
            if let profileImage = profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
            }

            Button("Wijzig Profielfoto") {
                imagePickerPresented.toggle()
            }
            .padding()

            // Gebruikersevents tonen
            Text("Mijn Events")
                .font(.headline)
            List(userEvents) { event in
                Text(event.name)
            }

            // Uitlog-knop
            Button("Uitloggen") {
                logOut()
            }
            .foregroundColor(.red)
            .padding()
        }
        .onAppear {
            fetchProfileImage()
            fetchUserEvents()
        }
        .sheet(isPresented: $imagePickerPresented) {
            ImagePicker(selectedImage: $selectedImage)
                .onDisappear {
                    if let selectedImage = selectedImage {
                        uploadProfileImage(selectedImage)
                    }
                }
        }
    }
    
    // MARK: - Methoden

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
