//
//  File.swift
//  
//
//  Created by Adolfo Vera Blasco on 17/5/23.
//

import Foundation

final class WideReceiver: URLProtocol {
    override init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
        super.init(request: request, cachedResponse: cachedResponse, client: client)
        print("\(#function)")
    }
    
    override static func canInit(with task: URLSessionTask) -> Bool {
        Cornerback.shared.checkRulesFor(request: task.currentRequest!)
        print("\(#function)")
        return false
    }
}
