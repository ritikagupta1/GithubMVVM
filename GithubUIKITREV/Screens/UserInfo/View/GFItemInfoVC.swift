//
//  GFItemInfoViewController 2.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 08/03/25.
//


import UIKit

class GFItemInfoVC: UIViewController {
    var user: User
    
    let hStackView = UIStackView()
    let itemInfoViewOne = GFItemInfoView()
    let itemInfoViewTwo = GFItemInfoView()
    let button = GFButton()
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configureBackground()
        layoutUI()
        configureStackView()
        configureButtonAction()
    }
    
    private func configureBackground() {
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func layoutUI() {
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubViews(hStackView, button)
        
        let padding: CGFloat = 20
       
        NSLayoutConstraint.activate([
            hStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            hStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            hStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            hStackView.heightAnchor.constraint(equalToConstant: 50),
            
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configureButtonAction() {
        button.addTarget(self, action: #selector(buttonActionTapped), for: .touchUpInside)
    }
    
    @objc func buttonActionTapped() {}
    
    func configureStackView() {
        hStackView.axis = .horizontal
        hStackView.distribution = .equalSpacing
        
        hStackView.addArrangedSubview(itemInfoViewOne)
        hStackView.addArrangedSubview(itemInfoViewTwo)
    }
}
