import Foundation

public typealias RuleID = String

final class Rule {
    private(set) var ruleID: RuleID
    var constraints = [any Constraint]()
    var isActive = true
    var associatedAction: CornerbackAction?
    
    var constraintCount: Int {
        return constraints.count
    }
    
    convenience init() {
        let uuidString = UUID().uuidString
        self.init(withRuleID: uuidString)
    }
    
    init(withRuleID ruleID: RuleID) {
        self.ruleID = ruleID
    }
}
