//
//  ComputerCell.swift
//  ComputerStore
//
//  Created by Ali Rahal on 5/31/19.
//  Copyright © 2019 Ali Rahal. All rights reserved.
//

import UIKit

class ComputerCell: GenericCollectionViewCell<Computer> {
    override var item: Computer! {
        didSet {
            nameLabel.text = "\(item.name!)"
            priceLabel.text = "\(item.price!)$"
            brandLabel.text = "\(item.brand!)"
        }
    }
    
    //constraints
    let labelsHeight: CGFloat = 24
    
    //MARK: - UI Elements
    let cardView = UIView()
    let computerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "computer_image")!
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        return imageView
    }()
    
    let nameLabel = SpecLabel()
    let priceLabel = SpecLabel()
    let brandLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        return label
    }()
    
    let verticalSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    let horizontalSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    //MARK: - UI SetUp
    override func setUpViews() {
        backgroundColor = .white
        setUpCardView()
        setUpCardViewContent()
        setUpSeparators()
    }
    
    func setUpCardView() {
        addSubview(cardView)
        cardView.backgroundColor = .white
        cardView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4))
        }
    }
    
    func setUpCardViewContent() {
        cardView.addSubview(computerImageView)
        computerImageView.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
            make.width.equalTo(computerImageView.snp.height)
            make.left.top.equalToSuperview()
        }
        
        cardView.addSubview(nameLabel)
        cardView.addSubview(priceLabel)
        cardView.addSubview(brandLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(4)
            make.height.equalTo(labelsHeight)
            make.left.equalTo(computerImageView.snp.right).offset(4)
            make.right.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.height.equalTo(labelsHeight)
            make.left.equalTo(computerImageView.snp.right).offset(4)
            make.right.equalToSuperview()
        }
        
        brandLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-4)
            make.height.equalTo(labelsHeight)
            make.left.equalTo(computerImageView.snp.right).offset(4)
            make.right.equalToSuperview()
        }
    }
    
    func setUpSeparators() {
        cardView.addSubview(verticalSeparator)
        verticalSeparator.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.left.equalTo(computerImageView.snp.right)
            make.top.bottom.equalToSuperview()
        }
        
        cardView.addSubview(horizontalSeparator)
        horizontalSeparator.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.bottom.equalTo(brandLabel.snp.top).offset(-4)
            make.left.equalTo(verticalSeparator.snp.right)
            make.right.equalToSuperview()
        }
        layoutSubviews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let cornerRadius: CGFloat = 2
        let shadowOffsetWidth: CGFloat = 1
        let shadowOffsetHeight: CGFloat = 3
        let shadowColor = UIColor.black
        let shadowOpacity: Float = 0.5

        cardView.layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: cornerRadius)
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor = shadowColor.cgColor
        cardView.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        cardView.layer.shadowOpacity = shadowOpacity
        cardView.layer.shadowPath = shadowPath.cgPath
    }
}
