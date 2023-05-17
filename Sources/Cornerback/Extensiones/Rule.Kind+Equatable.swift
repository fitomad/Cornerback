//
//  File.swift
//  
//
//  Created by Adolfo Vera Blasco on 17/5/23.
//

import Foundation

extension Rule.Kind: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
            case (.scheme(let lhsValue), .scheme(let rhsValue)):
                return lhsValue == rhsValue
            case (.domain(let lhsValue, let lhsInclude), .domain(let rhsValue, let rhsInclude)):
                return (lhsValue == rhsValue) && (lhsInclude == rhsInclude)
            case (.resource(let lhsValue), .resource(let rhsValue)):
                return lhsValue == rhsValue
            case (.query(let lhsKey, let lhsValue), .query(let rhsKey, let rhsValue)):
                return (lhsKey == rhsKey) && (lhsValue == rhsValue)
            case (.header(let lhsKey, let lhsValue), .header(let rhsKey, let rhsValue)):
                return (lhsKey == rhsKey) && (lhsValue == rhsValue)
            default:
                return false
        }
    }
}
