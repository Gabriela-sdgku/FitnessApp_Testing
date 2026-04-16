//
//  MainTabView.swift
//  Fitness
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ScheduleView()
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }
            
            ShopView()
                .tabItem {
                    Label("Shop", systemImage: "cart.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
        .accentColor(.primary)
    }
}
