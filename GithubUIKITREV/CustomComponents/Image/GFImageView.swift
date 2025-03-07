//
//  GFImageView.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 05/03/25.
//

import UIKit

class GFImageView: UIImageView {
    static let placeHolderImage: UIImage = .avatarPlaceholder
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = frame.size.width / 2
        clipsToBounds = true
        layer.borderColor = UIColor.label.cgColor
        layer.borderWidth = 1
        translatesAutoresizingMaskIntoConstraints = false
        self.image = GFImageView.placeHolderImage
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.width / 2
    }
}
