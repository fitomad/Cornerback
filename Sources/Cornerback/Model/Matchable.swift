//
//  File.swift
//  
//
//  Created by Adolfo Vera Blasco on 17/5/23.
//

import Foundation

public protocol Matchable {
    associatedtype Element
    
    func match(request: Element) -> Bool
}
