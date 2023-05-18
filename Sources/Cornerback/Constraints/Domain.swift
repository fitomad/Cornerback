//
//  File.swift
//  
//
//  Created by Adolfo Vera Blasco on 17/5/23.
//

import Foundation

public struct Domain: Constraint {
    public let requestDomain: String
    public let excludeSubdomains: Bool
    
    public init(named value: String, excludeSubdomains exclude: Bool = true) {
        self.requestDomain = value
        self.excludeSubdomains = exclude
    }
    
    public func match(request: URLRequest) -> Bool {
        guard let components = components(from: request),
              let domain = components.host
        else
        {
            return false
        }

        return domain == self.requestDomain
    }
}

 extension Domain: Equatable {
     public static func ==(lhs: Self, rhs: Self) -> Bool {
         return (lhs.requestDomain == rhs.requestDomain) && (lhs.excludeSubdomains == rhs.excludeSubdomains)
     }
 }
 
