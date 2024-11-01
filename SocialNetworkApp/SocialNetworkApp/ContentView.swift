import SwiftUI
import CoreLocation

struct ContentView: View {
    @State private var isLoggedIn: Bool = false
    @StateObject private var eventViewModel = EventViewModel()
    @State private var userLocation: CLLocationCoordinate2D?

    var body: some View {
        TabView {
            if isLoggedIn {
                // Hoofdmenu-tab
                MainView(isLoggedIn: $isLoggedIn, eventViewModel: eventViewModel)
                    .tabItem {
                        Label("Hoofdmenu", systemImage: "house.fill")
                    }

                // Chat-tab
                ChatView()
                    .tabItem {
                        Label("Chat", systemImage: "message.fill")
                    }

                // Profiel-tab
                ProfileView(isLoggedIn: $isLoggedIn)
                    .tabItem {
                        Label("Profiel", systemImage: "person.crop.circle.fill")
                    }

                // Locatie-tab
                LocationView(userLocation: userLocation)
                    .tabItem {
                        Label("Locatie", systemImage: "location.fill")
                    }
            } else {
                // Login-tab
                LoginView(isLoggedIn: $isLoggedIn)
                    .tabItem {
                        Label("Inloggen", systemImage: "person.fill")
                    }

                // Registreren-tab
                RegisterView()
                    .tabItem {
                        Label("Registreren", systemImage: "person.badge.plus")
                    }
            }
        }
        .onAppear {
            // Start locatie-updates
            LocationManager.shared.startUpdatingLocation()
            if let location = LocationManager.shared.currentLocation {
                userLocation = location.coordinate
            }
        }
        .onDisappear {
            // Stop locatie-updates
            LocationManager.shared.stopUpdatingLocation()
        }
        .accentColor(.blue) // Accentkleur aanpassen
    }
}

// MARK: - Locatieweergave
struct LocationView: View {
    var userLocation: CLLocationCoordinate2D?

    var body: some View {
        VStack(spacing: 20) {
            Text("Huidige Locatie:")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
            
            if let location = userLocation {
                Text("Latitude: \(String(format: "%.4f", location.latitude))")
                    .font(.body)
                    .foregroundColor(.secondary)
                Text("Longitude: \(String(format: "%.4f", location.longitude))")
                    .font(.body)
                    .foregroundColor(.secondary)
            } else {
                Text("Locatie niet beschikbaar")
                    .font(.body)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
        .padding()
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
