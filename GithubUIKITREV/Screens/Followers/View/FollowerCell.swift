//
//  FollowerCell.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 05/03/25.
//

import UIKit

class FollowerCell: UICollectionViewCell {
    private var viewModel: FollowerCellViewModelProtocol?
    
    static let reuseIdentifier = "followerCell"
    let imageView =  GFImageView(frame: .zero)
    let titleLabel = GFTitleLabel(fontSize: 16, alignment: .center)
    
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
    
    func setup(with viewModel: FollowerCellViewModelProtocol) {
        self.viewModel = viewModel
        self.viewModel?.delegate = self
        self.titleLabel.text = viewModel.follower.login
        
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
    func didUpdateImageData(_ imageData: Data) {
        DispatchQueue.main.async {
            self.imageView.image = UIImage(data: imageData) ?? .avatarPlaceholder
        }
    }
}
