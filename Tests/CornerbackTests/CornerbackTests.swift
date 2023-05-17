//
//  CornerbackTests.swift
//  
//
//  Created by Adolfo Vera Blasco on 17/5/23.
//

import XCTest
@testable import Cornerback

final class CornerbackTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCornerback() {
        let cornerback = Cornerback.shared
        
        let githubConstraints: [Constraint] = [
            Scheme(value: "https"),
            Domain("github.blog")
        ]
        
        let githubRule = cornerback.newRuleWith(constraints: githubConstraints) { urlRequest in
            print("Action")
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
