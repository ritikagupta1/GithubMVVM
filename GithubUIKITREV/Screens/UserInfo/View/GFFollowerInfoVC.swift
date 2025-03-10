//
//  GFFollowerInfoVC.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 08/03/25.
//

import UIKit
protocol GFFollowersInfoVCDelegate: AnyObject {
    func didTapGetFollowers(user: User)
}

final class GFFollowersInfoVC: GFItemInfoVC {
    weak var delegate: GFFollowersInfoVCDelegate!
    
    init(user: User, delegate: GFFollowersInfoVCDelegate) {
        self.delegate = delegate
        super.init(user: user)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        button.set(backgroundColor: .systemGreen, title: "Get Followers")
        itemInfoViewOne.set(itemInfoType: .followers, with: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, with: user.following)
    }
    
    override func buttonActionTapped() {
        delegate?.didTapGetFollowers(user: self.user)
    }
}
