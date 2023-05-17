import Foundation

public typealias CornerbackAction = (URLRequest) -> Void

public final class Cornerback {
    public static let shared = Cornerback()
    
    private var rules: [Rule]
    
    private init() {
        self.rules = [Rule]()
        URLProtocol.registerClass(WideReceiver.self)
    }
    
    deinit {
        URLProtocol.unregisterClass(WideReceiver.self)
    }
    
    @discardableResult
    public func newRuleWith(constraints: [any Constraint], performAction closure: @escaping CornerbackAction) -> some Actionable {
        let rule = Rule()
        rule.constraints = constraints
        rule.associatedAction = closure
        
        return rule
    }
    
    @discardableResult
    public func removeRuleWith(ruleID: RuleID) -> Bool {
        guard let ruleIndex = self.rules.firstIndex(where: { $0.ruleID == ruleID }) else {
            return false
        }
        
        self.rules.remove(at: ruleIndex)
        
        return true
    }
    
    @discardableResult
    public func enableRuleWith(ruleID: RuleID) -> Bool {
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
    public func disableRuleWith(ruleID: RuleID) -> Bool {
        let selectedRule = self.rules.first(where: { rule in
            return rule.ruleID == ruleID
        })
        
        if let selectedRule {
            selectedRule.isActive = false
            
            return true
        }
        
        return false
    }

    
    public func appendConstraint(_ constraint: any Constraint, toRuleWithID ruleID: String) {
        let selectedRule = self.rules.first(where: { rule in
            rule.ruleID == ruleID
        })
        
        if let selectedRule {
            selectedRule.appendConstraint(constraint)
        }
    }
    
    public func removeConstraints(_ contraint: any Constraint, toRuleWithid ruleID: String) {
        let selectedRule = self.rules.first(where: { rule in
            rule.ruleID == ruleID
        })
        
        if let selectedRule {
            selectedRule.removeConstraint(contraint)
        }
    }
    
    func forRequest(_ request: URLRequest, performaAction closure: @escaping CornerbackAction) {
        closure(request)
    }
    
    
    func checkRulesFor(request: URLRequest) {
        let matchedRules = self.rules.filter { rule in
            rule.constraints
                .map { constraint in
                    constraint.match(request: request)
                }
                .reduce(true, { $0 && $1 })
        }
        
        matchedRules.forEach { matchedRule in
            matchedRule.associatedAction?(request)
        }
    }
}
