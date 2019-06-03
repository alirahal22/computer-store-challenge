//
//  LoginController.swift
//  ComputerStore
//
//  Created by Ali Rahal on 5/31/19.
//  Copyright © 2019 Ali Rahal. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyGif

class LoginViewController: UIViewController {
    
    let grayBackgroundViewWidthConstraint: CGFloat = 100
    let blueBackgroundViewWidthConstraint: CGFloat = 20
    let appearingBlueBackgroundWidthConstraint: CGFloat = 5
    let textFieldsVerticalSpacingConstraint: CGFloat = 20
    let loginButtonVerticalSpacingConstraint: CGFloat = 30
    
    
    // Constraints Constants
    let textFieldsHeightConstraint = 70
    let loginButtonHeightConstraint = 50
    let loginButtonWidthConstraint = 100
    
    //MARK: - UI Elements
    
    let grayBackgroungView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 249, green: 249, blue: 249, alpha: 1)
        return view
    }()
    
    let blueBackgroungView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        return view
    }()
    
    let topRoundedView = RoundedCornersView()
    let bottomRoundedView = RoundedCornersView()
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome To"
        label.font = UIFont(name: "Poppins-Bold", size: 30)
        return label
    }()
    
    let ulfdsLabel: UILabel = {
        let label = UILabel()
        label.text = "Areeba!"
        label.font = UIFont(name: "Poppins-Regular", size: 30)
        return label
    }()
    
    let usernameTextField: LoginTextFieldView = {
        let textFieldView = LoginTextFieldView()
        textFieldView.placeholder = "Username"
        textFieldView.textField.placeholder = "Your Username"
        return textFieldView
    }()
    
    let passwordTextField: LoginTextFieldView = {
        let textFieldView = LoginTextFieldView()
        textFieldView.placeholder = "Password"
        textFieldView.textField.placeholder = "Your Password"
        textFieldView.textField.isSecureTextEntry = true
        return textFieldView
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: UIControlState.normal)
        button.backgroundColor = UIColor.blue
        button.titleLabel?.textColor = UIColor.white
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        setUpViews()
    }
    
    //MARK: - UI SetUp
    func setUpViews() {
        addSubviews()
        setUpBackground()
        setUpTextFields()
        setUpLabels()
        setUpRoundedViews()
    }
    
    func addSubviews() {
        view.addSubview(grayBackgroungView)
        view.addSubview(blueBackgroungView)
        
        view.addSubview(topRoundedView)
        view.addSubview(bottomRoundedView)
        
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        
        view.addSubview(welcomeLabel)
        view.addSubview(ulfdsLabel)
    }
    
    func setUpBackground() {
        grayBackgroungView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(grayBackgroundViewWidthConstraint)
        }
        
        blueBackgroungView.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(blueBackgroundViewWidthConstraint)
        }
    }
    
    func setUpTextFields() {
        passwordTextField.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: appearingBlueBackgroundWidthConstraint))
            make.centerY.equalToSuperview()
            make.height.equalTo(textFieldsHeightConstraint)
        }
        
        usernameTextField.snp.makeConstraints { (make) in
            make.bottom.equalTo(passwordTextField.snp.top).offset(-textFieldsVerticalSpacingConstraint)
            make.left.right.equalTo(passwordTextField)
            make.height.equalTo(textFieldsHeightConstraint)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(loginButtonVerticalSpacingConstraint)
            make.left.right.equalTo(passwordTextField)
            make.height.equalTo(loginButtonHeightConstraint)
        }
    }
    
    
    func setUpLabels() {
        ulfdsLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(usernameTextField.snp.top)
            make.left.equalToSuperview().offset(60)
        }
        welcomeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(ulfdsLabel)
            make.bottom.equalTo(ulfdsLabel.snp.top)
        }
    }
    
    func setUpRoundedViews() {
        topRoundedView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-20)
            make.left.equalTo(grayBackgroungView.snp.right)
            make.right.equalToSuperview().offset(-appearingBlueBackgroundWidthConstraint)
            make.bottom.equalTo(loginButton.snp.top)
        }
        
        bottomRoundedView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(20)
            make.left.equalTo(grayBackgroungView.snp.right)
            make.right.equalToSuperview().offset(-appearingBlueBackgroundWidthConstraint)
            make.top.equalTo(loginButton.snp.bottom)
        }
    }
    
    @objc
    func loginButtonPressed() {
        self.present(UINavigationController(rootViewController: MainViewController()), animated: true, completion: nil)
    }
}

//MARK: - LoginTextFieldViewDelegate
extension LoginViewController: LoginTextFieldViewDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameTextField.endEditing(true)
        passwordTextField.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    
    func textFieldWillBeginEditing() {
        UIView.animate(withDuration: 0.25) {
            self.passwordTextField.snp.updateConstraints { (make) in
                make.centerY.equalToSuperview().offset(-70)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldWillEndEditing() {
        if usernameTextField.textField.isEditing || passwordTextField.textField.isEditing {
            return
        }
        UIView.animate(withDuration: 0.25) {
            self.passwordTextField.snp.updateConstraints { (make) in
                make.centerY.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }
    }
    
}

