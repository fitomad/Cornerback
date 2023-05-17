//
//  File.swift
//  
//
//  Created by Adolfo Vera Blasco on 17/5/23.
//

import Foundation

public struct Scheme: Constraint {
    private let requestScheme: String
    
    public init(value: String) {
        self.requestScheme = value
    }
    
    public func match(_ request: URLRequest) -> Bool {
        return false
    }
}

extension Scheme: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.requestScheme == rhs.requestScheme
    }
}
