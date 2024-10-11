//
//  SportsEventsViewModel.swift
//  SportsEvents
//
//  Created by Luiz Vasconcellos on 11/10/24.
//

import Foundation

class SportsEventsViewModel {
    let serviceApi: EventsAPIServiceProtocol = EventsAPIService(networkManager: NetworkManager())
    
    init () {
        Task {
            let events = await serviceApi.fetchSportsEvents()
            print(events)
        }
    }
}
