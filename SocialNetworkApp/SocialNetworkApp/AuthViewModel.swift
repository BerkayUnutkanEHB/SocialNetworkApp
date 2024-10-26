import FirebaseAuth

class AuthViewModel: ObservableObject {
    // Registreren 
    func registerUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Fout bij registreren: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            print("Geregistreerde gebruiker: \(user.uid)")
        }
    }

    // Gebruiker Inlogogen
    func loginUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Fout bij inloggen: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            print("Ingelogd als gebruiker: \(user.uid)")
        }
    }
}
