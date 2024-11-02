import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct AddEventView: View {
    @State private var eventName: String = ""
    @State private var eventDescription: String = ""
    @State private var eventDate: Date = Date()
    @State private var eventTime: String = ""
    @State private var selectedLocation: String = "" // Aangepast
    @State private var showAlert: Bool = false

    private let db = Firestore.firestore()

    // Voeg hier de locaties toe
    private let locations = [
        "Antwerpen",
        "Brussel",
        "Gent",
        "Brugge",
        "Leuven",
        "Mechelen",
        "Namur",
        "Luik",
        "Kortrijk",
        "Oostende"
    ]

    var body: some View {
        VStack {
            TextField("Event Name", text: $eventName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Event Description", text: $eventDescription)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            DatePicker("Event Date", selection: $eventDate, displayedComponents: .date)
                .padding()
            TextField("Event Time", text: $eventTime)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Locatie dropdown
            Picker("Location", selection: $selectedLocation) {
                ForEach(locations, id: \.self) { location in
                    Text(location).tag(location)
                }
            }
            .pickerStyle(MenuPickerStyle()) // Of gebruik een andere stijl als je dat wilt
            .padding()
            
            Button("Add Event") {
                addEvent()
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Success"), message: Text("Event added successfully"), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
    }

    private func addEvent() {
        // Haal de huidige ingelogde gebruiker op
        guard let user = Auth.auth().currentUser else {
            print("No user is logged in.")
            return
        }

        // Maak een dictionary met de eventgegevens, inclusief `createdBy`
        let event = [
            "name": eventName,
            "description": eventDescription,
            "date": Timestamp(date: eventDate),
            "time": eventTime,
            "location": selectedLocation,  // Gebruik de geselecteerde locatie
            "createdBy": user.uid  // Gebruik de UID van de huidige gebruiker
        ] as [String : Any]
        
        db.collection("events").addDocument(data: event) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Event added successfully")
                showAlert = true  // Toon een bevestigingsbericht na het succesvol toevoegen
                // Reset velden na het succesvol toevoegen van een event
                eventName = ""
                eventDescription = ""
                eventDate = Date()
                eventTime = ""
                selectedLocation = ""  // Reset de geselecteerde locatie
            }
        }
    }
}
