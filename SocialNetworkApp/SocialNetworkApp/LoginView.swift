import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var alertMessage: String = ""
    @State private var isShowingAlert: Bool = false
    @State private var username: String = "" // Dit is nu de e-mail

    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .padding(.top, 20)

            TextField("E-mail", text: $email)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Wachtwoord", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Inloggen") {
                login()
            }
            .padding()
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
        .background(Color.white) // Achtergrondkleur weer wit
    }

    private func login() {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Login Error: \(error.localizedDescription)")
                alertMessage = error.localizedDescription
                isShowingAlert = true
            } else {
                // Gebruik de e-mail als gebruikersnaam
                username = email
                alertMessage = "Inloggen succesvol! Welkom, \(username)!"
                isShowingAlert = true
                isLoggedIn = true
            }
        }
    }
}
