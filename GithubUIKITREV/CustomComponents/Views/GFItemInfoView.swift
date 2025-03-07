//
//  GFItemInfoView.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 08/03/25.
//

import UIKit
enum ItemInfoType {
    case repos, gists, followers, following
}

class GFItemInfoView: UIView {
    var imageView = UIImageView()
    var titleLabel = GFTitleLabel(fontSize: 14, alignment: .left)
    var countLabel = GFTitleLabel(fontSize: 14, alignment: .center)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.addSubViews(titleLabel, imageView, countLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode  = .scaleAspectFill
        imageView.tintColor = .label
        NSLayoutConstraint.activate([
        
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 20),
        
            titleLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            countLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
    }
    
    func set(itemInfoType: ItemInfoType,with count: Int) {
        switch itemInfoType {
        case .repos:
            self.imageView.image = UIImage(systemName: SFSymbols.repos)
            self.titleLabel.text = "Public Repos"
        case .gists:
            self.imageView.image = UIImage(systemName: SFSymbols.gists)
            self.titleLabel.text = "Public Gists"
        case .followers:
            self.imageView.image = UIImage(systemName: SFSymbols.followers)
            self.titleLabel.text = "Followers"
        case .following:
            self.imageView.image = UIImage(systemName: SFSymbols.following)
            self.titleLabel.text = "Following"
        }
        
        self.countLabel.text = String(count)
    }
}
