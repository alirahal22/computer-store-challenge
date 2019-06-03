//
//  MainViewController.swift
//  ComputerStore
//
//  Created by Ali Rahal on 5/31/19.
//  Copyright © 2019 Ali Rahal. All rights reserved.
//

import UIKit
import SnapKit



class MainViewController: UIViewController {
    
    lazy var computersViewController = ComputersViewController()
    var activeController: UIViewController!
    var delegate: MainViewControllerDelegate!
    
    let filtersContainer = UIView()
    let activeViewContainer = UIView()
    
    var filtersViewController: FiltersViewController!
    var filterViewIsVisible = false
    let filtersSlideAnimationDuration = 0.25
    
    //Constraints
    var filtersContainerWidth: CGFloat!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "Home"
        view.backgroundColor = UIColor.clear
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addComputerButtonPressed))
        
        activeController = computersViewController
        self.delegate = computersViewController
        setUpContainers()
        
        let panGestureRecognizser = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)) )
        view.addGestureRecognizer(panGestureRecognizser)
    }
    
    lazy var createComputerViewController = CreateComputerViewController()
    @objc func addComputerButtonPressed() {
        self.navigationController?.pushViewController(createComputerViewController, animated: true)
    }

    //MARK: UI SetUp
    func setUpContainers() {
        
        view.addSubview(activeViewContainer)
        activeViewContainer.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        setUpActiveContainer()

        view.addSubview(filtersContainer)
        filtersContainerWidth = view.frame.width * 0.8
        filtersContainer.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(filtersContainerWidth)
            make.left.equalTo(-filtersContainerWidth)
        }
        setUpFiltersContainer()
    }
    
    func setUpActiveContainer() {
        addChildViewController(activeController)
        activeViewContainer.addSubview(activeController.view)
        activeController.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    
    
}

//MARK: - Filters Container SetUp
extension MainViewController: FiltersViewControllerDelegate {
    
    func setUpFiltersContainer() {
        filtersViewController = FiltersViewController()
        addChildViewController(filtersViewController)
        filtersViewController.delegate = self
        filtersContainer.addSubview(filtersViewController.view)
        
        filtersViewController.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    //MARK: - Swipe Animation
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer){
        filtersViewController.ramsFilterField.textField.endEditing(true)
        let translation = recognizer.translation(in: self.view)
        
        
        if recognizer.state == .ended || recognizer.state == .failed || recognizer.state == .cancelled {
            
            if filterViewIsVisible {
                //hide the menu when dragging left
                if translation.x < -10 {
                    toggleFilters()
                }
            } else {
                //show the menu when dragging right more than 100
                if translation.x > 100 {
                    toggleFilters()
                } else {
                    //hide menu when drag is small
                    hideMenu()
                }
            }
            return
        }
        if !filterViewIsVisible && translation.x > 0 && translation.x <= filtersContainerWidth {
            filtersContainer.snp.updateConstraints { (make) in
                make.left.equalTo(-filtersContainerWidth + translation.x)
            }
        }
        if filterViewIsVisible && translation.x < 0 && translation.x >= -filtersContainerWidth {
            filtersContainer.snp.updateConstraints { (make) in
                make.left.equalTo(translation.x)
            }
        }
        self.filtersContainer.superview?.layoutIfNeeded()
    }
    
    @objc func toggleFilters() {
        
        if filterViewIsVisible {
            hideMenu()
        } else {
            showMenu()
        }
        filterViewIsVisible = !filterViewIsVisible
    }
    
    func showMenu() {
        UIView.animate(withDuration: filtersSlideAnimationDuration) {
            self.filtersContainer.snp.updateConstraints({ (make) in
                make.left.equalToSuperview()
            })
            self.filtersContainer.superview?.layoutIfNeeded()
        }
        
    }
    
    func hideMenu() {
        UIView.animate(withDuration: filtersSlideAnimationDuration) {
            self.filtersContainer.snp.updateConstraints({ (make) in
                make.left.equalTo(-self.filtersContainerWidth)
            })
            self.filtersContainer.superview?.layoutIfNeeded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        filtersViewController.ramsFilterField.textField.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    //MARK: - FiltersViewControllerDelegate
    func didApplyFilters(filters: [String: Any]) {
        delegate.applyFilters(filters: filters)
        toggleFilters()
    }
    
    func didResetFilters() {
        delegate.resetFilters()
        toggleFilters()
    }
    
}



protocol MainViewControllerDelegate {
    func applyFilters(filters: [String: Any])
    func resetFilters()
}



















