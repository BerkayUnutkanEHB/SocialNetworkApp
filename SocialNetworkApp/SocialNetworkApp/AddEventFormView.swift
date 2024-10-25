import SwiftUI

struct AddEventFormView: View {
    @State private var eventName: String = ""
    @State private var eventDescription: String = ""
    @State private var eventDate: Date = Date()
    @State private var eventTime: String = ""
    @State private var eventLocation: String = ""
    @State private var createdBy: String = ""
    
    @State private var alertMessage: String = ""
    @State private var isShowingAlert: Bool = false
    
    @ObservedObject var eventViewModel = EventViewModel()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Event Name", text: $eventName)
                    TextField("Description", text: $eventDescription)
                    DatePicker("Date", selection: $eventDate, displayedComponents: .date)
                    TextField("Time", text: $eventTime)
                    TextField("Location", text: $eventLocation)
                    TextField("Created By", text: $createdBy)
                }
                
                Button(action: {
                    eventViewModel.saveEvent(name: eventName, description: eventDescription, date: eventDate, time: eventTime, location: eventLocation, createdBy: createdBy)
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
