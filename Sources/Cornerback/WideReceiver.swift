//
//  File.swift
//  
//
//  Created by Adolfo Vera Blasco on 17/5/23.
//

import Foundation

final class WideReceiver: URLProtocol {
    enum Keys: CustomStringConvertible {
        case tag
        
        var description: String {
            let base = "WideReceiver.Keys"
            
            switch self {
                case .tag:
                    return "\(base).tag"
            }
        }
    }
    
    override init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
        super.init(request: request, cachedResponse: cachedResponse, client: client)
        print("\(#function) init")
    }
    /*
    override static func canInit(with task: URLSessionTask) -> Bool {
        Cornerback.shared.checkRulesFor(request: task.currentRequest!)
        print("\(#function)")
        return false
    }
    */
    override static func canInit(with request: URLRequest) -> Bool {
        guard URLProtocol.property(forKey: WideReceiver.Keys.tag.description, in: request) != nil else {
            return false
        }
        
        Cornerback.shared.checkRulesFor(request: request)
        print("\(#function) request")
        return true
    }
    
    override func startLoading() {
        guard let mutableRequest = self.request as? NSMutableURLRequest else {
            return
        }
        
        URLProtocol.setProperty(true, forKey: WideReceiver.Keys.tag.description, in: mutableRequest)
    }
}
