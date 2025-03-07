//
//  GFSecondaryLabel.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 08/03/25.
//

import UIKit

class GFSecondaryLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(fontSize: CGFloat) {
        self.init(frame: .zero)
        font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.textAlignment = .left
        self.textColor = .secondaryLabel
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.90
        
        self.lineBreakMode = .byTruncatingTail
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
