//
//  ScheduleView.swift
//  Fitness
//

import SwiftUI

struct ScheduleView: View {
    @Environment(AppViewModel.self) private var vm
    @State private var selectedDayIndex = 0
    
    let dailySchedule: [StudioClass] = [
        StudioClass(name: "Hot Pilates", instructor: "Sofia", time: "08:30 AM", duration: 50, intensity: "High", systemImage: "flame.fill", themeColor: .orange),
        StudioClass(name: "Power Flow", instructor: "Elena", time: "10:00 AM", duration: 60, intensity: "Medium", systemImage: "figure.mind.and.body", themeColor: .teal),
        StudioClass(name: "Reformer Sculpt", instructor: "Valeria", time: "05:30 PM", duration: 45, intensity: "High", systemImage: "figure.core.training", themeColor: .purple),
        StudioClass(name: "HIIT Burn", instructor: "Mateo", time: "07:00 PM", duration: 45, intensity: "Extreme", systemImage: "bolt.fill", themeColor: .red)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Custom Date Picker
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
                .zIndex(1)
                
                // Enhanced Class List
                ScrollView {
                    VStack(spacing: 16) {
                        let dateString = getDateString(offset: selectedDayIndex)
                        
                        ForEach(dailySchedule) { studioClass in
                            let uniqueID = "\(studioClass.name)-\(dateString)-\(studioClass.time)"
                            let isBooked = vm.isClassBooked(classID: uniqueID)
                            
                            NavigationLink(destination: ClassDetailView(studioClass: studioClass, dateString: dateString)) {
                                ClassCardView(studioClass: studioClass, isBooked: isBooked)
                            }
                            .disabled(isBooked)
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
                .background(Color(UIColor.systemGroupedBackground))
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

struct ClassCardView: View {
    let studioClass: StudioClass
    let isBooked: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Time Column
            VStack(alignment: .leading) {
                Text(studioClass.time.prefix(5))
                    .font(.title3).fontWeight(.bold)
                Text(studioClass.time.suffix(2))
                    .font(.caption).fontWeight(.semibold).foregroundColor(.secondary)
            }
            .frame(width: 60)
            
            // Details Card
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: studioClass.systemImage)
                            .foregroundColor(studioClass.themeColor)
                        Text(studioClass.name)
                            .font(.headline)
                    }
                    
                    Text("\(studioClass.duration) min • \(studioClass.instructor)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                
                if isBooked {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                } else {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color(UIColor.tertiaryLabel))
                        .font(.footnote).bold()
                }
            }
            .padding()
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isBooked ? Color.green.opacity(0.5) : Color.clear, lineWidth: 2)
            )
            .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 4)
        }
        .opacity(isBooked ? 0.6 : 1.0)
    }
}

struct DateCard: View {
    let dayOffset: Int
    let isSelected: Bool
    
    var date: Date { Calendar.current.date(byAdding: .day, value: dayOffset, to: Date()) ?? Date() }
    var dayName: String {
        let f = DateFormatter(); f.dateFormat = "EEE"; return f.string(from: date).uppercased()
    }
    var dayNumber: String {
        let f = DateFormatter(); f.dateFormat = "d"; return f.string(from: date)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(dayName).font(.caption2).fontWeight(.bold)
            Text(dayNumber).font(.title3).fontWeight(.semibold)
        }
        .frame(width: 65, height: 85)
        .background(isSelected ? Color.primary : Color(UIColor.secondarySystemBackground))
        .foregroundColor(isSelected ? Color(UIColor.systemBackground) : .primary)
        .cornerRadius(16)
        .shadow(color: isSelected ? Color.primary.opacity(0.3) : .clear, radius: 5, y: 3)
    }
}
