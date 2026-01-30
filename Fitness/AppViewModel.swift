//
//  AppViewModel.swift
//  Fitness
//
//

import SwiftUI
import Observation 

@Observable
class AppViewModel {
    var availableCredits: Int = 10
    var bookedClasses: [String] = []
    
    func bookClass(_ className: String) {
        if !bookedClasses.contains(className) {
            bookedClasses.append(className)
            if availableCredits > 0 {
                availableCredits -= 1
            }
        }
    }
    
    func addCredits(_ amount: Int) {
        availableCredits += amount
    }
}
