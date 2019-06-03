//
//  SpecLabel.swift
//  ComputerStore
//
//  Created by Ali Rahal on 6/1/19.
//  Copyright © 2019 Ali Rahal. All rights reserved.
//

import UIKit

class SpecLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        font = UIFont(name: "Poppins-Regular", size: 18)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
