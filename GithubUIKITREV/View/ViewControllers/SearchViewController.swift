//
//  FirstViewController.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 04/03/25.
//

import UIKit

class SearchViewController: UIViewController {
    let logoImageView = UIImageView(image: .ghLogo)
    let userNameTextField = GFTextField()
    let getFollowersButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers")
    
    var isUserNameEntered: Bool {
        !(userNameTextField.text?.isEmpty ?? true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.userNameTextField.text = ""
    }
    
    private func configureViewController() {
        self.view.backgroundColor = .systemBackground
        self.addTapGesture()
        self.addKeyBoardNotifications()
        
        self.view.addSubview(logoImageView)
        self.view.addSubview(userNameTextField)
        self.view.addSubview(getFollowersButton)
        
        self.setUpLogoImageView()
        self.setUpTextField()
        self.setUpGetFollowersButton()
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func addKeyBoardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setUpLogoImageView() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    private func setUpTextField() {
        userNameTextField.delegate = self
        NSLayoutConstraint.activate([
            userNameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 68),
            userNameTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            userNameTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
            userNameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setUpGetFollowersButton() {
        getFollowersButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        NSLayoutConstraint.activate([
            getFollowersButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            getFollowersButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            getFollowersButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
            getFollowersButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func pushFollowerListVC() {
        guard isUserNameEntered, let userName = userNameTextField.text else {
            self.presentGFAlertViewController(
                title: "Empty Username",
                message: "Please enter an username, we need to know who to look for 😄.",
                buttonTitle: "Ok")
            return
        }
        userNameTextField.resignFirstResponder()
        let viewModel = FollowerListViewModel(userName: userName)
        let followerListVC = FollowersListVC(viewModel: viewModel)
        self.navigationController?.pushViewController(followerListVC, animated: true)
    }
}

// MARK: KEYBOARD HANDLING
extension SearchViewController {
    @objc func keyBoardWillShow(sender: NSNotification) {
        guard let userInfo = sender.userInfo,
              let keyBoardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextField =  UIResponder.currentFirst() as? UITextField else {
            return
        }
        
        let keyBoardTopY = keyBoardFrame.cgRectValue.origin.y
        let convertedTextFieldFrame = self.view.convert(currentTextField.frame, from: currentTextField.superview)
        
        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.height
        
        if textFieldBottomY > keyBoardTopY {
            let newFrame = textFieldBottomY - keyBoardTopY + 20.0
            view.frame.origin.y -= newFrame
        }
    }
    
    @objc func keyBoardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
}

// MARK: TEXTFIELD DELEGATE
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.pushFollowerListVC()
        return true
    }
}
