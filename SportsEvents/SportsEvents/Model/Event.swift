//
//  Event.swift
//  SportsEvents
//
//  Created by Luiz Vasconcellos on 11/10/24.
//

import Foundation

// MARK: - Event
struct Event: Codable, Sendable {
    let eventId: String
    let eventName: String
    let sportId: SportId
    let eventStartTimeUnix: Int
    var eventStartTime: Date {
        Date(timeIntervalSince1970: TimeInterval(eventStartTimeUnix))
    }
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case eventId = "i"
        case eventName = "d"
        case sportId = "si"
        case eventStartTimeUnix = "tt"
    }
}
