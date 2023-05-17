import Foundation

public typealias RuleID = String

public final class Rule {
    public enum Kind {
        case scheme(value: String)
        case domain(name: String, allowingSubdomains: Bool = true)
        case resource(name: String)
        case query(key: String, value: String? = nil)
        case header(key: String, value: String? = nil)
    }
    
    public private(set) var ruleID: RuleID
    public internal(set) var kinds = [Rule.Kind]()
    public internal(set) var isActive = true
    public internal(set) var associatedAction: CornerbackAction?
    
    public convenience init() {
        let uuidString = UUID().uuidString
        self.init(withRuleID: uuidString)
    }
    
    public init(withRuleID ruleID: RuleID) {
        self.ruleID = ruleID
    }
}

extension Rule.Kind {
    func match(request: URLRequest) -> Bool {
        switch self {
            case .scheme(let value):
                return scheme(value, match: request)
            case .domain(let name, let includeSubdomains):
                return domain(name, match: request)
            case .resource(let name):
                return resource(name, match: request)
            case .query(let key, let value):
                return queryItem(key: key, value: value, match: request)
            case .header(let key, let value):
                return header(key: key, value: value, match: request)
        }
    }
    
    private func components(from request: URLRequest) -> URLComponents? {
        guard let baseURL = request.url,
              let components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        else
        {
            return nil
        }
        
        return components
    }
    
    private func scheme(_ value: String, match request: URLRequest) -> Bool {
        guard let components = components(from: request),
              let scheme = components.scheme
        else
        {
            return false
        }

        return scheme == value
    }
    
    private func domain(_ value: String, match request: URLRequest) -> Bool {
        guard let components = components(from: request),
              let domain = components.host
        else
        {
            return false
        }

        return domain == value
    }
    
    private func resource(_ value: String, match request: URLRequest) -> Bool {
        guard let components = components(from: request) else {
            return false
        }

        return components.path == value
    }
    
    private func queryItem(key: String, value: String?, match request: URLRequest) -> Bool {
        guard let components = components(from: request), let queryItems = components.queryItems else {
            return false
        }
        
        if let value {
            return queryItems.contains(URLQueryItem(name: key, value: value))
        }
        
        let keys = queryItems.map({ $0.name })
        return keys.contains(key)
    }
    
    private func header(key: String, value: String?, match request: URLRequest) -> Bool {
        guard let headers = request.allHTTPHeaderFields else {
            return false
        }
        
        if let headerValue = headers[key] {
            if let value {
                return value == headerValue
            }
            
            return true
        }
        
        return false
    }
}
