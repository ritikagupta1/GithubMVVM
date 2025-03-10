//
//  FollowerListDataSourceProvider.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 10/03/25.
//

import UIKit

final class FollowerListDataSourceProvider: NSObject {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, FollowerViewModel>
    
    private weak var collectionView: UICollectionView?
    private var dataSource: DataSource?
    private weak var viewController: UIViewController?
    
    init(collectionView: UICollectionView, viewController: UIViewController) {
        super.init()
        self.collectionView = collectionView
        self.viewController = viewController
        self.setupCollectionView()
        self.setupDataSource()
    }
    
    private func setupCollectionView() {
        guard let view = viewController?.view else { return }
        collectionView?.backgroundColor = .systemBackground
//        collectionView?.delegate = self
        collectionView?.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseIdentifier)
    }
    
    private func setupDataSource() {
        guard let collectionView = collectionView else { return }
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, followerViewModel in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseIdentifier, for: indexPath) as? FollowerCell
            cell?.setup(with: followerViewModel)
            return cell ?? UICollectionViewCell()
        })
    }
    
    func applySnapshot(with followers: [FollowerViewModel]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, FollowerViewModel>()
        snapShot.appendSections([Section.main])
        snapShot.appendItems(followers)
        dataSource?.apply(snapShot, animatingDifferences: true)
    }
}
