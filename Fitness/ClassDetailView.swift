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
    
    let columns = [
        GridItem(.adaptive(minimum: 60), spacing: 16)
    ]
    
    var occupiedSpots: [Int] {
        let hash = abs("\(studioClass.name)-\(dateString)".hashValue)
        return (1...20).filter { $0 % (hash % 4 + 2) == 0 }
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    HStack(spacing: 16) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray.opacity(0.5))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(studioClass.instructor).font(.title2).bold()
                            Text("Instructor").font(.subheadline).foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            HStack {
                                Image(systemName: "clock")
                                Text("\(studioClass.duration) min")
                            }
                            HStack {
                                Image(systemName: "flame.fill").foregroundColor(.orange)
                                Text(studioClass.intensity)
                            }
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        Text("Select your spot")
                            .font(.headline)
                        Text("Front of Room")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 10)
                    }
                    .padding(.horizontal)
                    
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
                                    .frame(width: 60, height: 60)
                                    .background(backgroundColor(for: spotNumber, isOccupied: isOccupied, isSelected: isSelected))
                                    .foregroundColor(isOccupied ? .gray : (isSelected ? .white : .primary))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(isSelected ? Color.black : Color.clear, lineWidth: 2)
                                    )
                            }
                            .disabled(isOccupied)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100)
                }
            }
            
            VStack {
                Spacer()
                VStack {
                    Button(action: confirmBooking) {
                        Text(selectedSpot != nil ? "Book Spot \(selectedSpot!)" : "Select a spot")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedSpot != nil ? Color.black : Color.gray)
                            .cornerRadius(16)
                    }
                    .disabled(selectedSpot == nil)
                    .padding()
                }
                .background(.ultraThinMaterial)
            }
            .ignoresSafeArea(.keyboard)
            
            if showBookingSuccess {
                StatusOverlay(title: "Spot Confirmed!", icon: "checkmark.circle.fill", color: .green)
                    .zIndex(1)
            }
        }
        .navigationTitle(studioClass.name)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Out of Credits", isPresented: $showNoCreditsAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please purchase more credits in the Shop to book this class.")
        }
    }
    
    private func backgroundColor(for spot: Int, isOccupied: Bool, isSelected: Bool) -> Color {
        if isOccupied { return Color.gray.opacity(0.2) }
        if isSelected { return Color.black }
        return Color.blue.opacity(0.1)
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
        
        let success = vm.bookSpot(session: newSession)
        
        if success {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            withAnimation(.spring()) {
                showBookingSuccess = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                dismiss()
            }
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            showNoCreditsAlert = true
        }
    }
}
