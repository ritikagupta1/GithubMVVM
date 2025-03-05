//
//  UIView+Ext.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 05/03/25.
//

import UIKit

extension UIView {
    func addSubViews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
}
