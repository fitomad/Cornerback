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

    func testCornerback() async throws {
        let cornerback = Cornerback.shared
        
        let cornerbackConstraints: [Constraint] = [
            Domain(named: "localhost"),
            Resource(path: "/cornerback")
        ]
        
        let localConstraints: [Constraint] = [
            Domain(named: "localhost")
        ]
        
        cornerback.newRuleWith(constraints: cornerbackConstraints) { urlRequest in
            print("🤘 \(urlRequest)")
            urlRequest.setValue("Cornerback v1.0.0", forHTTPHeaderField: "X-Globant")
            
            XCTAssertTrue(true)
        }
        
        cornerback.newRuleWith(constraints: localConstraints) { urlRequest in
            print("🏠 \(urlRequest)")
            
            urlRequest.setValue("Gluon", forHTTPHeaderField: "X-Secret-Project")
            XCTAssertTrue(true)
        }
        
        let localURL = try XCTUnwrap(URL(string: "http://localhost:3000/cornerback"))
        
        if #available(iOS 15.0, *) {
            let (data, response) = try await URLSession.shared.data(from: localURL)
            print(response)
        }
    }
    
    func testRuleEnableDisable() {
        let cornerback = Cornerback.shared
        
        let cornerbackConstraints: [Constraint] = [
            Domain(named: "localhost"),
            Resource(path: "/cornerback")
        ]
        
        let cornerbackRule = cornerback.newRuleWith(constraints: cornerbackConstraints) { urlRequest in
            urlRequest.setValue("Cornerback v1.0.0", forHTTPHeaderField: "X-Globant")
        }
        
        cornerbackRule.disable()
        XCTAssertFalse(cornerbackRule.isActive)
        
        cornerbackRule.enable()
        XCTAssertTrue(cornerbackRule.isActive)
    }
    
    func testConstraintRemoval() {
        let cornerback = Cornerback.shared
        
        let cornerbackConstraints: [Constraint] = [
            Domain(named: "localhost"),
            Resource(path: "/cornerback")
        ]
        
        let cornerbackRule = cornerback.newRuleWith(constraints: cornerbackConstraints) { urlRequest in
            urlRequest.setValue("Cornerback v1.0.0", forHTTPHeaderField: "X-Globant")
        }
        
        XCTAssertEqual(cornerbackRule.constraintCount, 2)
        
        cornerbackRule.removeConstraint(Domain(named: "localhost"))
        
        XCTAssertEqual(cornerbackRule.constraintCount, 1)
    }

    func testCornerbackPerformance() async throws {
        // This is an example of a performance test case.
        self.measure {
            Task {
                try await testCornerback()
            }
        }
    }
}
