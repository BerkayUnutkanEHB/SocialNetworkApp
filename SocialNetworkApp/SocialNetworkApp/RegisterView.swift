// RegisterView.swift
import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isShowingAlert = false
    @State private var alertMessage: String = ""

    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .padding(.top, 40)

                Text("Create Account")
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

                Button(action: register) {
                    Text("Registreren")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                        .shadow(color: Color.green.opacity(0.4), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 30)
                .alert(isPresented: $isShowingAlert) {
                    Alert(title: Text("Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }

                Spacer()
            }
            .padding()
        }
    }

    private func register() {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                alertMessage = error.localizedDescription
                isShowingAlert = true
            } else {
                alertMessage = "Registratie succesvol!"
                isShowingAlert = true
            }
        }
    }
}
