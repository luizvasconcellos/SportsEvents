//
//  NetworkingRequest.swift
//  SportsEvents
//
//  Created by Luiz Vasconcellos on 11/10/24.
//

import Foundation

/// HTTPMethodType enum with the most used method types to call the API
enum HTTPMethodType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

/// NetworkRequest Protocol.
protocol NetworkRequestProtocol {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
    var bodyParameters: Data? { get }
}

/// A struct of the object data with necessary info to perform a request.
struct NetworkRequest: NetworkRequestProtocol {
    let baseURL: URL
    let method: HTTPMethodType
    var headers: [String: String]
    let queryParameters: [String: String]
    let bodyParameters: Data?
    
    
    /// NetworkRequest object initialize.
    /// - Parameters:
    /// - baseURL: URL to perform the API request
    /// - method: HTTPMethodType to be used to perform the API request, by default it's GET.
    /// - headers: Headers to be used on request. By default will be added the `Content-Type` `application/json`
    /// - queryParameters: Parameters to be sent on the request.
    /// - bodyParameters: Body to be sent on request
    init(baseURL: URL,
         method: HTTPMethodType = .get,
         headers: [String: String] = [:],
         queryParameters: [String: String] = [:],
         bodyParameters: Data?) {
        self.baseURL = baseURL
        self.method = method
        self.headers = NetworkRequest.addHeaders(headers)
        self.queryParameters = queryParameters
        self.bodyParameters = bodyParameters
    }
    
    private static func addHeaders(_ headers: [String: String]) -> [String: String] {
        var checkedHeaders = headers
        if !checkedHeaders.contains(where: { $0.key == "Content-Type"}) {
            checkedHeaders["Content-Type"] = "application/json"
        }
        return checkedHeaders
    }
}

