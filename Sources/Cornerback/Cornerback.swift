import Foundation

public typealias CornerbackAction = (inout URLRequest) -> Void

public final class Cornerback {
    public static let shared = Cornerback()
    
    private var rules: [Rule]
    private var lock = DispatchSemaphore(value: 0)
    
    public var urlSessionConfigurationProtocolClass: AnyClass {
        return WideReceiver.self
    }
    
    private init() {
        self.rules = [Rule]()
        URLProtocol.registerClass(WideReceiver.self)
    }
    
    deinit {
        URLProtocol.unregisterClass(WideReceiver.self)
    }
    
    @discardableResult
    public func newRuleWith(constraints: [any Constraint], performAction closure: @escaping CornerbackAction) -> some Actionable {
        lock.signal()
        
        let rule = Rule()
        
        rule.constraints = constraints
        rule.associatedAction = closure
        
        self.rules.append(rule)
        
        lock.wait()
        
        return rule
    }
    
    @discardableResult
    func removeRuleWith(ruleID: RuleID) -> Bool {
        guard let ruleIndex = self.rules.firstIndex(where: { $0.ruleID == ruleID }) else {
            return false
        }
        
        lock.signal()
        self.rules.remove(at: ruleIndex)
        lock.wait()
        
        return true
    }
    
    @discardableResult
    func enableRuleWith(ruleID: RuleID) -> Bool {
        let selectedRule = self.rules.first(where: { rule in
            return rule.ruleID == ruleID
        })
        
        if let selectedRule {
            selectedRule.isActive = true
            
            return true
        }
        
        return false
    }
    
    @discardableResult
    func disableRuleWith(ruleID: RuleID) -> Bool {
        let selectedRule = self.rules.first(where: { rule in
            return rule.ruleID == ruleID
        })
        
        if let selectedRule {
            selectedRule.isActive = false
            
            return true
        }
        
        return false
    }

    func appendConstraint(_ constraint: any Constraint, toRuleWithID ruleID: String) {
        let selectedRule = self.rules.first(where: { rule in
            rule.ruleID == ruleID
        })
        
        if let selectedRule {
            selectedRule.appendConstraint(constraint)
        }
    }
    
    func removeConstraints(_ contraint: any Constraint, toRuleWithid ruleID: String) {
        let selectedRule = self.rules.first(where: { rule in
            rule.ruleID == ruleID
        })
        
        if let selectedRule {
            selectedRule.removeConstraint(contraint)
        }
    }
    
    public func applyRulesFor(request: inout URLRequest) {
        let matchedRules = self.rules.filter { rule in
            let constraintsMatch = rule.constraints
                .map { constraint in
                    constraint.match(request: request)
                }
                .reduce(true, { $0 && $1 })
            
            return (constraintsMatch && rule.isActive)
        }
        
        matchedRules.forEach { matchedRule in
            matchedRule.associatedAction?(&request)
        }
    }
}
