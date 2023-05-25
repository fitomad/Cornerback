//
//  File.swift
//  
//
//  Created by Adolfo Vera Blasco on 17/5/23.
//

import Foundation

public final class WideReceiver: URLProtocol {
    enum Keys {
        static let tag = "WideReceiver.Keys.tag"
    }
    
    private var dataTask: URLSessionDataTask?
    
    override init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
        super.init(request: request, cachedResponse: cachedResponse, client: client)
    }

    override public static func canInit(with request: URLRequest) -> Bool {
        if URLProtocol.property(forKey: WideReceiver.Keys.tag, in: request) as? Bool == true {
            return false
        }
        
        return true
    }
    
    override public static func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override public func startLoading() {
        guard let mutableRequest = (self.request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {
            return
        }
        
        URLProtocol.setProperty(true, forKey: WideReceiver.Keys.tag, in: mutableRequest)
        
        var modifiedRequest = mutableRequest as URLRequest
        Cornerback.shared.applyRulesFor(request: &modifiedRequest)
        
        dataTask = URLSession.shared.dataTask(with: modifiedRequest, completionHandler: { data, response, error in
            if let data = data, let response = response {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                self.client?.urlProtocol(self, didLoad: data)
            } else if let error = error {
                self.client?.urlProtocol(self, didFailWithError: error)
            }
            self.client?.urlProtocolDidFinishLoading(self)
        })
        
        dataTask?.resume()
    }
    
    override public func stopLoading() {
        self.dataTask?.cancel()
    }
}
