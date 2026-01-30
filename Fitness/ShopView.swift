//
//  ShopView.swift
//  Fitness
//
//
import SwiftUI

struct ShopView: View {
    @Environment(AppViewModel.self) private var vm
    @State private var showPurchaseSuccess = false
    
    let packages = [
        (title: "Single Session", credits: 1, price: "$25"),
        (title: "Starter Pack", credits: 5, price: "$110"),
        (title: "Transformation", credits: 20, price: "$350")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(packages, id: \.title) { pack in
                            Button(action: { triggerPurchase(pack.credits) }) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(pack.title).font(.headline)
                                        Text("\(pack.credits) Credits").font(.subheadline).foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Text(pack.price)
                                        .font(.title3).bold()
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.black.opacity(0.05))
                                        .cornerRadius(8)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
                .background(Color(UIColor.systemGroupedBackground))
                
                if showPurchaseSuccess {
                    StatusOverlay(title: "Credits Added!", icon: "creditcard.fill", color: .blue)
                }
            }
            .navigationTitle("Buy Credits")
        }
    }
    
    private func triggerPurchase(_ amount: Int) {
        vm.addCredits(amount)
        withAnimation(.spring()) {
            showPurchaseSuccess = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation { showPurchaseSuccess = false }
        }
    }
}

struct StatusOverlay: View {
    let title: String; let icon: String; let color: Color
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: icon).font(.system(size: 60)).foregroundColor(color)
            Text(title).font(.headline).bold()
        }
        .padding(40)
        .background(.ultraThinMaterial)
        .cornerRadius(25)
        .shadow(radius: 20)
    }
}
