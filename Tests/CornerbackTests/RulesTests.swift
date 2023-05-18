//
//  RulesTests.swift
//  
//
//  Created by Adolfo Vera Blasco on 17/5/23.
//

import XCTest
@testable import Cornerback

final class RulesTests: XCTestCase {
    func testRule() {
        let rule = Rule()
        
        rule.constraints = [
            Scheme(value: "https"),
            Domain(named: "github.com")
        ]
        
        let actionable: Actionable = rule
        
        actionable.appendConstraint(QueryItem(key: "api_key"))
        XCTAssertEqual(rule.constraints.count, 3)
        
        actionable.removeConstraint(Scheme(value: "https"))
        XCTAssertEqual(rule.constraints.count, 2)
    }
}
