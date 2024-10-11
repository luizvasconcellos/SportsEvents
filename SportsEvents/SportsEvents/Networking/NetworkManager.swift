//
//  NetworkManager.swift
//  SportsEvents
//
//  Created by Luiz Vasconcellos on 11/10/24.
//

import Foundation

/// URLSession Protocol
protocol NetworkSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkSessionProtocol {}


/// NetworkManager protocol.
protocol NetworkManagerProtocol {
    func baseRequest<T: Decodable>(request: NetworkRequest, type: T.Type) async throws -> Result<T, NetworkAPIError>
}


/// A class NetworkManager is the manager  responsible to perform the API Request with Custom Error Handling and Cache, if user are performing GET request.
final class NetworkManager: NetworkManagerProtocol {
    
    private let urlCache: URLCache
    private let urlSession: NetworkSessionProtocol
    
    /// Initialize NetworkManger
    init(session: NetworkSessionProtocol = URLSession.shared) {
        
        let memoryCacheCapacity = 2 * 1024 * 1024
        let diskCacheCapacity = 10 * 1024 * 1024
        urlCache = URLCache(memoryCapacity: memoryCacheCapacity,
                            diskCapacity: diskCacheCapacity,
                            diskPath: "coreNetworkingCache")
        
        self.urlSession = session
    }
    
    /// Function to perform API Generic Request, that can be used to perform calls entire the app.
    /// - Parameters
    /// - request: The object to perform the comlpete request, with the URL, Method, Header, Parameters and Body.
    /// - type: The object tipe expected as result, if it'll be expected to return just a HTML you should use `String.self`.
    /// - Returns: The result of the API call `Result` with success ant the generic type `T` send as parameter or  with custom erroro `NetworkError`.
    func baseRequest<T: Decodable>(request: NetworkRequest, type: T.Type) async throws -> Result<T, NetworkAPIError> {
        let urlRequest = NetworkManager.transformToUrlRequest(fromRequest: request)
        
        do {
            let (data, response) = try await urlSession.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                return .failure(.invalidStatusCode(statusCode: httpResponse.statusCode))
            }
            
            if T.self == String.self {
                guard let resultString = String(data: data, encoding: .utf8) else {
                    return .failure(.invalidResponse)
                }
                return .success(resultString as! T)
            } else {
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    return .success(decodedData)
                } catch {
                    return .failure(.jsonParsingFailure)
                }
            }
        } catch {
            return .failure(.unkownGenericError(description: "request failed"))
        }
    }
    
    private static func transformToUrlRequest(fromRequest request: NetworkRequest) -> URLRequest {
        var urlRequest = URLRequest(url: request.baseURL)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.bodyParameters
        urlRequest.allHTTPHeaderFields = request.headers
        
        return urlRequest
    }
}
