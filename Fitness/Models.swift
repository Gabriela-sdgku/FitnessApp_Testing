//
//  Models.swift
//  Fitness
//

import Foundation

struct Session: Identifiable, Codable, Hashable {
    var id: String { "\(className)-\(date)-\(time)" }
    let className: String
    let instructor: String
    let date: String
    let time: String
    let spotNumber: Int
}

struct StudioClass: Identifiable {
    let id = UUID()
    let name: String
    let instructor: String
    let time: String
    let duration: Int
    let intensity: String
}
