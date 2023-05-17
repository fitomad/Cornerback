import XCTest
@testable import Cornerback

final class RuleTests: XCTestCase {
    func testRuleKindScheme() {
        let schemeOne = Rule.Kind.scheme(value: "http")
        let schemeTwo = Rule.Kind.scheme(value: "http")
        let schemeSecure = Rule.Kind.scheme(value: "https")
        
        XCTAssertEqual(schemeOne, schemeTwo)
        XCTAssertNotEqual(schemeOne, schemeSecure)
    }
    
    func testRuleKindDomain() {
        let domainOne = Rule.Kind.domain(name: "github.com")
        let domainTwo = Rule.Kind.domain(name: "github.com")
        let domainFake = Rule.Kind.domain(name: "falsegithub.com")
        
        XCTAssertEqual(domainOne, domainTwo)
        XCTAssertNotEqual(domainOne, domainFake)
    }
    
    func testRuleKindResource() {
        let resourceOne = Rule.Kind.resource(name: "index.html")
        let resourceTwo = Rule.Kind.resource(name: "index.html")
        let resourceAbout = Rule.Kind.resource(name: "about.html")
        
        XCTAssertEqual(resourceOne, resourceTwo)
        XCTAssertNotEqual(resourceOne, resourceAbout)
    }
    
    func testRuleKindQuery() {
        let queryKeyOne = Rule.Kind.query(key: "api_key")
        let queryKeyTwo = Rule.Kind.query(key: "api_key")
        let queryKeyPage = Rule.Kind.query(key: "page")
        
        XCTAssertEqual(queryKeyOne, queryKeyTwo)
        XCTAssertNotEqual(queryKeyOne, queryKeyPage)
        
        let queryKeyValueOne = Rule.Kind.query(key: "api_key", value: "asdf")
        let queryKeyValueTwo = Rule.Kind.query(key: "api_key", value: "asdf")
        let queryKeyValuePageOne = Rule.Kind.query(key: "page", value: "1")
        let queryKeyValuePageTwo = Rule.Kind.query(key: "page", value: "2")
        
        XCTAssertEqual(queryKeyValueOne, queryKeyValueTwo)
        XCTAssertNotEqual(queryKeyValueOne, queryKeyValuePageOne)
        XCTAssertNotEqual(queryKeyValuePageOne, queryKeyValuePageTwo)
        
        XCTAssertNotEqual(queryKeyOne, queryKeyValueOne)
    }
    
    func testRuleKindHeader() {
        let headerKeyOne = Rule.Kind.header(key: "Content-Type")
        let headerKeyTwo = Rule.Kind.header(key: "Content-Type")
        let headerKeyPage = Rule.Kind.header(key: "User-Agent")
        
        XCTAssertEqual(headerKeyOne, headerKeyTwo)
        XCTAssertNotEqual(headerKeyOne, headerKeyPage)
        
        let headerKeyValueOne = Rule.Kind.header(key: "Content-Type", value: "application/json")
        let headerKeyValueTwo = Rule.Kind.header(key: "Content-Type", value: "application/json")
        let headerKeyValuePageOne = Rule.Kind.header(key: "User-Agent", value: "Gluon")
        let headerKeyValuePageTwo = Rule.Kind.header(key: "User-Agent", value: "OneApp")
        
        XCTAssertEqual(headerKeyValueOne, headerKeyValueTwo)
        XCTAssertNotEqual(headerKeyValueOne, headerKeyValuePageOne)
        XCTAssertNotEqual(headerKeyValuePageOne, headerKeyValuePageTwo)
        
        XCTAssertNotEqual(headerKeyOne, headerKeyValueOne)
    }
    
    func testRuleKindSchemeMatch() {
        let scheme = Rule.Kind.scheme(value: "https")
        
        let githubRequest = self.makeGitHubURLRequest()
        
        var result = scheme.match(request: githubRequest)
        XCTAssertTrue(result)
        
        let unsecureRequest = self.makeUnsecureGitHubURLRequest()
        
        result = scheme.match(request: unsecureRequest)
        XCTAssertFalse(result)
    }
    
    func testRuleKindDomainMatch() {
        let domain = Rule.Kind.domain(name: "github.blog")
        
        let githubRequest = self.makeGitHubURLRequest()
        
        var result = domain.match(request: githubRequest)
        XCTAssertTrue(result)
        
        let unsecureRequest = self.makeUnsecureGitHubURLRequest()
        
        result = domain.match(request: unsecureRequest)
        XCTAssertFalse(result)
    }
    
    func testRuleKindResourceMath() {
        let resource = Rule.Kind.resource(name: "/category/engineering")
        
        let githubRequest = self.makeGitHubURLRequest()
        
        var result = resource.match(request: githubRequest)
        XCTAssertTrue(result)
        
        let unsecureRequest = self.makeUnsecureGitHubURLRequest()
        
        result = resource.match(request: unsecureRequest)
        XCTAssertFalse(result)
    }
    
    func testRuleKindQueryMatch() {
        let query = Rule.Kind.query(key: "api")
        
        let githubRequest = self.makeGitHubURLRequest()
        
        var result = query.match(request: githubRequest)
        XCTAssertTrue(result)
        
        let unsecureRequest = self.makeUnsecureGitHubURLRequest()
        
        result = query.match(request: unsecureRequest)
        XCTAssertFalse(result)
        
        let queryValue = Rule.Kind.query(key: "api", value: "asdf")
        result = queryValue.match(request: githubRequest)
        
        XCTAssertTrue(result)
        
        let queryValueFake = Rule.Kind.query(key: "api", value: "1234")
        result = queryValueFake.match(request: githubRequest)
        
        XCTAssertFalse(result)
    }
    
    func testRuleKindHederMatch() {
        let header = Rule.Kind.header(key: "UserAgent")
        
        let githubRequest = self.makeGitHubURLRequest()
        
        var result = header.match(request: githubRequest)
        XCTAssertTrue(result)
        
        let unsecureRequest = self.makeUnsecureGitHubURLRequest()
        
        result = header.match(request: unsecureRequest)
        XCTAssertFalse(result)
        
        let headerValue = Rule.Kind.header(key: "UserAgent", value: "Gluon")
        result = headerValue.match(request: githubRequest)
        
        XCTAssertTrue(result)
        
        let headerValueFake = Rule.Kind.query(key: "UserAgent", value: "FakeClient")
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
