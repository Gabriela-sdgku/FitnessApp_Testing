//
//  ProfileView.swift
//  Fitness
//

import SwiftUI

struct ProfileView: View {
    @Environment(AppViewModel.self) private var vm
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("My Credits")) {
                    HStack {
                        Text("Available")
                        Spacer()
                        Text("\(vm.availableCredits)").bold()
                    }
                }
                
                Section(header: Text("Upcoming Bookings"), footer: Text("Swipe left to cancel a booking and refund your credit.")) {
                    if vm.bookedClasses.isEmpty {
                        Text("No classes booked yet").foregroundColor(.secondary)
                    } else {
                        ForEach(vm.bookedClasses) { session in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(session.className).font(.headline)
                                HStack {
                                    Text("\(session.date) • \(session.time)")
                                    Spacer()
                                    Text("Spot \(session.spotNumber)").bold()
                                }
                                .font(.caption)
                                .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    withAnimation {
                                        vm.cancelBooking(session: session)
                                        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                                    }
                                } label: {
                                    Label("Cancel", systemImage: "xmark.circle")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}
