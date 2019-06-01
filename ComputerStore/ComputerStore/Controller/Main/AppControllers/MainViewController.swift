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
    
    //prepare all possible controllers as lazy var
    lazy var computersViewController = ComputersViewController()
    var activeController: UIViewController!
    
    let menuContainer = UIView()
    let activeViewContainer = UIView()
    
    var filtersViewController: FiltersViewController!
    var filterViewIsVisible = false
    let filtersSlideAnimationDuration = 0.25
    
    
    
    let navigationBarTitleLabel = UILabel()
    let navigationBarButton = UIButton(type: UIButtonType.custom)
    let navigationBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    let centerLabel: UILabel = {
        let label = UILabel()
        label.text = "King Rahal"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        activeController = computersViewController
        setUpContainers()
        
        let panGestureRecognizser = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)) )
        view.addGestureRecognizer(panGestureRecognizser)
    }
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer){
        let translation = recognizer.translation(in: self.view)
        
        
        if recognizer.state == .ended || recognizer.state == .failed || recognizer.state == .cancelled {
            
            if filterViewIsVisible {
                //hide the menu when dragging left
                if translation.x < -10 {
                    navigationBarButtonPressed()
                }
            } else {
                //show the menu when dragging right more than 100
                if translation.x > 100 {
                    navigationBarButtonPressed()
                } else {
                    //hide menu when drag is small
                    hideMenu()
                }
            }
            return
        }
        
        
        if !filterViewIsVisible && translation.x > 0 && translation.x <= menuContainerWidth {
            menuContainer.snp.updateConstraints { (make) in
                make.left.equalTo(-menuContainerWidth + translation.x)
            }
            navigationBar.snp.updateConstraints { (make) in
                make.left.equalTo(translation.x)
            }
            activeViewContainer.snp.updateConstraints { (make) in
                make.left.equalTo(translation.x)
            }
        }
        
        if filterViewIsVisible && translation.x < 0 && translation.x >= -menuContainerWidth {
            menuContainer.snp.updateConstraints { (make) in
                make.left.equalTo(translation.x)
            }
            navigationBar.snp.updateConstraints { (make) in
                make.left.equalTo(menuContainerWidth + translation.x)
            }
            activeViewContainer.snp.updateConstraints { (make) in
                make.left.equalTo(menuContainerWidth + translation.x)
            }
        }
        self.menuContainer.superview?.layoutIfNeeded()
        self.navigationBar.superview?.layoutIfNeeded()
    }
    
    
    
    let navigationBarHeight = 60
    var menuContainerWidth: CGFloat!
    func setUpContainers() {
        
        //Set Up Custom Navigation Bar
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { (make) in
            make.left.top.width.equalToSuperview()
            make.height.equalTo(navigationBarHeight)
        }
        setUpNavigationBar()
        
        
        view.addSubview(activeViewContainer)
        activeViewContainer.snp.makeConstraints { (make) in
            make.bottom.left.width.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
        }
        setUpActiveContainer()
        
        
        view.addSubview(menuContainer)
        menuContainerWidth = view.frame.width * 0.8
        menuContainer.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(menuContainerWidth)
            make.left.equalTo(-menuContainerWidth)
        }
        setUpMenuContainer()
    }
    
    func setUpNavigationBar() {
        
        let buttonTopConstraint = 12
        
        navigationBar.addSubview(navigationBarButton)
        if let image = UIImage(named: "hamburger_menu") {
            navigationBarButton.setImage(image, for: UIControlState.normal)
        }
        navigationBarButton.addTarget(self, action: #selector(navigationBarButtonPressed), for: UIControlEvents.touchUpInside)
        navigationBarButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(navigationBarHeight - 8)
            make.left.equalTo(4)
            make.top.equalTo(buttonTopConstraint)
        }
        
        
        navigationBar.addSubview(navigationBarTitleLabel)
        navigationBarTitleLabel.font = UIFont.systemFont(ofSize: 28)
        navigationBarTitleLabel.textAlignment = .center
        navigationBarTitleLabel.text = "Home"
        navigationBarTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(buttonTopConstraint)
            make.height.equalTo(navigationBarHeight - 8)
            make.width.equalToSuperview()
        }
    }
    
    
    func setUpActiveContainer() {
        addChildViewController(activeController)
        activeViewContainer.addSubview(activeController.view)
        activeController.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    
    
}

//Side Menu Delegate and setup functions
extension MainViewController: FiltersViewControllerDelegate {
    func didApplyFilters(filters: String) {
        navigationBarTitleLabel.text = filters
//        switchController(from: activeController, to: UIViewController())
        navigationBarButtonPressed()
    }
    
    func setUpMenuContainer() {
        filtersViewController = FiltersViewController()
        addChildViewController(filtersViewController)
        filtersViewController.delegate = self
        menuContainer.addSubview(filtersViewController.view)
        
        filtersViewController.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        menuContainer.backgroundColor = UIColor.cyan
        
    }
    
    @objc func navigationBarButtonPressed() {
        
        if filterViewIsVisible {
            hideMenu()
        } else {
            showMenu()
        }
        filterViewIsVisible = !filterViewIsVisible
    }
    
    func showMenu() {
        UIView.animate(withDuration: filtersSlideAnimationDuration) {
            self.menuContainer.snp.updateConstraints({ (make) in
                make.left.equalToSuperview()
            })
            
            self.navigationBar.snp.updateConstraints({ (make) in
                make.left.equalTo(self.menuContainerWidth)
            })
            self.activeViewContainer.snp.updateConstraints({ (make) in
                make.left.equalTo(self.menuContainerWidth)
            })
            self.menuContainer.superview?.layoutIfNeeded()
            self.navigationBar.superview?.layoutIfNeeded()
        }
        
        //hide the title label
        UIView.animate(withDuration: filtersSlideAnimationDuration / 4) {
            self.navigationBarTitleLabel.layer.opacity = 0
        }
    }
    
    func hideMenu() {
        UIView.animate(withDuration: filtersSlideAnimationDuration) {
            self.menuContainer.snp.updateConstraints({ (make) in
                make.left.equalTo(-self.menuContainerWidth)
            })
            self.navigationBar.snp.updateConstraints({ (make) in
                make.left.equalToSuperview()
            })
            self.activeViewContainer.snp.updateConstraints({ (make) in
                make.left.equalToSuperview()
            })
            self.menuContainer.superview?.layoutIfNeeded()
            self.navigationBar.superview?.layoutIfNeeded()
            
            
        }
        //show title label
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + filtersSlideAnimationDuration/2) {
            UIView.animate(withDuration: self.filtersSlideAnimationDuration / 4) {
                self.navigationBarTitleLabel.layer.opacity = 1
            }
        }
    }
    
}

//Switching Controllers inside ActiveViewContainer
//extension MainViewController {
//    func switchController(from oldController: UIViewController,to newController: MenuOption) {
//        var controller: UIViewController!
//        switch newController {
//        case .Home:
//            controller = homeViewController
//        case .Grades:
//            controller = activeCoursesViewController
//        case .Archive:
//            controller = gradesArchiveViewController
//        case .Exams:
//            controller = examPlacesViewController
//        case .Schedule:
//            controller = activeCoursesViewController
//        case .AboutUs:
//            controller = activeCoursesViewController
//        }
//        //        addChildViewController(controller)
//        //        activeViewContainer.addSubview(controller.view)
//        //        controller.view.snp.makeConstraints { (make) in
//        //            make.edges.equalToSuperview()
//        //        }
//        //
//        print(newController.rawValue)
//        activeController = controller
//        setUpActiveContainer()
//    }
//
//}
