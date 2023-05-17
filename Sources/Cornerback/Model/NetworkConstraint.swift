//
//  File.swift
//  
//
//  Created by Adolfo Vera Blasco on 17/5/23.
//

import Foundation

public enum NetworkConstraint {
    case scheme(value: String)
    case domain(name: String, allowingSubdomains: Bool = true)
    case resource(name: String)
    case query(key: String, value: String? = nil)
    case header(key: String, value: String? = nil)
}
