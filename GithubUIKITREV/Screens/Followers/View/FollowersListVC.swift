//
//  FollowersListVC.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 05/03/25.
//

import UIKit
/*
 - Class can be final.
 - Collection view can be lazy and remove force unwrapping.
 - Remove force unwrapping of datasource - Code Smell.
 - Viewcontroller bloated with responsibilites of Search and CollectionView. - Code Smell.
 */

final class FollowersListVC: GFDataLoadingVC {
    var viewModel: FollowerListViewModelProtocol
    
    private var collectionViewManager: FollowerListCollectionViewManager?
    private var searchManager: FollowerListSearchManager?
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createCollectionViewFlowLayout(in: self.view))
        view.addSubview(collectionView)
        return collectionView
    }()
    
    init(viewModel: FollowerListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.title = viewModel.userName
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewController()
        self.configureCollectionViewManager()
        self.configureSearchManager()
        self.getFollowers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureViewController() {
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFavourites))
    }
    
    private func configureSearchManager() {
        searchManager = FollowerListSearchManager(
            collectionView: collectionView,
            parentViewController: self,
            viewModel: viewModel)
    }
    
    private func configureCollectionViewManager() {
        collectionViewManager = FollowerListCollectionViewManager(
            collectionView: collectionView,
            parentViewController: self,
            viewModel: viewModel)
    }
    
    func getFollowers() {
        self.viewModel.getFollowers()
    }
    
    @objc func addFavourites() {
        self.viewModel.addToFavourites()
    }
}

extension FollowersListVC: FollowerListViewModelDelegate {
    func didChangeLoadingState(isLoading: Bool) {
        DispatchQueue.main.async {
            isLoading ? self.showLoadingView() : self.dismissLoadingView()
        }
    }
    
    func didFinishAddingToFavourites(_ result: AddFavouriteResult) {
        DispatchQueue.main.async {
            switch result {
            case .success:
                self.presentGFAlertViewController(
                    title: Constants.successTitle,
                    message: Constants.favouriteUserSuccessMessage,
                    buttonTitle: Constants.ok)
            case .failure(let errorMessage):
                self.presentGFAlertViewController(
                    title: Constants.somethingWentWrongTitle,
                    message: errorMessage,
                    buttonTitle: Constants.ok)
            }
        }
    }
    
    func didUpdateFollowers(_ followers: [FollowerViewModel], isSearchActive: Bool) {
        DispatchQueue.main.async {
            self.collectionViewManager?.applySnapshot(with: followers)
            if !isSearchActive && followers.isEmpty {
                self.showEmptyStateView(with: Constants.emptyStateMessage)
            }
        }
    }
    
    func didFailToFetchFollowers(_ message: String) {
        DispatchQueue.main.async {
            self.presentGFAlertViewController(
                title: Constants.badStuffHappenedTitle,
                message: message,
                buttonTitle: Constants.ok)
        }
    }
}

extension FollowersListVC: UserInfoVCDelegate {
    func didTapGetFollowers(username: String) {
        self.title = username
        self.viewModel.searchForNewFollower(with: username)
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .bottom, animated: true)
    }
}
