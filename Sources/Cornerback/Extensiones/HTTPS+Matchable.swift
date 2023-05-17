//
//  File.swift
//  
//
//  Created by Adolfo Vera Blasco on 17/5/23.
//

import Foundation

extension NetworkConstraint: Matchable {
    public func match(request: URLRequest) -> Bool {
        switch self {
            case .scheme(let value):
                return scheme(value, match: request)
            case .domain(let name, let includeSubdomains):
                return domain(name, match: request)
            case .resource(let name):
                return resource(name, match: request)
            case .query(let key, let value):
                return queryItem(key: key, value: value, match: request)
            case .header(let key, let value):
                return header(key: key, value: value, match: request)
        }
    }
    
    private func components(from request: URLRequest) -> URLComponents? {
        guard let baseURL = request.url,
              let components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        else
        {
            return nil
        }
        
        return components
    }
    
    private func scheme(_ value: String, match request: URLRequest) -> Bool {
        guard let components = components(from: request),
              let scheme = components.scheme
        else
        {
            return false
        }

        return scheme == value
    }
    
    private func domain(_ value: String, match request: URLRequest) -> Bool {
        guard let components = components(from: request),
              let domain = components.host
        else
        {
            return false
        }

        return domain == value
    }
    
    private func resource(_ value: String, match request: URLRequest) -> Bool {
        guard let components = components(from: request) else {
            return false
        }

        return components.path == value
    }
    
    private func queryItem(key: String, value: String?, match request: URLRequest) -> Bool {
        guard let components = components(from: request), let queryItems = components.queryItems else {
            return false
        }
        
        if let value {
            return queryItems.contains(URLQueryItem(name: key, value: value))
        }
        
        let keys = queryItems.map({ $0.name })
        return keys.contains(key)
    }
    
    private func header(key: String, value: String?, match request: URLRequest) -> Bool {
        guard let headers = request.allHTTPHeaderFields else {
            return false
        }
        
        if let headerValue = headers[key] {
            if let value {
                return value == headerValue
            }
            
            return true
        }
        
        return false
    }
}
