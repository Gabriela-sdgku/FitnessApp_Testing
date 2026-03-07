//
//  AppViewModel.swift
//  Fitness
//

import SwiftUI
import Observation

@Observable
class AppViewModel {
    var availableCredits: Int {
        didSet {
            UserDefaults.standard.set(availableCredits, forKey: "savedCredits")
        }
    }
    
    var bookedClasses: [Session] {
        didSet {
            if let encoded = try? JSONEncoder().encode(bookedClasses) {
                UserDefaults.standard.set(encoded, forKey: "savedSessions")
            }
        }
    }
    
    init() {
        if UserDefaults.standard.object(forKey: "savedCredits") != nil {
            self.availableCredits = UserDefaults.standard.integer(forKey: "savedCredits")
        } else {
            self.availableCredits = 10
        }
        
        if let data = UserDefaults.standard.data(forKey: "savedSessions"),
           let decoded = try? JSONDecoder().decode([Session].self, from: data) {
            self.bookedClasses = decoded
        } else {
            self.bookedClasses = []
        }
    }
    
    func bookSpot(session: Session) -> Bool {
        guard availableCredits > 0 else { return false }
        
        if !bookedClasses.contains(where: { $0.id == session.id }) {
            bookedClasses.append(session)
            availableCredits -= 1
            return true
        }
        return false
    }
    
    func cancelBooking(session: Session) {
        if let index = bookedClasses.firstIndex(where: { $0.id == session.id }) {
            bookedClasses.remove(at: index)
            availableCredits += 1 // Refund the credit
        }
    }
    
    func isClassBooked(classID: String) -> Bool {
        bookedClasses.contains(where: { $0.id == classID })
    }
    
    func addCredits(_ amount: Int) {
        availableCredits += amount
    }
}
