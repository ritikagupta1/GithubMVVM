//
//  FollowersListVC.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 05/03/25.
//

import UIKit

enum Section {
    case main
}

class FollowersListVC: GFDataLoadingVC {
    var viewModel: FollowerListViewModelProtocol
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Section,Follower>!
    
    
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
        self.configureSearchController()
        self.setUpCollectionView()
        self.setUpDataSource()
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
    
    private func setUpCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createCollectionViewFlowLayout(in: self.view))
        collectionView.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        
        collectionView.delegate = self
    
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseIdentifier)
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = Constants.userName
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    private func getFollowers() {
        self.showLoadingView()
        self.viewModel.getFollowers()
    }
    
    @objc func addFavourites() {
        self.viewModel.addToFavourites()
    }
}

// MARK: COLLECTIONVIEW DATASOURCE
extension FollowersListVC {
    private func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseIdentifier, for: indexPath) as? FollowerCell
            let viewModel = FollowerCellViewModel(
                networkManager: self.viewModel.networkManager,
                follower: follower)
            cell?.setup(with: viewModel)
            return cell ?? UICollectionViewCell()
        })
    }
    
    private func applySnapshot(with followers: [Follower]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section,Follower>()
        snapShot.appendSections([Section.main])
        snapShot.appendItems(followers)
        dataSource.apply(snapShot, animatingDifferences: true)
    }
    
}

// MARK: SEARCH RESULTS FILTERING
extension FollowersListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            viewModel.resetSearch()
            return
        }
        
        viewModel.filterFollowers(with: searchText)
    }
}

// MARK: COLLECTIONVIEW DELEGATE
extension FollowersListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offSetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offSetY > contentHeight - height && viewModel.canFetchMoreFollowers() {
            self.getFollowers()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedFollower = self.viewModel.getSelectedFollower(index: indexPath.row)
//        let userInfoVC = ViewControllerFactory.makeUserInfoVC(userName: selectedFollower.login)
//        userInfoVC.delegate = self
//        self.present(UINavigationController(rootViewController: userInfoVC), animated: true)
    }
}

extension FollowersListVC: FollowerListViewModelDelegate {
    func didFinishAddingToFavourites(_ result: AddFavouriteResult) {
        DispatchQueue.main.async {
            switch result {
            case .success:
                self.presentGFAlertViewController(
                    title: "Success",
                    message: "You have successfully favourited this user 🎊",
                    buttonTitle: "Ok")
            case .failure(let errorMessage):
                self.presentGFAlertViewController(
                    title: "Something went wrong",
                    message: errorMessage,
                    buttonTitle: "Ok")
            }
        }
    }
    
    func didUpdateFollowers(_ followers: [Follower], isSearchActive: Bool) {
        DispatchQueue.main.async {
            self.dismissLoadingView()
            if !isSearchActive && followers.isEmpty {
                self.showEmptyStateView(with: Constants.emptyStateMessage)
            } else {
                self.applySnapshot(with: followers)
            }
        }
    }
    
    func didFailToFetchFollowers(_ message: String) {
        DispatchQueue.main.async {
            self.dismissLoadingView()
            self.presentGFAlertViewController(
                title: "Bad Stuff happened",
                message: message,
                buttonTitle: "Ok")
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
