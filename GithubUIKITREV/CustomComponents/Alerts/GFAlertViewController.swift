//
//  GFAlertViewController.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 05/03/25.
//

import UIKit

class GFAlertViewController: UIViewController {
    var alertView: GFAlertView!
    
    init(title: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        alertView = GFAlertView(alertTitle: title, message: message, buttonTitle: buttonTitle) {
            self.dismiss(animated: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        configureAlertView()
    }
    
    func configureAlertView() {
        self.view.addSubview(alertView)
        
        NSLayoutConstraint.activate([
            alertView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            alertView.widthAnchor.constraint(equalToConstant: 280),
            alertView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
}
