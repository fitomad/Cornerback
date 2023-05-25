import Foundation

public struct Scheme: Constraint {
    public let requestScheme: String
    
    public init(value: String) {
        self.requestScheme = value
    }
    
    public func match(request: URLRequest) -> Bool {
        guard let components = components(from: request),
              let scheme = components.scheme
        else
        {
            return false
        }

        return scheme == self.requestScheme
    }
}

extension Scheme: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.requestScheme == rhs.requestScheme
    }
}

extension Scheme: CustomStringConvertible {
    public var description: String {
        return "Scheme: \"\(self.requestScheme)\""
    }
}

