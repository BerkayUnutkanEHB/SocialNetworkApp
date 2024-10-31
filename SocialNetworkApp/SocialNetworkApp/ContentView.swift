import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn: Bool = false
    @StateObject private var eventViewModel = EventViewModel() // EventViewModel om events te beheren

    var body: some View {
        TabView {
            if isLoggedIn {
                // Hoofdmenu-tab
                MainView(isLoggedIn: $isLoggedIn, eventViewModel: eventViewModel)
                    .tabItem {
                        Label("Hoofdmenu", systemImage: "house")
                    }

                // Chat-tab toevoegen
                ChatView() // Voeg de ChatView hier toe
                    .tabItem {
                        Label("Chat", systemImage: "message") // Chat-icoon
                    }
            } else {
                // Login-tab
                LoginView(isLoggedIn: $isLoggedIn)
                    .tabItem {
                        Label("Inloggen", systemImage: "person")
                    }

                // Registreren-tab
                RegisterView()
                    .tabItem {
                        Label("Registreren", systemImage: "person.fill")
                    }
            }
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
