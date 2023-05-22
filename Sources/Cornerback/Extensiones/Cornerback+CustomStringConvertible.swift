//
//  File.swift
//  
//
//  Created by Adolfo Vera Blasco on 22/5/23.
//

import Foundation

extension Cornerback: CustomStringConvertible {
    public var description: String {
        let rulesDescription = self.rules.map({ String(describing: $0) })
                                         .joined(separator: "\n")
        
        let cornerbackDescription = """
        Rules (\(self.rules.count))
        \(rulesDescription)
        """
        
        return cornerbackDescription
    }
}
