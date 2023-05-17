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
    
    public func appendKind(_ kind: Kind) {
        self.kinds.append(kind)
    }
    
    public func removeKind(_ kind: Kind) {
        guard let index = self.kinds.firstIndex(of: kind) else {
            return
        }
        
        self.kinds.remove(at: index)
    }
}
