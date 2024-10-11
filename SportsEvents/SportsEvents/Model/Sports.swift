//
//  Sports.swift
//  SportsEvents
//
//  Created by Luiz Vasconcellos on 11/10/24.
//

import Foundation


// MARK: - Sport
struct Sport: Codable, Sendable {
    let sportName: String
    let activeEvents: [Event]
    let sportId: SportId
    
    enum CodingKeys: String, CodingKey {
        case sportName = "d"
        case activeEvents = "e"
        case sportId = "i"
    }
}

// MARK: - Sports ID
enum SportId: String, Codable, Sendable {
    case bask = "BASK"
    case dart = "DART"
    case esps = "ESPS"
    case foot = "FOOT"
    case futs = "FUTS"
    case hand = "HAND"
    case iceh = "ICEH"
    case snoo = "SNOO"
    case tabl = "TABL"
    case tenn = "TENN"
    case voll = "VOLL"
}

typealias Soports = [Sport]
