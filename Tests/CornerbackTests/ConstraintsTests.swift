import XCTest
@testable import Cornerback

final class ConstraintsTests: XCTestCase {
    func testRuleKindScheme() {
        let schemeOne = Scheme(value: "http")
        let schemeTwo = Scheme(value: "http")
        let schemeSecure = Scheme(value: "https")
        
        XCTAssertEqual(schemeOne, schemeTwo)
        XCTAssertNotEqual(schemeOne, schemeSecure)
    }
    
    func testRuleKindDomain() {
        let domainOne = Domain(named: "github.com")
        let domainTwo = Domain(named: "github.com")
        let domainFake = Domain(named: "falsegithub.com")
        
        XCTAssertEqual(domainOne, domainTwo)
        XCTAssertNotEqual(domainOne, domainFake)
    }
    
    func testRuleKindResource() {
        let resourceOne = Resource(path: "index.html")
        let resourceTwo = Resource(path: "index.html")
        let resourceAbout = Resource(path: "about.html")
        
        XCTAssertEqual(resourceOne, resourceTwo)
        XCTAssertNotEqual(resourceOne, resourceAbout)
    }
    
    func testRuleKindQuery() {
        let queryKeyOne = QueryItem(key: "api_key")
        let queryKeyTwo = QueryItem(key: "api_key")
        let queryKeyPage = QueryItem(key: "page")
        
        XCTAssertEqual(queryKeyOne, queryKeyTwo)
        XCTAssertNotEqual(queryKeyOne, queryKeyPage)
        
        let queryKeyValueOne = QueryItem(key: "api_key", value: "asdf")
        let queryKeyValueTwo = QueryItem(key: "api_key", value: "asdf")
        let queryKeyValuePageOne = QueryItem(key: "page", value: "1")
        let queryKeyValuePageTwo = QueryItem(key: "page", value: "2")
        
        XCTAssertEqual(queryKeyValueOne, queryKeyValueTwo)
        XCTAssertNotEqual(queryKeyValueOne, queryKeyValuePageOne)
        XCTAssertNotEqual(queryKeyValuePageOne, queryKeyValuePageTwo)
        
        XCTAssertNotEqual(queryKeyOne, queryKeyValueOne)
    }
    
    func testRuleKindHeader() {
        let headerKeyOne = Header(key: "Content-Type")
        let headerKeyTwo = Header(key: "Content-Type")
        let headerKeyPage = Header(key: "User-Agent")
        
        XCTAssertEqual(headerKeyOne, headerKeyTwo)
        XCTAssertNotEqual(headerKeyOne, headerKeyPage)
        
        let headerKeyValueOne = Header(key: "Content-Type", value: "application/json")
        let headerKeyValueTwo = Header(key: "Content-Type", value: "application/json")
        let headerKeyValuePageOne = Header(key: "User-Agent", value: "Gluon")
        let headerKeyValuePageTwo = Header(key: "User-Agent", value: "OneApp")
        
        XCTAssertEqual(headerKeyValueOne, headerKeyValueTwo)
        XCTAssertNotEqual(headerKeyValueOne, headerKeyValuePageOne)
        XCTAssertNotEqual(headerKeyValuePageOne, headerKeyValuePageTwo)
        
        XCTAssertNotEqual(headerKeyOne, headerKeyValueOne)
    }
    
    func testRuleKindSchemeMatch() {
        let scheme = Scheme(value: "https")
        
        let githubRequest = self.makeGitHubURLRequest()
        
        var result = scheme.match(request: githubRequest)
        XCTAssertTrue(result)
        
        let unsecureRequest = self.makeUnsecureGitHubURLRequest()
        
        result = scheme.match(request: unsecureRequest)
        XCTAssertFalse(result)
    }
    
    func testRuleKindDomainMatch() {
        let domain = Domain(named: "github.blog")
        
        let githubRequest = self.makeGitHubURLRequest()
        
        var result = domain.match(request: githubRequest)
        XCTAssertTrue(result)
        
        let unsecureRequest = self.makeUnsecureGitHubURLRequest()
        
        result = domain.match(request: unsecureRequest)
        XCTAssertFalse(result)
    }
    
    func testRuleKindResourceMath() {
        let resource = Resource(path: "/category/engineering")
        
        let githubRequest = self.makeGitHubURLRequest()
        
        var result = resource.match(request: githubRequest)
        XCTAssertTrue(result)
        
        let unsecureRequest = self.makeUnsecureGitHubURLRequest()
        
        result = resource.match(request: unsecureRequest)
        XCTAssertFalse(result)
    }
    
    func testRuleKindQueryMatch() {
        let query = QueryItem(key: "api")
        
        let githubRequest = self.makeGitHubURLRequest()
        
        var result = query.match(request: githubRequest)
        XCTAssertTrue(result)
        
        let unsecureRequest = self.makeUnsecureGitHubURLRequest()
        
        result = query.match(request: unsecureRequest)
        XCTAssertFalse(result)
        
        let queryValue = QueryItem(key: "api", value: "asdf")
        result = queryValue.match(request: githubRequest)
        
        XCTAssertTrue(result)
        
        let queryValueFake = QueryItem(key: "api", value: "1234")
        result = queryValueFake.match(request: githubRequest)
        
        XCTAssertFalse(result)
    }
    
    func testRuleKindHederMatch() {
        let header = Header(key: "UserAgent")
        
        let githubRequest = self.makeGitHubURLRequest()
        
        var result = header.match(request: githubRequest)
        XCTAssertTrue(result)
        
        let unsecureRequest = self.makeUnsecureGitHubURLRequest()
        
        result = header.match(request: unsecureRequest)
        XCTAssertFalse(result)
        
        let headerValue = Header(key: "UserAgent", value: "Gluon")
        result = headerValue.match(request: githubRequest)
        
        XCTAssertTrue(result)
        
        let headerValueFake = Header(key: "UserAgent", value: "FakeClient")
        result = headerValueFake.match(request: githubRequest)
        
        XCTAssertFalse(result)
    }
    
    func testConstrain() {
        let constrainsts: [any Constraint] = [
            Scheme(value: "https"),
            Scheme(value: "https"),
            Scheme(value: "http")
        ]
        
        XCTAssertTrue(constrainsts[0].isEqualsTo(constrainsts[1]))
        XCTAssertFalse(constrainsts[0].isEqualsTo(constrainsts[2]))
    }
}

extension ConstraintsTests {
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
