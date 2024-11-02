import SwiftUI

struct AddEventFormView: View {
    @State private var eventName: String = ""
    @State private var eventDescription: String = ""
    @State private var eventDate: Date = Date()
    @State private var eventTime: String = ""
    @State private var selectedLocation: String = "" // Aangepast
    @State private var createdBy: String = ""
    
    @State private var alertMessage: String = ""
    @State private var isShowingAlert: Bool = false
    
    @ObservedObject var eventViewModel = EventViewModel()
    
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
        NavigationView {
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Event Name", text: $eventName)
                    TextField("Description", text: $eventDescription)
                    DatePicker("Date", selection: $eventDate, displayedComponents: .date)
                    TextField("Time", text: $eventTime)
                    
                    // Locatie dropdown
                    Picker("Location", selection: $selectedLocation) {
                        ForEach(locations, id: \.self) { location in
                            Text(location).tag(location)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()) // Of gebruik een andere stijl als je dat wilt
                    
                    TextField("Created By", text: $createdBy)
                }
                
                Button(action: {
                    eventViewModel.saveEvent(name: eventName, description: eventDescription, date: eventDate, time: eventTime, location: selectedLocation, createdBy: createdBy) // Gebruik selectedLocation
                    alertMessage = "Event succesvol toegevoegd!"
                    isShowingAlert = true
                }) {
                    Text("Save Event")
                }
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text("Success"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .navigationTitle("Add Event")
        }
    }
}

struct AddEventFormView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventFormView()
    }
}
