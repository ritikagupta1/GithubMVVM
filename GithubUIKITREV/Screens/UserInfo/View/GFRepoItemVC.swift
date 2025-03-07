//
//  GFRepoItemVC.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 08/03/25.
//

import UIKit
protocol GFRepoItemVCDelegate: AnyObject {
    func didTapGithubProfile(user: User)
}


class GFRepoItemVC: GFItemInfoVC {
    weak var delegate: GFRepoItemVCDelegate!
    
    init(user: User, delegate: GFRepoItemVCDelegate) {
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
        button.set(backgroundColor: .systemPurple, title: "Github Profile")
        itemInfoViewOne.set(itemInfoType: .repos, with: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, with: user.publicGists)
    }
    
    override func buttonActionTapped() {
        delegate?.didTapGithubProfile(user: self.user)
    }
}
