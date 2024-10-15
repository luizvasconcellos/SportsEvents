//
//  SportsEventsViewModel.swift
//  SportsEvents
//
//  Created by Luiz Vasconcellos on 11/10/24.
//

import Foundation
import Combine

final class SportsEventsViewModel {
    
    // MARK: - properties
    @Published var sportsEventsPublished: Sports = []
    @Published var favoriteActionMessagePublished: String = ""
    @Published var fetchErrorPublished: String = ""
    
    private let serviceApi: EventsAPIServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var originalSportsEvents: Sports = []
    private(set) var sportsEvents: Sports = []
    
    // MARK: - Init
    init (serviceApi: EventsAPIServiceProtocol) {
        
        self.serviceApi = serviceApi
        fetchSportsEvents()
    }
}
 
extension SportsEventsViewModel {
    // MARK: - Functions
    
    /// Fetch Sports and  events
    func fetchSportsEvents() {
        Task {
            let result = await serviceApi.fetchSportsEvents()
            
            switch result {
            case .success(let sports):
                if originalSportsEvents.isEmpty {
                    originalSportsEvents = sports
                }
                sortEvents(sports: sports, completion: {
                    self.sportsEventsPublished = self.sportsEvents
                })
            case .failure(let error):
                fetchErrorPublished = error.customDescription
                #if DEBUG
                print("DEBUG:: Error Fetching \(error)")
                #endif
            }
        }
    }
    
    /// Mark or remove Event as Favorite
    /// - Parameters:
    /// - eventId: The event Id to be favorited
    /// - sportId: the sportId of the event to be favorited.
    func addOrRemoveFavorite(eventId: String, sportId: SportId) {
        
        guard let sportIndex = sportsEvents.firstIndex(where: { $0.sportId == sportId }),
              let eventIndex = sportsEvents[sportIndex].activeEvents.firstIndex(where: { $0.eventId == eventId }) else { return }
        
        var favoriteMessage = "Event added to favorite!"
        if sportsEvents[sportIndex].activeEvents[eventIndex].isFavorite {
            favoriteMessage = "Event removed from favorite!"
        }
        sportsEvents[sportIndex].activeEvents[eventIndex].isFavorite.toggle()
        favoriteActionMessagePublished = favoriteMessage        
        sortEvents(sports: sportsEvents)
    }
    
    // MARK: - Private Functions
    private func sortEvents(sports: Sports, completion: @escaping () -> () = {})  {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        
        let filteredAndSortedSports = sports.map { sport -> Sport in
            let filteredAndSortedEvents = sport.activeEvents
                .filter { $0.eventStartTime >= yesterday }
                .sorted { $0.isFavorite && !$1.isFavorite}
            return Sport(sportName: sport.sportName, activeEvents: filteredAndSortedEvents, sportId: sport.sportId)
        }
        sportsEvents = filteredAndSortedSports
        completion()
    }
}
