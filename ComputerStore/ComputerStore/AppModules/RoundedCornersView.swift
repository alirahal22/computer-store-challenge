//
//  RoundedCornersView.swift
//  ComputerStore
//
//  Created by Ali Rahal on 5/31/19.
//  Copyright © 2019 Ali Rahal. All rights reserved.
//


import UIKit

class RoundedCornersView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.masksToBounds = true
        layer.cornerRadius = 12
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
