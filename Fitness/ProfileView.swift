//
//  ProfileView.swift
//  Fitness
//
//
import SwiftUI

struct ProfileView: View {
    @Environment(AppViewModel.self) private var vm
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("My Credits")) {
                    HStack {
                        Text("Available")
                        Spacer()
                        Text("\(vm.availableCredits)").bold()
                    }
                }
                
                Section(header: Text("Upcoming Bookings")) {
                    if vm.bookedClasses.isEmpty {
                        Text("No classes booked yet").foregroundColor(.secondary)
                    } else {
                        ForEach(vm.bookedClasses, id: \.self) { className in
                            Label(className, systemImage: "calendar.badge.checkmark")
                        }
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}
