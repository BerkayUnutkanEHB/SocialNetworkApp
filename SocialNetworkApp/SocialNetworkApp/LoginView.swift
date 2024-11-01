// LoginView.swift
import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var alertMessage: String = ""
    @State private var isShowingAlert: Bool = false
    @State private var username: String = ""

    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea() // Achtergrondkleur voor een moderne uitstraling
            
            VStack(spacing: 20) {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .padding(.top, 40)

                Text("Welcome Back!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                VStack(spacing: 16) {
                    TextField("E-mail", text: $email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 4)

                    SecureField("Wachtwoord", text: $password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 4)
                }
                .padding(.horizontal, 30)

                Button(action: login) {
                    Text("Inloggen")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                        .shadow(color: Color.blue.opacity(0.4), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 30)
                .alert(isPresented: $isShowingAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
                Spacer()
            }
            .padding()
        }
    }

    private func login() {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Login Error: \(error.localizedDescription)")
                alertMessage = error.localizedDescription
                isShowingAlert = true
            } else {
                username = email
                alertMessage = "Inloggen succesvol! Welkom, \(username)!"
                isShowingAlert = true
                isLoggedIn = true
            }
        }
    }
}
