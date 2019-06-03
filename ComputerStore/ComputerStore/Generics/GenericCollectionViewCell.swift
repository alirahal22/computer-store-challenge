//
//  GenericCollectionViewCell.swift
//  ComputerStore
//
//  Created by Ali Rahal on 6/2/19.
//  Copyright © 2019 Ali Rahal. All rights reserved.
//

import UIKit

class GenericCollectionViewCell<U>: UICollectionViewCell {
    
    var item: U!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpViews() {
        print(setUpViews())
        
    }
}
