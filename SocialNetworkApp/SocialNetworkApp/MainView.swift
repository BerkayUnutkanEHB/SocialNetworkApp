import SwiftUI

struct MainView: View {
    @Binding var isLoggedIn: Bool
    @ObservedObject var eventViewModel: EventViewModel
    @State private var isPresentingAddEventForm = false

    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                // Logo met aangepaste styling
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .padding(.top, 20)
                
                Text("Events")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                // Toevoegen event-knop
                Button(action: {
                    isPresentingAddEventForm = true
                }) {
                    HStack {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .bold))
                        Text("Voeg event toe")
                            .font(.headline)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 3)
                }
                .padding(.horizontal)
                
                // Eventlijst met styling aanpassingen
                List(eventViewModel.events) { event in
                    NavigationLink(destination: EventDetailView(event: event)) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(event.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text("Locatie: \(event.location)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("Datum: \(event.date, style: .date)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                    }
                    .listRowBackground(Color.clear) // Zorgt voor transparante achtergrond in lijst
                }
                .listStyle(PlainListStyle())
            }
            .padding(.horizontal)
            .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)) // Lichtgrijze achtergrond
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
                        HStack {
                            Image(systemName: "arrowshape.turn.up.left.fill")
                            Text("Uitloggen")
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.red)
                        .cornerRadius(8)
                    }

                }
            }
        }
    }
}
