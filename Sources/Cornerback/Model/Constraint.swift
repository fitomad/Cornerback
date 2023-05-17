//
//  File.swift
//  
//
//  Created by Adolfo Vera Blasco on 17/5/23.
//

import Foundation

public protocol Constraint: Equatable {
    func match<Element>(_ element: Element) -> Bool
}
