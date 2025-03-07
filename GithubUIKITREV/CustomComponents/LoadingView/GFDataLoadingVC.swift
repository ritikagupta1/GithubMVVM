//
//  GFDataLoadingVC.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 06/03/25.
//

import UIKit

class GFDataLoadingVC: UIViewController {
    var containerView: UIView?
    var loadingTasksCount = 0
    
    func showLoadingView() {
        if containerView != nil {
            loadingTasksCount += 1
            return
        }
        
        containerView = UIView(frame: view.bounds)
        guard let containerView = containerView else { return }
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0.0
        self.view.addSubview(containerView)
        
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.8
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        activityIndicator.startAnimating()
        
        loadingTasksCount = 1
    }
    
    
    func dismissLoadingView() {
        guard self.containerView != nil else {return}
        DispatchQueue.main.async {
            self.loadingTasksCount -= 1
            if self.loadingTasksCount  <= 0 {
                UIView.animate(withDuration: 0.25) {
                    self.containerView?.alpha = 0.0
                } completion: { _ in
                    self.containerView?.removeFromSuperview()
                    self.containerView = nil
                }
                self.loadingTasksCount = 0
            }
        }
    }
    
    func showEmptyStateView(with message: String) {
        let emptyStateView = GFEmptyStateView(emptyText: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}
