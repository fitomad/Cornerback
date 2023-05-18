//
//  File.swift
//  
//
//  Created by Adolfo Vera Blasco on 17/5/23.
//

import Foundation

public struct Resource: Constraint {
    public let requestResource: String
    
    public init(path: String) {
        self.requestResource = path
    }
    
    public func match(request: URLRequest) -> Bool {
        guard let components = components(from: request) else {
            return false
        }

        return components.path == self.requestResource
    }
}

extension Resource: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.requestResource == rhs.requestResource
    }
}
