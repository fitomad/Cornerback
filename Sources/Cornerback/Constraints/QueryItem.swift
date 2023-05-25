import Foundation

public struct QueryItem: Constraint {
    public let key: String
    public let value: String?
    
    public init(key: String, value: String? = nil) {
        self.key = key
        self.value = value
    }
    
    public func match(request: URLRequest) -> Bool {
        guard let components = components(from: request), let queryItems = components.queryItems else {
            return false
        }
        
        if let value {
            return queryItems.contains(URLQueryItem(name: self.key, value: value))
        }
        
        let keys = queryItems.map({ $0.name })
        return keys.contains(self.key)
    }
}

extension QueryItem: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return (lhs.key == rhs.key) && (lhs.value == rhs.value)
    }
}

extension QueryItem: CustomStringConvertible {
    public var description: String {
        return "Query item. Key: \"\(self.key)\" Value: \"\(self.value ?? "---")\""
    }
}
