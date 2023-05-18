//
//  RulesTests.swift
//  
//
//  Created by Adolfo Vera Blasco on 17/5/23.
//

import XCTest
@testable import Cornerback

final class RulesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

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

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
