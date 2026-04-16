//
//  ProfileView.swift
//  Fitness
//

import SwiftUI

struct ProfileView: View {
    @Environment(AppViewModel.self) private var vm
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Dashboard Header
                    VStack(spacing: 12) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray.opacity(0.3))
                        
                        Text("My Wallet").font(.subheadline).foregroundColor(.secondary).textCase(.uppercase)
                        
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("\(vm.availableCredits)")
                                .font(.system(size: 64, weight: .bold, design: .rounded))
                            Text("Credits")
                                .font(.title3).fontWeight(.medium).foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    
                    // Bookings List
                    List {
                        Section(header: Text("Upcoming Bookings"), footer: Text("Swipe left to cancel a booking and refund your credit.")) {
                            if vm.bookedClasses.isEmpty {
                                Text("No upcoming classes.")
                                    .foregroundColor(.secondary)
                                    .padding(.vertical, 10)
                            } else {
                                ForEach(vm.bookedClasses) { session in
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Text(session.className).font(.headline)
                                            Spacer()
                                            Text("Spot \(session.spotNumber)")
                                                .font(.caption).bold()
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(Color.primary.opacity(0.1))
                                                .cornerRadius(6)
                                        }
                                        
                                        HStack {
                                            Image(systemName: "calendar")
                                            Text(session.date)
                                            Spacer()
                                            Image(systemName: "clock")
                                            Text(session.time)
                                        }
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    }
                                    .padding(.vertical, 6)
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
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
