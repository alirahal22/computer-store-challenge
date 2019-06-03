//
//  EditingTextField.swift
//  ComputerStore
//
//  Created by Ali Rahal on 6/2/19.
//  Copyright © 2019 Ali Rahal. All rights reserved.
//

import UIKit

protocol EditingTextFieldDelegate {
    func textFieldWillBeginEditing()
    func textFieldWillEndEditing()
}

class EditingTextField: UIView {

    //Constraints
    let nameLabelHeight: CGFloat = 10
    
    var title: String = "Title" {
        didSet {
            fieldNameLabel.text = title
        }
    }
    
    var delegate: EditingTextFieldDelegate?
    
    let fieldNameLabel = SpecLabel()
    let textField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fieldNameLabel.font = UIFont(name: fieldNameLabel.font.fontName, size: 12)
        textField.borderStyle = UITextBorderStyle.bezel
        textField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: UIControlEvents.editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldDidEndEditing), for: UIControlEvents.editingDidEnd)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        addSubview(fieldNameLabel)
        fieldNameLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(nameLabelHeight)
        }
        addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(fieldNameLabel.snp.bottom).offset(4)
            make.bottom.left.right.equalToSuperview()
        }
    }
    
    @objc func textFieldDidBeginEditing() {
        
        if let delegate = delegate {
            delegate.textFieldWillBeginEditing()
        }
    }
    
    @objc func textFieldDidEndEditing() {
        
        if let delegate = delegate {
            delegate.textFieldWillEndEditing()
        }
    }

}
