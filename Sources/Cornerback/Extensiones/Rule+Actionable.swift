//
//  File.swift
//  
//
//  Created by Adolfo Vera Blasco on 17/5/23.
//

import Foundation

extension Rule: Actionable {
    public func remove() {
        Cornerback.shared.removeRuleWith(ruleID: self.ruleID)
    }
    
    public func enable() {
        Cornerback.shared.enableRuleWith(ruleID: self.ruleID)
    }
    
    public func disable() {
        Cornerback.shared.disableRuleWith(ruleID: self.ruleID)
    }
    
    public func appendConstraint(_ constraint: any Constraint) {
        self.constraints.append(constraint)
    }
    
    public func removeConstraint(_ constraint: any Constraint) {
        self.constraints = self.constraints.filter {
            $0.isEqualsTo(constraint) == false
        }
    }
}
