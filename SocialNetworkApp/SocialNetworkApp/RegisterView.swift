import SwiftUI
import FirebaseAuth
//registreren
struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isShowingAlert = false
    @State private var alertMessage: String = ""

    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .padding(.top, 20)
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Wachtwoord", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                register()
            }) {
                Text("Registreren")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text("Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
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
