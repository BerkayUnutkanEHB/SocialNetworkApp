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
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)

                // Sorteermenu
                Picker("Sorteer op", selection: $eventViewModel.sortOption) {
                    ForEach(EventViewModel.SortOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()

                Button(action: {
                    isPresentingAddEventForm = true
                }) {
                    VStack {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                Text("Voeg event toe")
                    .font(.caption)

                // Lijst van evenementen
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
