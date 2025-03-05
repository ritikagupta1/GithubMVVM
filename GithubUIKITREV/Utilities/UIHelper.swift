//
//  UIHelper.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 05/03/25.
//

import UIKit

enum UIHelper {
    static func createCollectionViewFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        let padding: CGFloat = 10.0
        let spacing: CGFloat = 8.0
        
        let totalWidth = view.bounds.width
        let availableWidth = totalWidth - (2*padding) - (2*spacing)
        let itemSize = availableWidth/3
        
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemSize, height: itemSize + 40.0)
        
        
        return flowLayout
    }
}
