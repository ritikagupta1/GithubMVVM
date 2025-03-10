//
//  FollowerCell.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 05/03/25.
//

import UIKit

final class FollowerCell: UICollectionViewCell {
    static let reuseIdentifier = "followerCell"
    
    lazy var imageView: GFImageView = {
        GFImageView(frame: .zero)
    }()
    
    lazy var titleLabel: GFTitleLabel = {
        GFTitleLabel(fontSize: 16, alignment: .center)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.imageView.image = GFImageView.placeHolderImage
        self.titleLabel.text = nil
        super.prepareForReuse()
    }
    
    func setup(with viewModel: FollowerViewModelProtocol) {
        viewModel.delegate = self
        self.titleLabel.text = viewModel.follower.login
        self.imageView.image = .avatarPlaceholder
        viewModel.downloadImage()
    }
    
    private func configure() {
        self.contentView.addSubViews(imageView, titleLabel)
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}

extension FollowerCell: FollowerCellViewModelDelegate {
    func didUpdateImageData(_ imageData: Data, for identifier: String) {
        DispatchQueue.main.async {
            if self.titleLabel.text == identifier {
                self.imageView.image = UIImage(data: imageData) ?? .avatarPlaceholder
            }
        }
    }
}
