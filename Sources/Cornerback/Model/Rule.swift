import Foundation

public typealias RuleID = String

public final class Rule {    
    public private(set) var ruleID: RuleID
    public internal(set) var constraints = [any Constraint]()
    public internal(set) var isActive = true
    public internal(set) var associatedAction: CornerbackAction?
    
    public var constraintCount: Int {
        return constraints.count
    }
    
    public convenience init() {
        let uuidString = UUID().uuidString
        self.init(withRuleID: uuidString)
    }
    
    public init(withRuleID ruleID: RuleID) {
        self.ruleID = ruleID
    }
}
