//
//  FitnessApp.swift
//  Fitness
//

import SwiftUI

@main
struct FitnessApp: App {
    @State private var viewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(viewModel)
        }
    }
}
