//
//  File.swift
//  
//
//  Created by Adolfo Vera Blasco on 17/5/23.
//

import Foundation

public protocol Constraint {
    func match(request: URLRequest) -> Bool
    func isEqualsTo(_ other: Constraint) -> Bool
}

extension Constraint where Self: Equatable {
    public func isEqualsTo(_ other: Constraint) -> Bool {
        guard let casting = other as? Self else {
            return false
        }
        
        return self == casting
    }
}

extension Constraint {
    internal func components(from request: URLRequest) -> URLComponents? {
        guard let baseURL = request.url,
              let components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        else
        {
            return nil
        }
        
        return components
    }
}
