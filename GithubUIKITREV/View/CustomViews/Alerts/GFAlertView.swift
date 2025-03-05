//
//  GFAlertView.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 05/03/25.
//

import UIKit

class GFAlertView: UIView {
    var titleLabel: GFTitleLabel = GFTitleLabel(fontSize: 20, alignment: .center)
    var  bodyLabel: GFBodyLabel = GFBodyLabel(alignment: .center)
    var alertButton: GFButton = GFButton(backgroundColor: .systemPink, title: "Ok")
    
    let padding: CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var alertAction: (() -> Void)?
    
    init(alertTitle: String, message: String, buttonTitle: String, alertAction: @escaping () -> Void) {
        super.init(frame: .zero)
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.alertAction = alertAction
        self.addSubViews(titleLabel, alertButton, bodyLabel)
        configureTitleLabel(alertTitle: alertTitle)
        configureAlertButton(buttonTitle: buttonTitle)
        configureBodyLabel(message: message)
    }
    
    private func configureTitleLabel(alertTitle: String) {
        self.titleLabel.text = alertTitle
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding)
        ])
    }
    
    private func configureAlertButton(buttonTitle: String) {
        self.alertButton.setTitle(buttonTitle, for: .normal)
        self.alertButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            alertButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding),
            alertButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            alertButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            alertButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc func dismiss() {
        alertAction?()
    }
    
    private func configureBodyLabel(message: String) {
        self.bodyLabel.text = message
        self.bodyLabel.numberOfLines = 4
        
        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            bodyLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            bodyLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            bodyLabel.bottomAnchor.constraint(equalTo: alertButton.topAnchor, constant: -12)
        ])
    }
}
