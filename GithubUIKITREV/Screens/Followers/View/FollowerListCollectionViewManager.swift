//
//  FollowerListDataSourceManager.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 10/03/25.
//

import UIKit

enum Section {
    case main
}

final class FollowerListCollectionViewManager: NSObject {
    let collectionView: UICollectionView
    let parentViewController: FollowersListVC
    let viewModel: FollowerListViewModelProtocol
    
    var dataSource: UICollectionViewDiffableDataSource<Section,FollowerViewModel>?
    
    init(collectionView: UICollectionView, parentViewController: FollowersListVC, viewModel: FollowerListViewModelProtocol) {
        self.collectionView = collectionView
        self.parentViewController = parentViewController
        self.viewModel = viewModel
        super.init()
        
        self.configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseIdentifier)
        collectionView.delegate = self
        setUpDataSource()
    }
    
    private func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: self.collectionView, cellProvider: {collectionView, indexPath, followerViewModel in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseIdentifier, for: indexPath) as? FollowerCell
            cell?.setup(with: followerViewModel)
            return cell ?? UICollectionViewCell()
        })
    }
    
   func applySnapshot(with followers: [FollowerViewModel]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section,FollowerViewModel>()
        snapShot.appendSections([Section.main])
        snapShot.appendItems(followers)
        dataSource?.apply(snapShot, animatingDifferences: true)
    }
}

extension FollowerListCollectionViewManager: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offSetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offSetY > contentHeight - height && viewModel.canFetchMoreFollowers() {
            self.parentViewController.getFollowers()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedFollowerLoginID = self.viewModel.getSelectedFollower(index: indexPath.row)
        let viewModel = GFUserInfoViewModel(userName: selectedFollowerLoginID, networkManager: NetworkManager())
        let userInfoVC = GFUserInfoVC(viewModel: viewModel)
        userInfoVC.delegate = parentViewController
        self.parentViewController.present(UINavigationController(rootViewController: userInfoVC), animated: true)
    }
}
