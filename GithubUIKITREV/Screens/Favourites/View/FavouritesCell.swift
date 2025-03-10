//
//  FavouritesCell.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 07/03/25.
//

import UIKit

final class FavouriteCell: UITableViewCell {
    static let reuseID = "favouriteCell"
    
    lazy var avatarImageView : GFImageView = {
        GFImageView(frame: .zero)
    }()
    
    lazy var titleLabel: GFTitleLabel = {
        GFTitleLabel(fontSize: 26, alignment: .left)
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.avatarImageView.image = GFImageView.placeHolderImage
        self.titleLabel.text = nil
        super.prepareForReuse()
    }
    
    private func configure() {
        self.contentView.addSubViews(avatarImageView, titleLabel)
        accessoryType = .disclosureIndicator
        
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: padding),
            avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func set(with viewModel: FavouritesCellViewModelProtocol) {
        self.titleLabel.text = viewModel.favourite.login
        viewModel.delegate = self
        viewModel.downloadImage()
    }
}

extension FavouriteCell: FavouritesCellViewModelDelegate {
    func didUpdateImageData(_ imageData: Data, for identifier: String) {
        DispatchQueue.main.async {
            if self.titleLabel.text == identifier {
                self.avatarImageView.image = UIImage(data: imageData) ?? .avatarPlaceholder
            }
        }
    }
}
