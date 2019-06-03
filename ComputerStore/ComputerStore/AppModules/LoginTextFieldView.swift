//
//  LoginTextFieldView.swift
//  ComputerStore
//
//  Created by Ali Rahal on 5/31/19.
//  Copyright © 2019 Ali Rahal. All rights reserved.
//

import UIKit

protocol LoginTextFieldViewDelegate {
    func textFieldWillBeginEditing()
    func textFieldWillEndEditing()
}

class LoginTextFieldView: UIView {
    var delegate: LoginTextFieldViewDelegate?
    let textFieldHeightConstraint = 40
    
    var placeholder: String = "placeholder" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    
    
    let eyeGif = UIImage(gifName: "eye")
    let reverseEyeGif = UIImage(gifName: "eye_reverse")
    
    let gifImageView = UIImageView()
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Regular", size: 12)
        label.textColor = UIColor.black
        return label
    }()
    
    let textField = UITextField()
    let bottomBorder = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpTextField()
    }
    
    func setUpViews() {
        
        
        gifImageView.setGifImage(eyeGif)
        gifImageView.loopCount = 1
        gifImageView.stopAnimatingGif()
        
        
        
        
        
        
        addSubview(gifImageView)
        addSubview(placeholderLabel)
        addSubview(textField)
        addSubview(bottomBorder)
        
        
        
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(gifImageView.snp.right).offset(16)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(textFieldHeightConstraint)
        }
        
        placeholderLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(textField.snp.top).offset(-4)
            make.left.equalTo(textField)
        }
        
        
        
        gifImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.height.equalTo(textFieldHeightConstraint - 10)
            make.width.equalTo(gifImageView.snp.height).multipliedBy(0.8)
            make.centerY.equalTo(textField)
        }
        
        bottomBorder.backgroundColor = inactiveViewColor
        bottomBorder.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.left.equalTo(textField)
            make.bottom.right.equalToSuperview()
        }
    }
    
    func setUpTextField() {
        
        textField.font = UIFont(name: "Poppins-Regular", size: 18)
        
        textField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: UIControlEvents.editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldDidEndEditing), for: UIControlEvents.editingDidEnd)
    }
    
    let activeViewColor = UIColor.blue
    let inactiveViewColor = UIColor.black
    
    @objc func textFieldDidBeginEditing() {
        
        if let delegate = delegate {
            delegate.textFieldWillBeginEditing()
        }
        
        if (textField.text?.isEmpty)! {
            gifImageView.setGifImage(eyeGif)
            gifImageView.loopCount = 1
            gifImageView.startAnimatingGif()
            
            placeholderLabel.textColor = activeViewColor
            bottomBorder.backgroundColor = activeViewColor
            bottomBorder.snp.updateConstraints { (make) in
                make.height.equalTo(2)
            }
        }
    }
    
    @objc func textFieldDidEndEditing() {
        
        if let delegate = delegate {
            delegate.textFieldWillEndEditing()
        }
        
        if (textField.text?.isEmpty)! {
            gifImageView.setGifImage(reverseEyeGif)
            gifImageView.loopCount = 1
            gifImageView.startAnimatingGif()
            
            placeholderLabel.textColor = inactiveViewColor
            bottomBorder.backgroundColor = inactiveViewColor
            bottomBorder.snp.updateConstraints { (make) in
                make.height.equalTo(1)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

