import XCTest
@testable import Cornerback

final class RuleTests: XCTestCase {
    func testRuleKindScheme() {
        let schemeOne = NetworkConstraint.scheme(value: "http")
        let schemeTwo = NetworkConstraint.scheme(value: "http")
        let schemeSecure = NetworkConstraint.scheme(value: "https")
        
        XCTAssertEqual(schemeOne, schemeTwo)
        XCTAssertNotEqual(schemeOne, schemeSecure)
    }
    
    func testRuleKindDomain() {
        let domainOne = NetworkConstraint.domain(name: "github.com")
        let domainTwo = NetworkConstraint.domain(name: "github.com")
        let domainFake = NetworkConstraint.domain(name: "falsegithub.com")
        
        XCTAssertEqual(domainOne, domainTwo)
        XCTAssertNotEqual(domainOne, domainFake)
    }
    
    func testRuleKindResource() {
        let resourceOne = NetworkConstraint.resource(name: "index.html")
        let resourceTwo = NetworkConstraint.resource(name: "index.html")
        let resourceAbout = NetworkConstraint.resource(name: "about.html")
        
        XCTAssertEqual(resourceOne, resourceTwo)
        XCTAssertNotEqual(resourceOne, resourceAbout)
    }
    
    func testRuleKindQuery() {
        let queryKeyOne = NetworkConstraint.query(key: "api_key")
        let queryKeyTwo = NetworkConstraint.query(key: "api_key")
        let queryKeyPage = NetworkConstraint.query(key: "page")
        
        XCTAssertEqual(queryKeyOne, queryKeyTwo)
        XCTAssertNotEqual(queryKeyOne, queryKeyPage)
        
        let queryKeyValueOne = NetworkConstraint.query(key: "api_key", value: "asdf")
        let queryKeyValueTwo = NetworkConstraint.query(key: "api_key", value: "asdf")
        let queryKeyValuePageOne = NetworkConstraint.query(key: "page", value: "1")
        let queryKeyValuePageTwo = NetworkConstraint.query(key: "page", value: "2")
        
        XCTAssertEqual(queryKeyValueOne, queryKeyValueTwo)
        XCTAssertNotEqual(queryKeyValueOne, queryKeyValuePageOne)
        XCTAssertNotEqual(queryKeyValuePageOne, queryKeyValuePageTwo)
        
        XCTAssertNotEqual(queryKeyOne, queryKeyValueOne)
    }
    
    func testRuleKindHeader() {
        let headerKeyOne = NetworkConstraint.header(key: "Content-Type")
        let headerKeyTwo = NetworkConstraint.header(key: "Content-Type")
        let headerKeyPage = NetworkConstraint.header(key: "User-Agent")
        
        XCTAssertEqual(headerKeyOne, headerKeyTwo)
        XCTAssertNotEqual(headerKeyOne, headerKeyPage)
        
        let headerKeyValueOne = NetworkConstraint.header(key: "Content-Type", value: "application/json")
        let headerKeyValueTwo = NetworkConstraint.header(key: "Content-Type", value: "application/json")
        let headerKeyValuePageOne = NetworkConstraint.header(key: "User-Agent", value: "Gluon")
        let headerKeyValuePageTwo = NetworkConstraint.header(key: "User-Agent", value: "OneApp")
        
        XCTAssertEqual(headerKeyValueOne, headerKeyValueTwo)
        XCTAssertNotEqual(headerKeyValueOne, headerKeyValuePageOne)
        XCTAssertNotEqual(headerKeyValuePageOne, headerKeyValuePageTwo)
        
        XCTAssertNotEqual(headerKeyOne, headerKeyValueOne)
    }
    
    func testRuleKindSchemeMatch() {
        let scheme = NetworkConstraint.scheme(value: "https")
        
        let githubRequest = self.makeGitHubURLRequest()
        
        var result = scheme.match(request: githubRequest)
        XCTAssertTrue(result)
        
        let unsecureRequest = self.makeUnsecureGitHubURLRequest()
        
        result = scheme.match(request: unsecureRequest)
        XCTAssertFalse(result)
    }
    
    func testRuleKindDomainMatch() {
        let domain = NetworkConstraint.domain(name: "github.blog")
        
        let githubRequest = self.makeGitHubURLRequest()
        
        var result = domain.match(request: githubRequest)
        XCTAssertTrue(result)
        
        let unsecureRequest = self.makeUnsecureGitHubURLRequest()
        
        result = domain.match(request: unsecureRequest)
        XCTAssertFalse(result)
    }
    
    func testRuleKindResourceMath() {
        let resource = NetworkConstraint.resource(name: "/category/engineering")
        
        let githubRequest = self.makeGitHubURLRequest()
        
        var result = resource.match(request: githubRequest)
        XCTAssertTrue(result)
        
        let unsecureRequest = self.makeUnsecureGitHubURLRequest()
        
        result = resource.match(request: unsecureRequest)
        XCTAssertFalse(result)
    }
    
    func testRuleKindQueryMatch() {
        let query = NetworkConstraint.query(key: "api")
        
        let githubRequest = self.makeGitHubURLRequest()
        
        var result = query.match(request: githubRequest)
        XCTAssertTrue(result)
        
        let unsecureRequest = self.makeUnsecureGitHubURLRequest()
        
        result = query.match(request: unsecureRequest)
        XCTAssertFalse(result)
        
        let queryValue = NetworkConstraint.query(key: "api", value: "asdf")
        result = queryValue.match(request: githubRequest)
        
        XCTAssertTrue(result)
        
        let queryValueFake = NetworkConstraint.query(key: "api", value: "1234")
        result = queryValueFake.match(request: githubRequest)
        
        XCTAssertFalse(result)
    }
    
    func testRuleKindHederMatch() {
        let header = NetworkConstraint.header(key: "UserAgent")
        
        let githubRequest = self.makeGitHubURLRequest()
        
        var result = header.match(request: githubRequest)
        XCTAssertTrue(result)
        
        let unsecureRequest = self.makeUnsecureGitHubURLRequest()
        
        result = header.match(request: unsecureRequest)
        XCTAssertFalse(result)
        
        let headerValue = NetworkConstraint.header(key: "UserAgent", value: "Gluon")
        result = headerValue.match(request: githubRequest)
        
        XCTAssertTrue(result)
        
        let headerValueFake = NetworkConstraint.query(key: "UserAgent", value: "FakeClient")
        result = headerValueFake.match(request: githubRequest)
        
        XCTAssertFalse(result)
    }
}

extension RuleTests {
    func makeGitHubURLRequest() -> URLRequest {
        let githubURL = URL(string: "https://github.blog/category/engineering?api=asdf")!
        var githubRequest = URLRequest(url: githubURL)
        githubRequest.allHTTPHeaderFields = [
            "UserAgent" : "Gluon"
        ]
        
        return githubRequest
    }
    
    func makeUnsecureGitHubURLRequest() -> URLRequest {
        let githubURL = URL(string: "http://docs.github.com/es/actions?page=1")!
        var githubRequest = URLRequest(url: githubURL)
        githubRequest.allHTTPHeaderFields = [
            "Content-Type" : "application/json"
        ]
        
        return githubRequest
    }
}
