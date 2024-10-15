//
//  EventsAPIService.swift
//  SportsEvents
//
//  Created by Luiz Vasconcellos on 11/10/24.
//

import Foundation

protocol EventsAPIServiceProtocol {
    func fetchSportsEvents() async -> Result<Sports, NetworkAPIError>
}

private struct EndPoint {
    static let mockSports = "MockSports/sports.json"
}

final class EventsAPIService {
    private let networkManager: NetworkManagerProtocol
    private let baseUrl = "https://ios-kaizen.github.io/"
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
}

extension EventsAPIService: EventsAPIServiceProtocol {
    
    /// Fetch all Sports Events
    /// - Returns: the result with object and custom error <Sports and NetworkAPIError>
    func fetchSportsEvents() async -> Result<Sports, NetworkAPIError> {
        guard let url = URL(string: baseUrl + EndPoint.mockSports) else { return .failure(.invalidUrl) }
        
        do {
            let request = NetworkRequest(baseURL: url)
            
            let result = try await networkManager.baseRequest(request: request, type: Sports.self)
            
            switch result {
            case .success(let sports):
                return .success(sports)
            case .failure(let error):
                #if DEBUG
                print("DEBUG:: NetworkAPIError fetchSportsEvents error: \(error.localizedDescription)")
                #endif
                return .failure(error)
            }
        } catch {
            #if DEBUG
            print("DEBUG:: NetworkAPIError fetchSportsEvents generic error: \(error.localizedDescription)")
            #endif
            return .failure(.unknownError(error: error))
        }
    }
}
