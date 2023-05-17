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
    public func makeRuleWith(kinds: [NetworkConstraint], performAction closure: @escaping CornerbackAction) -> some Actionable {
        let rule = Rule()
        rule.constraints = kinds
        rule.associatedAction = closure
        
        return rule
    }
    
    @discardableResult
    public func removeRuleWith(ruleID: RuleID) -> Bool {
        return false
    }
    
    @discardableResult
    public func enableRuleWith(ruleID: RuleID) -> Bool {
        return false
    }
    
    @discardableResult
    public func disableRuleWith(ruleID: RuleID) -> Bool {
        return false
    }

    
    public func appendConstraint(_ constraint: NetworkConstraint, toRuleWithID ruleID: String) {
        
    }
    
    public func removeConstraints(_ contraint: NetworkConstraint, toRuleWithid ruleID: String) {
        
    }
    
    func forRequest(_ request: URLRequest, performaAction closure: @escaping CornerbackAction) {
        closure(request)
    }
    
    
    func checkRulesFor(request: URLRequest) {
        let matchedRules = self.rules.filter { rule in
            rule.constraints
                .map { constraint in
                    constraint.match(request)
                }
                .reduce(true, { $0 && $1 })
        }
        
        matchedRules.forEach { matchedRule in
            matchedRule.associatedAction?(request)
        }
        
    }
}
