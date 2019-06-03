//
//  ComputerViewController.swift
//  ComputerStore
//
//  Created by Ali Rahal on 5/31/19.
//  Copyright © 2019 Ali Rahal. All rights reserved.
//

import UIKit

class ComputerViewController: UIViewController {

    //constraints
    let imageViewHeight: CGFloat = 300
    let labelsHeight: CGFloat = 24
    let buttonsHeight: CGFloat = 80
    
    
    var id: String!
    var computer: Computer! {
        didSet {
            if let id = computer._id {
                self.id = id
            }
            //we can safely force unwrap these fields(never null, required by the server)
            nameLabel.text = "\(computer.name!)"
            priceLabel.text = "\(computer.price!)$"
            brandLabel.text = "Brand: \(computer.brand!)"
            cpuLabel.text = "CPU: \(computer.cpu!)"
            ramsLabel.text = "RAMs: \(computer.rams!)GB"
            modelNumberLabel.text = "Model Number: \(computer.modelNumber!)"
            
            //add the image
        }
    }
    
    //MARK: - UI Elements
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let computerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "computer_image")!
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        return imageView
    }()
    
    let nameLabel = SpecLabel()
    let priceLabel = SpecLabel()
    
    let topSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    let specsLabel: UILabel = {
        let label = UILabel()
        label.text = "Specifications"
        label.font = UIFont(name: "Poppins-Bold", size: 21)
        return label
    }()
    
    let modelNumberLabel = SpecLabel()
    let cpuLabel = SpecLabel()
    let ramsLabel = SpecLabel()
    let brandLabel = SpecLabel()
    
    let bottomSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(editComputer), for: .touchUpInside)
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete Computer", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(deleteComputer), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpScrollView()
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layoutIfNeeded()
    }
    
    
    //MARK: - UI SetUp
    func setUpScrollView() {
        scrollView.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints({ (make) in
            make.edges.equalTo(scrollView)
            make.width.equalTo(view)
        })
    }
    
    func setUpViews() {
        contentView.addSubview(computerImageView)
        computerImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(8)
            make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
            make.height.equalTo(contentView.snp.width).multipliedBy(0.6)
        }
        
        addSeparator(separator: topSeparator, under: computerImageView)
        addView(newView: nameLabel, under: topSeparator, withHeight: labelsHeight)
        addView(newView: priceLabel, under: nameLabel, withHeight: labelsHeight)
        addSeparator(separator: bottomSeparator, under: priceLabel)
        addView(newView: specsLabel, under: bottomSeparator, withHeight: labelsHeight)
        addView(newView: brandLabel, under: specsLabel, withHeight: labelsHeight)
        addView(newView: cpuLabel, under: brandLabel, withHeight: labelsHeight)
        addView(newView: ramsLabel, under: cpuLabel, withHeight: labelsHeight)
        addView(newView: modelNumberLabel, under: ramsLabel, withHeight: labelsHeight)
        addView(newView: editButton, under: modelNumberLabel, withHeight: buttonsHeight)
        editButton.snp.updateConstraints { (make) in
            make.right.equalToSuperview().offset(-8)
        }
        contentView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { (make) in
            make.top.equalTo(editButton.snp.bottom).offset(4)
            make.height.left.right.equalTo(editButton)
            make.bottom.equalTo(contentView.snp.bottom).offset(-4)
        }
        
        view.layoutSubviews()
    }

    func addView(newView: UIView, under topView: UIView, withHeight: CGFloat) {
        self.contentView.addSubview(newView)
        newView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(4)
            make.height.equalTo(withHeight)
            make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0))
        }
    }
    
    func addSeparator(separator: UIView, under topView: UIView) {
        self.contentView.addSubview(separator)
        separator.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topView.snp.bottom).offset(4)
            make.height.equalTo(1)
        }
    }
    
    
    //MARK: - Operations Handlers
    @objc
    func deleteComputer() {
        APIServices.shared.deleteComputer(computerId: id) { (error) in
            if let error = error {
                print("\(error)")
            } else {
                print("Computer Deleted")
            }
        }
        self.navigationController?.popViewController(animated: true)
        let mainViewController = self.navigationController?.visibleViewController as! MainViewController
        mainViewController.computersViewController.curPage = 1
        mainViewController.computersViewController.keepFetching = true
        mainViewController.computersViewController.fetchData(at: 1, searchString: nil, filters: nil)
    }
    
    let updateComputerViewController = CreateComputerViewController()
    @objc
    func editComputer() {
        print("Edit Computer")
        computer._id = id
        updateComputerViewController.computer = computer
        self.navigationController?.pushViewController(updateComputerViewController, animated: true)
    }
}






