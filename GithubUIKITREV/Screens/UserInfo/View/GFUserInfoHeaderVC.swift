//
//  GFUserInfoHeaderVC.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 08/03/25.
//

import UIKit

final class GFUserInfoHeaderVC: UIViewController {
    var viewModel: GFUserInfoHeaderViewModelProtocol
    
    let avatarImageView = GFImageView(frame: .zero)
    let loginID = GFTitleLabel(fontSize: 34, alignment: .left)
    let nameLabel = GFSecondaryLabel(fontSize: 18)
    let locationImageView = UIImageView()
    let locationLabel = GFSecondaryLabel(fontSize: 18)
    let bioLabel = GFBodyLabel(alignment: .left)
    
    init(viewModel: GFUserInfoHeaderViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        layoutUI()
        configure()
    }
    
    private func configure() {
        viewModel.downloadImage()
        loginID.text = viewModel.login
        nameLabel.text = viewModel.userName
        locationImageView.image = UIImage(systemName: SFSymbols.locationSymbol)
        locationImageView.tintColor = .secondaryLabel
        locationLabel.text = viewModel.userLocation
        bioLabel.text = viewModel.userBio
        bioLabel.numberOfLines = 3
    }
    
    private func layoutUI() {
        let padding: CGFloat = 20
        let textImagePadding: CGFloat = 12
        
        self.view.addSubViews(avatarImageView, loginID, nameLabel, locationImageView, locationLabel, bioLabel)
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: padding),
            avatarImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: padding),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        NSLayoutConstraint.activate([
            loginID.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            loginID.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            loginID.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -padding),
            loginID.heightAnchor.constraint(equalToConstant: 38)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: loginID.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: loginID.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        NSLayoutConstraint.activate([
            locationImageView.leadingAnchor.constraint(equalTo: loginID.leadingAnchor),
            locationImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            locationImageView.heightAnchor.constraint(equalToConstant: 20),
            locationImageView.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 5),
            locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            locationLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        NSLayoutConstraint.activate([
            bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: textImagePadding),
            bioLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: padding),
            bioLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -padding),
            bioLabel.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
}

extension GFUserInfoHeaderVC: GFUserInfoHeaderViewModelDelegate {
    func didUpdateImageData(_ imageData: Data) {
        DispatchQueue.main.async {
            self.avatarImageView.image = UIImage(data: imageData) ?? .avatarPlaceholder
        }
    }
}
