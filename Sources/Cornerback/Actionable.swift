//
//  File.swift
//  
//
//  Created by Adolfo Vera Blasco on 17/5/23.
//

import Foundation

public protocol Actionable {
    var ruleID: RuleID { get }
    var isActive: Bool { get }

    func remove()
    func enable()
    func disable()
    
    func appendKind(_ kind: Rule.Kind)
    func removeKind(_ kind: Rule.Kind)
}
