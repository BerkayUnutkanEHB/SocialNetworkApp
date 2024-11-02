import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

struct ProfileView: View {
    @Binding var isLoggedIn: Bool
    @State private var profileImage: UIImage? = nil
    @State private var selectedProfileImageName: String? = nil // Sla de naam van de gekozen profielfoto op
    @State private var userName: String = ""
    @State private var selectedLocation: String = ""
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    private let defaultProfileImages: [String] = [
        "profile1", "profile2", "profile3"
    ]
    
    private let belgianCities = [
        "Antwerpen", "Brugge", "Brussel", "Gent", "Leuven",
        "Luik", "Mechelen", "Mons", "Namur", "Kortrijk"
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welkom, \(userName)!")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            
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
            
            Text("Mijn Locatie")
                .font(.headline)
                .padding(.top)

            Picker("Selecteer uw locatie", selection: $selectedLocation) {
                ForEach(belgianCities, id: \.self) { city in
                    Text(city).tag(city)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .onChange(of: selectedLocation, perform: { _ in
                saveUserData() // Opslaan wanneer locatie verandert
            })
            .padding()
            
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
            fetchUserName()
            loadUserData() // Laad opgeslagen data bij het openen van de view
        }
        .navigationTitle("Profiel")
    }
    
    private func fetchUserName() {
        if let user = Auth.auth().currentUser {
            userName = user.displayName ?? user.email ?? "Gebruiker"
        }
    }
    private func saveUserLocation(_ location: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userId).setData(["location": location], merge: true) { error in
            if let error = error {
                print("Error saving user location: \(error.localizedDescription)")
            } else {
                print("User location successfully saved.")
            }
        }
    }

    private func selectProfileImage(named imageName: String) {
        if let image = UIImage(named: imageName) {
            profileImage = image
            selectedProfileImageName = imageName // Sla de gekozen profielfotonaam op
            uploadProfileImage(image)
            saveUserData() // Sla de profielfotonaam op in Firestore
        }
    }

    private func loadUserData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userId).getDocument { snapshot, error in
            if let data = snapshot?.data() {
                // Laad locatie en profielfotonaam uit Firestore
                if let location = data["location"] as? String {
                    self.selectedLocation = location
                }
                if let profileImageName = data["profileImageName"] as? String {
                    self.selectedProfileImageName = profileImageName
                    self.profileImage = UIImage(named: profileImageName)
                }
            } else {
                print("Error loading user data: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    private func saveUserData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        // Sla locatie en profielfotonaam op in Firestore
        var userData: [String: Any] = ["location": selectedLocation]
        
        if let profileImageName = selectedProfileImageName {
            userData["profileImageName"] = profileImageName
        }
        
        db.collection("users").document(userId).setData(userData, merge: true) { error in
            if let error = error {
                print("Error saving user data: \(error.localizedDescription)")
            } else {
                print("User data successfully saved.")
            }
        }
    }

    private func uploadProfileImage(_ image: UIImage) {
        guard let userId = Auth.auth().currentUser?.uid,
              let imageData = image.jpegData(compressionQuality: 0.5) else { return }

        let profileImageRef = storage.reference(withPath: "profile_images/\(userId).jpg")
        profileImageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Error uploading profile image: \(error.localizedDescription)")
            } else {
                print("Profile image successfully uploaded.")
            }
        }
    }
    
    private func logOut() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
