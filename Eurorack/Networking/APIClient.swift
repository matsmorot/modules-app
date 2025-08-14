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
    
    func fetch<T: Codable>(for: T.Type, endpoint: Endpoint) async throws -> T
}

class FetchClient: APIClient {
    internal let baseURL: URL? = URL(filePath: "http://eurorack.ddns.net:8000")!
    let session: URLSession
    var imageCache: NSCache<NSString, UIImage>
        
    private init(session: URLSession = .shared) {
        self.session = session
        
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * cache.countLimit
        
        self.imageCache = cache
    }
    
    static let shared = FetchClient()
    
    func fetch<T: Codable>(for: T.Type, endpoint: Endpoint) async throws -> T {
        
        guard let url = baseURL?.appending(path: endpoint.path) else {
            throw APIError.invalidUrl
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("API Error: \(APIError.invalidResponse.customDescription)")
                throw APIError.invalidResponse
            }
            
            //TODO: Handle specific HTTP errors further
            switch httpResponse.statusCode {
            case 300...399: print("DEBUG: 3xx error - \(httpResponse.description)")
            case 400...499: print("DEBUG: 4xx error - \(httpResponse.description)")
            case 500...599: print("DEBUG: 5xx error - \(httpResponse.description)")
            default: break
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            
            guard !data.isEmpty else {
                print("API Error: \(APIError.invalidData.customDescription)")
                throw APIError.invalidData
            }
            
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            
            return decodedData

        } catch let DecodingError.dataCorrupted(context) {
            print("Decoding error: \(context.debugDescription)")
            throw APIError.decodingError
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key not found: \(key.stringValue), \(context.debugDescription)")
            throw APIError.decodingError
        } catch let DecodingError.typeMismatch(type, context) {
            print("Type mismatch: \(type), \(context.debugDescription)")
            throw APIError.decodingError
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value not found: \(value), \(context.debugDescription)")
            throw APIError.decodingError
            
        } catch {
            print(error.localizedDescription)
            throw APIError.unknownError(error: error)
        }
    }
    
    func fetchImage(from url: String) async -> UIImage? {
        guard let url = URL(string: url) else {
            print("DEBUG: Invalid URL string: \(url)")
            return nil
        }
        
        let cacheKey = NSString(string: url.absoluteString)
        
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            return cachedImage
        }
        
        do {
            let (data, _) = try await session.data(from: url)
            
            guard let image = UIImage(data: data) else {
                print("DEBUG: Failed to create image from data.")
                return nil
            }
            
            imageCache.setObject(image, forKey: cacheKey)
            
            return image
        } catch {
            print("DEBUG: Error in image fetching. \(error.localizedDescription)")
            
            return nil
        }
    }
}
