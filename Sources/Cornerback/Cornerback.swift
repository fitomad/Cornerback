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
    public func makeRuleWith(kinds: [Rule.Kind], performAction closure: @escaping CornerbackAction) -> some Actionable {
        let rule = Rule()
        rule.kinds = kinds
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

    
    public func appendKind(_ kind: Rule.Kind, toRuleWithID ruleID: String) {
        
    }
    
    public func removeKind(_ kind: Rule.Kind, toRuleWithid ruleID: String) {
        
    }
    
    func forRequest(_ request: URLRequest, performaAction closure: @escaping CornerbackAction) {
        closure(request)
    }
    
    
    func checkRulesFor(request: URLRequest) {
        let matchedRules = self.rules.filter { rule in
            rule.kinds
                .map { kind in
                    kind.match(request: request)
                }
                .reduce(true, { $0 && $1 })
        }
        
        matchedRules.forEach { matchedRule in
            matchedRule.associatedAction?(request)
        }
        
    }
}
