//
//  ClassDetailView.swift
//  Fitness
//

import SwiftUI

struct ClassDetailView: View {
    let studioClass: StudioClass
    let dateString: String
    
    @Environment(AppViewModel.self) private var vm
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedSpot: Int? = nil
    @State private var showBookingSuccess = false
    @State private var showNoCreditsAlert = false
    
    let columns = [GridItem(.adaptive(minimum: 65), spacing: 16)]
    
    var occupiedSpots: [Int] {
        let hash = abs("\(studioClass.name)-\(dateString)".hashValue)
        return (1...20).filter { $0 % (hash % 4 + 2) == 0 }
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Class Info Header
                    HStack(spacing: 16) {
                        ZStack {
                            Circle().fill(studioClass.themeColor.opacity(0.1)).frame(width: 60, height: 60)
                            Image(systemName: "person.fill").font(.title).foregroundColor(studioClass.themeColor)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(studioClass.instructor).font(.title3).bold()
                            Text("Instructor").font(.subheadline).foregroundColor(.secondary)
                        }
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 6) {
                            HStack {
                                Text("\(studioClass.duration) min").fontWeight(.medium)
                                Image(systemName: "clock.fill").foregroundColor(.secondary)
                            }
                            HStack {
                                Text(studioClass.intensity).fontWeight(.medium)
                                Image(systemName: "flame.fill").foregroundColor(studioClass.themeColor)
                            }
                        }
                        .font(.footnote)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.03), radius: 10, y: 5)
                    .padding(.horizontal)
                    
                    // Studio Map Header
                    VStack(spacing: 8) {
                        Text("Select your spot").font(.title3).bold()
                        
                        // Stage visual
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(UIColor.tertiarySystemFill))
                            .frame(width: 120, height: 30)
                            .overlay(Text("Instructor").font(.caption).bold().foregroundColor(.secondary))
                            .padding(.top, 10)
                    }
                    
                    // Spots Grid
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(1...20, id: \.self) { spotNumber in
                            let isOccupied = occupiedSpots.contains(spotNumber)
                            let isSelected = selectedSpot == spotNumber
                            
                            Button(action: {
                                if !isOccupied {
                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                    selectedSpot = spotNumber
                                }
                            }) {
                                Text("\(spotNumber)")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 65)
                                    .background(backgroundColor(for: spotNumber, isOccupied: isOccupied, isSelected: isSelected))
                                    .foregroundColor(isOccupied ? Color.secondary.opacity(0.5) : (isSelected ? Color(UIColor.systemBackground) : .primary))
                                    .cornerRadius(16)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(isSelected ? Color.primary : Color.clear, lineWidth: 3)
                                    )
                            }
                            .disabled(isOccupied)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 120)
                }
                .padding(.top)
            }
            
            // Sticky Booking Button
            VStack {
                Spacer()
                VStack {
                    Button(action: confirmBooking) {
                        Text(selectedSpot != nil ? "Book Spot \(selectedSpot!) • 1 Credit" : "Select an available spot")
                            .font(.headline)
                            .foregroundColor(Color(UIColor.systemBackground))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(selectedSpot != nil ? Color.primary : Color.secondary.opacity(0.5))
                            .cornerRadius(20)
                            .shadow(color: selectedSpot != nil ? Color.primary.opacity(0.3) : .clear, radius: 10, y: 5)
                    }
                    .disabled(selectedSpot == nil)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
                .padding(.top, 10)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(UIColor.systemGroupedBackground).opacity(0), Color(UIColor.systemGroupedBackground)]), startPoint: .top, endPoint: .bottom)
                )
            }
            .ignoresSafeArea(.keyboard)
            
            if showBookingSuccess {
                StatusOverlay(title: "Spot Confirmed!", icon: "checkmark.circle.fill", color: .green)
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .navigationTitle(studioClass.name)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Out of Credits", isPresented: $showNoCreditsAlert) {
            Button("Shop", role: .none) { dismiss() }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("You need at least 1 credit to book this class. Please purchase more in the Shop.")
        }
    }
    
    private func backgroundColor(for spot: Int, isOccupied: Bool, isSelected: Bool) -> Color {
        if isOccupied { return Color(UIColor.tertiarySystemFill) }
        if isSelected { return Color.primary }
        return Color(UIColor.secondarySystemGroupedBackground)
    }
    
    private func confirmBooking() {
        guard let spot = selectedSpot else { return }
        
        let newSession = Session(
            className: studioClass.name,
            instructor: studioClass.instructor,
            date: dateString,
            time: studioClass.time,
            spotNumber: spot
        )
        
        if vm.bookSpot(session: newSession) {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            withAnimation(.spring()) { showBookingSuccess = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { dismiss() }
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            showNoCreditsAlert = true
        }
    }
}
