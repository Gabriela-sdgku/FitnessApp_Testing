//
//  ShopView.swift
//  Fitness
//

import SwiftUI

struct ShopView: View {
    @Environment(AppViewModel.self) private var vm
    @State private var showPurchaseSuccess = false
    
    let packages = [
        (title: "Single Session", credits: 1, price: "$25", badge: ""),
        (title: "Starter Pack", credits: 5, price: "$110", badge: "Popular"),
        (title: "Transformation", credits: 20, price: "$350", badge: "Best Value")
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(packages, id: \.title) { pack in
                            Button(action: { triggerPurchase(pack.credits) }) {
                                VStack(alignment: .leading, spacing: 0) {
                                    if !pack.badge.isEmpty {
                                        Text(pack.badge)
                                            .font(.caption2).bold()
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background(pack.badge == "Best Value" ? Color.purple : Color.blue)
                                            .cornerRadius(8)
                                            .padding(.leading, 16)
                                            .offset(y: 10)
                                            .zIndex(1)
                                    }
                                    
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(pack.title).font(.title3).bold()
                                                .foregroundColor(.primary)
                                            Text("\(pack.credits) Credits").font(.subheadline).foregroundColor(.secondary)
                                        }
                                        Spacer()
                                        Text(pack.price)
                                            .font(.title2).bold()
                                            .foregroundColor(.primary)
                                    }
                                    .padding()
                                    .padding(.top, pack.badge.isEmpty ? 0 : 8)
                                    .background(Color(UIColor.secondarySystemGroupedBackground))
                                    .cornerRadius(16)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(pack.badge == "Best Value" ? Color.purple.opacity(0.5) : Color.clear, lineWidth: 2)
                                    )
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                        }
                    }
                    .padding()
                    .padding(.top, 10)
                }
                
                if showPurchaseSuccess {
                    StatusOverlay(title: "Payment Successful!", icon: "checkmark.seal.fill", color: .blue)
                        .transition(.scale.combined(with: .opacity))
                        .zIndex(1)
                }
            }
            .navigationTitle("Buy Credits")
        }
    }
    
    private func triggerPurchase(_ amount: Int) {
        vm.addCredits(amount)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        withAnimation(.spring()) { showPurchaseSuccess = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation { showPurchaseSuccess = false }
        }
    }
}

struct StatusOverlay: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: icon).font(.system(size: 60)).foregroundColor(color)
            Text(title).font(.headline).bold()
        }
        .padding(40)
        .background(.ultraThinMaterial)
        .cornerRadius(25)
        .shadow(color: .black.opacity(0.1), radius: 20)
    }
}
