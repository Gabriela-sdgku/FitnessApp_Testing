//
//  ScheduleView.swift
//  Fitness
//

import SwiftUI

struct ScheduleView: View {
    @Environment(AppViewModel.self) private var vm
    @State private var selectedDayIndex = 0
    
    // Mock schedule data
    let dailySchedule: [StudioClass] = [
        StudioClass(name: "Hot Pilates", instructor: "Sofia", time: "08:30 AM", duration: 50, intensity: "High"),
        StudioClass(name: "Power Flow", instructor: "Elena", time: "10:00 AM", duration: 60, intensity: "Medium"),
        StudioClass(name: "Reformer Sculpt", instructor: "Valeria", time: "05:30 PM", duration: 45, intensity: "High"),
        StudioClass(name: "HIIT Burn", instructor: "Mateo", time: "07:00 PM", duration: 45, intensity: "Extreme")
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(0..<7) { index in
                            DateCard(dayOffset: index, isSelected: selectedDayIndex == index)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedDayIndex = index
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    }
                                }
                        }
                    }
                    .padding()
                }
                .background(Color(UIColor.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 5, y: 5)
                
                // Class List
                List {
                    let dateString = getDateString(offset: selectedDayIndex)
                    
                    ForEach(dailySchedule) { studioClass in
                        let uniqueID = "\(studioClass.name)-\(dateString)-\(studioClass.time)"
                        let isBooked = vm.isClassBooked(classID: uniqueID)
                        
                        NavigationLink(destination: ClassDetailView(studioClass: studioClass, dateString: dateString)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(studioClass.time)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.secondary)
                                    
                                    Text(studioClass.name)
                                        .font(.headline)
                                    
                                    Text(studioClass.instructor)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                
                                if isBooked {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.title2)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                        .disabled(isBooked)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Schedule")
        }
    }
    
    private func getDateString(offset: Int) -> String {
        let date = Calendar.current.date(byAdding: .day, value: offset, to: Date()) ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
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
