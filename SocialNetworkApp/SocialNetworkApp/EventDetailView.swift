import SwiftUI

struct EventDetailView: View {
    let event: Event

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(event.name)
                .font(.largeTitle)
                .bold()
            Text("Beschrijving: \(event.description)")
            Text("Locatie: \(event.location)")
            Text("Aangemaakt door: \(event.createdBy)")
            Text("Datum: \(event.date, style: .date)")
            Text("Tijd: \(event.time)") // Voeg de tijd ook toe aan de details
        }
        .padding()
        .navigationTitle("Event Details")
    }
}
