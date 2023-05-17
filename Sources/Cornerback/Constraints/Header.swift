//
//  File.swift
//  
//
//  Created by Adolfo Vera Blasco on 17/5/23.
//

import Foundation

public struct Header: Constraint {
    public let key: String
    public let value: String?
    
    public init(key: String, value: String? = nil) {
        self.key = key
        self.value = value
    }
    
    public func match(request: URLRequest) -> Bool {
        guard let headers = request.allHTTPHeaderFields else {
            return false
        }
        
        if let headerValue = headers[self.key] {
            if let value {
                return value == headerValue
            }
            
            return true
        }
        
        return false
    }
}

extension Header: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return (lhs.key == rhs.key) && (lhs.value == rhs.value)
    }
}
