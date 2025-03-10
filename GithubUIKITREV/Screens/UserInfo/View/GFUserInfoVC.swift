//
//  GFUserInfoVC.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 08/03/25.
//

import UIKit
import SafariServices

protocol UserInfoVCDelegate: AnyObject {
    func didTapGetFollowers(username: String)
}

final class GFUserInfoVC: GFDataLoadingVC {
    let scrollView = UIScrollView()
    let contentView = UIView()
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GFBodyLabel(alignment: .center)
    
    weak var delegate: UserInfoVCDelegate?
    
    var viewModel: GFUserInfoViewModelProtocol
    
    init(viewModel: GFUserInfoViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        layoutUI()
        getUserInfo()
    }
    
    func configureViewController() {
        self.view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true)
    }
    
    private func layoutUI() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
        
        
        let containerViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        containerViews.forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: padding),
                $0.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -padding)
            ])
        }
 
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
    
    func getUserInfo() {
        self.viewModel.getUserInfo()
    }
    
    func configureUIElements(with user: User) {
        let viewModel = GFUserInfoHeaderViewModel(imageLoader: ImageLoader(), user: user)
        self.add(childVC: GFUserInfoHeaderVC(viewModel: viewModel), to: self.headerView)
        self.add(childVC: GFRepoItemVC(user: user, delegate: self), to: self.itemViewOne)
        self.add(childVC: GFFollowersInfoVC(user: user, delegate: self), to: self.itemViewTwo)
        self.dateLabel.text = "\(Constants.githubSince) \(user.createdAt.convertToDisplayFormat())"
    }
    
    private func add(childVC: UIViewController, to containerView: UIView) {
        self.addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
}

extension GFUserInfoVC: GFRepoItemVCDelegate {
    func didTapGithubProfile(user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            self.presentGFAlertViewController(
                title: Constants.invalidUrlTitle,
                message: Constants.invalidUserNameMessage,
                buttonTitle: Constants.ok)
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
}

extension GFUserInfoVC: GFFollowersInfoVCDelegate {
    func didTapGetFollowers(user: User) {
        delegate?.didTapGetFollowers(username: user.login)
        self.dismiss(animated: true)
    }
}

extension GFUserInfoVC: GFUserInfoViewModelDelegate {
    func didChangeLoadingState(isLoading: Bool) {
        DispatchQueue.main.async {
            isLoading ? self.showLoadingView() : self.dismissLoadingView()
        }
    }
    
    func didReceiveUserDetails(_ user: User) {
        DispatchQueue.main.async {
            self.configureUIElements(with: user)
        }
    }
    
    func didReceiveError(_ errorMessage: String) {
        DispatchQueue.main.async {
            self.presentGFAlertViewController(
                title: Constants.somethingWentWrongTitle,
                message: errorMessage,
                buttonTitle: Constants.ok)
        }
    }
}

