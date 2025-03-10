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
        layer.cornerRadius = 8
        self.clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        self.image = GFImageView.placeHolderImage
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
