import SwiftUI
import CoreLocation // Voeg CoreLocation toe

struct ContentView: View {
    @State private var isLoggedIn: Bool = false
    @StateObject private var eventViewModel = EventViewModel() // EventViewModel om events te beheren
    @State private var userLocation: CLLocationCoordinate2D?

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

                // Profiel-tab toevoegen
                ProfileView(isLoggedIn: $isLoggedIn) // Hier geven we de binding door
                    .tabItem {
                        Label("Profiel", systemImage: "person.crop.circle") // Profiel-icoon
                    }
                
                // Locatie-tab toevoegen
                LocationView(userLocation: userLocation)
                    .tabItem {
                        Label("Locatie", systemImage: "location")
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
        .onAppear {
            // Start met het ophalen van de locatie
            LocationManager.shared.startUpdatingLocation()
            // Haal de huidige locatie op
            if let location = LocationManager.shared.currentLocation {
                userLocation = location.coordinate
            }
        }
        .onDisappear {
            // Stop met het ophalen van de locatie
            LocationManager.shared.stopUpdatingLocation()
        }
    }
}

// MARK: - Locatieweergave
struct LocationView: View {
    var userLocation: CLLocationCoordinate2D?

    var body: some View {
        VStack {
            Text("Huidige Locatie:")
            if let location = userLocation {
                Text("Latitude: \(location.latitude), Longitude: \(location.longitude)")
            } else {
                Text("Locatie niet beschikbaar")
            }
        }
        .padding()
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
