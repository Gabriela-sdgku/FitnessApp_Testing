//
//  MainTabView.swift
//  Fitness
//
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
                    Label("Buy Credits", systemImage: "creditcard.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
        .accentColor(.black)
    }
}
