//
//  APIClient.swift
//  Eurorack
//
//  Created by Mattias Almén on 2025-07-28.
//

import Foundation
import SwiftUI
import Combine

enum APIError: Error {
    case invalidUrl
    case badRequest
    case serverError
    case invalidResponse
    case invalidEndpoint
    case invalidData
    case decodingError
    case unknownError(error: Error)
    
    var customDescription: String {
        switch self {
        case .invalidUrl: return "Invalid URL"
        case .badRequest: return "Bad HTTP Request"
        case .serverError: return "Server error"
        case .invalidResponse: return "Invalid response"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidData: return "Invalid data"
        case .decodingError: return "Failed to parse JSON"
        case let .unknownError(error): return "An unknown error occured: \(error.localizedDescription)"
        }
    }
}

protocol Endpoint {
    var path: String { get }
}

enum ModuleEndpoint: Endpoint {
    case getModules
    case getModule(id: Int)
    case getCategories
    
    var path: String {
        switch self {
        case .getModules: return "/modules"
        case let .getModule(id): return "/modules/\(id)"
        case .getCategories: return "/categories"
        }
    }
}

protocol APIClient {
    var baseURL: URL? { get }
    var session: URLSession { get }
    
    func fetch<T: Codable>(for: T.Type, endpoint: Endpoint) async throws -> T?
}

class FetchClient: APIClient {
    internal let baseURL: URL? = URL(filePath: "http://eurorack.ddns.net:8000")!
    let session: URLSession
    var imageCache: NSCache<NSString, UIImage> {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * cache.countLimit
        
        return cache
    }
        
    private init(session: URLSession = .shared) {
        self.session = session
    }
    
    static let shared = FetchClient()
    
    func fetch<T: Codable>(for: T.Type, endpoint: Endpoint) async throws -> T? {
        
        guard let url = baseURL?.appending(path: endpoint.path) else {
            throw APIError.invalidUrl
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("API Error: \(APIError.invalidResponse)")
                throw APIError.invalidResponse
            }
            
            print("HTTP response: \(httpResponse)")
            
            switch httpResponse.statusCode {
            case 400...499: throw APIError.invalidEndpoint
            case 500...599: throw APIError.serverError
            default: print(httpResponse)
            }
            
            let decodedData = try JSONDecoder().decode(T.self, from: data)
                                    
            return decodedData
            
        } catch (let error) {
            print(error.localizedDescription)
            throw APIError.unknownError(error: error)
        }
    }
    
    func fetchImage(from url: String) async -> UIImage? {
        guard let url = URL(string: url) else {
            return nil
        }
        
        do {
            let (data, _) = try await session.data(from: url)
            return UIImage(data: data)
        } catch {
            print("DEBUG: Error in image fetching")
        }
        
        return nil
    }
}
