//
//  File.swift
//  
//
//  Created by Adolfo Vera Blasco on 19/5/23.
//

import Foundation
#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13, macOS 10.15, *)
public typealias CornerbackModifierClosure = (Cornerback) -> Void

@available(iOS 13, macOS 10.15, *)
extension View {
    public func networkRules(closure: CornerbackModifierClosure) -> some View {
        let modifier = CornerbackModifier(closure: closure)
        
        return ModifiedContent(content: self, modifier: modifier)
    }
}


@available(iOS 13, macOS 10.15, *)
struct CornerbackModifier: ViewModifier {
    init(closure: CornerbackModifierClosure) {
        closure(Cornerback.shared)
    }
    
    public func body(content: Content) -> some View {
        content
    }
}
