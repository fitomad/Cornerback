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

extension Rule: CustomStringConvertible {
    var description: String {
        let constrainsDescription =  self.constraints
                                         .map({ String(describing: $0) })
                                         .joined(separator: "\n\t\t")
        
        let message = """
        🏉 Rule (\(self.ruleID))
            Is Active: \(self.isActive)
            Associated Action: \(self.associatedAction == nil ? "false" : "true")
            Constraints (\(self.constraintCount)):
            \t\(constrainsDescription)
        """
        
        return message
    }
}
