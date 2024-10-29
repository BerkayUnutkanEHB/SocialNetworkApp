import SwiftUI

struct MainView: View {
    @Binding var isLoggedIn: Bool
    @ObservedObject var eventViewModel: EventViewModel
    @State private var isPresentingAddEventForm = false

    var body: some View {
        NavigationView {
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                
                Text("Events")
                    .font(.title2)
                    .padding(.bottom, 10)
                
                List(eventViewModel.events) { event in
                    NavigationLink(destination: EventDetailView(event: event)) {
                        VStack(alignment: .leading) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(event.name)
                                        .font(.headline)
                                    Text("Locatie: \(event.location)")
                                        .font(.subheadline)
                                }
                                Spacer()
                                Text("Details")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                    .padding(5)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(5)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            
                            Text("Datum: \(event.date, style: .date)")
                                .font(.caption)
                        }
                        .padding()
                    }
                }
                
                Button("Voeg een nieuwe event toe") {
                    isPresentingAddEventForm = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .onAppear {
                eventViewModel.fetchEvents()
            }
            .sheet(isPresented: $isPresentingAddEventForm) {
                AddEventFormView(eventViewModel: eventViewModel)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isLoggedIn = false
                    }) {
                        Text("Uitloggen")
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}
