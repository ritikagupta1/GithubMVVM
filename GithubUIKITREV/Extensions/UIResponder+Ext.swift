//
//  UIResponder+Ext.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 05/03/25.
//

import UIKit

extension UIResponder {
    private struct Chain {
        static weak var responder: UIResponder?
    }

    /// Finds the current first responder
    /// - Returns: the current UIResponder if it exists
    static func currentFirst() -> UIResponder? {
        Chain.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.trap), to: nil, from: nil, for: nil)
        return Chain.responder
    }

    @objc private func trap() {
        Chain.responder = self
    }
}
