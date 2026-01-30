//
//  ScheduleView.swift
//  Fitness
//
//


import SwiftUI

struct ScheduleView: View {
    @Environment(AppViewModel.self) private var vm
        
        @State private var selectedDayIndex = 0
        @State private var showBookingSuccess = false
    
    let classes = ["Hot Pilates", "Power Flow", "Reformer Sculpt", "HIIT Burn"]
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(0..<5) { index in
                                DateCard(dayOffset: index, isSelected: selectedDayIndex == index)
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            selectedDayIndex = index
                                        }
                                    }
                            }
                        }
                        .padding()
                    }
                    
                    List {
                        ForEach(classes, id: \.self) { fitnessClass in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("08:30 AM").font(.caption).foregroundColor(.secondary)
                                    Text(fitnessClass).font(.headline)
                                }
                                Spacer()
                                Button(action: { triggerBooking(fitnessClass) }) {
                                    Text(vm.bookedClasses.contains(fitnessClass) ? "Booked" : "Book")
                                        .fontWeight(.bold)
                                        .frame(width: 80)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(vm.bookedClasses.contains(fitnessClass) ? .gray : .black)
                                .disabled(vm.bookedClasses.contains(fitnessClass))
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(.plain)
                }
                
                if showBookingSuccess {
                    StatusOverlay(title: "Class Booked!", icon: "checkmark.circle.fill", color: .green)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .navigationTitle("Schedule")
        }
    }
    
    private func triggerBooking(_ name: String) {
        vm.bookClass(name)
        withAnimation(.spring()) {
            showBookingSuccess = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation { showBookingSuccess = false }
        }
    }
}

struct DateCard: View {
    let dayOffset: Int
    let isSelected: Bool
    
    var date: Date {
        Calendar.current.date(byAdding: .day, value: dayOffset, to: Date()) ?? Date()
    }
    
    var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE" 
        return formatter.string(from: date).uppercased()
    }
    
    var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(dayName)
                .font(.caption2)
                .fontWeight(.bold)
            
            Text(dayNumber)
                .font(.title3)
                .fontWeight(.semibold)
        }
        .frame(width: 60, height: 80)
        .background(isSelected ? Color.black : Color.gray.opacity(0.1))
        .foregroundColor(isSelected ? .white : .black)
        .cornerRadius(12)
    }
}
