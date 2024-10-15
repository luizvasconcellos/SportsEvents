//
//  Sports.swift
//
//  Created by Luiz Vasconcellos on 11/10/24.
//

import Foundation

// MARK: - Sport
typealias Sports = [Sport]

struct Sport: Codable, Sendable {
    let sportName: String
    var activeEvents: [Event]
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
    
    var emoji: String {
        switch self {
        case .bask: return "🏀"
        case .dart: return "🎯"
        case .esps: return "🏊‍♂️"
        case .foot, .futs: return "⚽️"
        case .hand: return "🤾‍♂️"
        case .iceh: return "🏒"
        case .snoo: return "🎱"
        case .tabl: return "🏓"
        case .tenn: return "🎾"
        case .voll: return "🏐"
        }
    }
}
