//
//  ComputersCollectionViewController.swift
//  ComputerStore
//
//  Created by Ali Rahal on 5/31/19.
//  Copyright © 2019 Ali Rahal. All rights reserved.
//

import UIKit

class ComputersViewController: UIViewController {
    
    var activeSearchString: String!
    var activeFilters: [String: Any]!

    var keepFetching = true
    var curPage = 1

    lazy var computerViewController = ComputerViewController()
    
    let computersCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let cellId = "ComputerCellId"
    let collectionViewCellHeight: CGFloat = 100
    var computers = [Computer]()
    
    let searchBar = UISearchBar()
    var searchBarIsEditing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSearchBar()
        setUpCollectionView()
        
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    
    
    //MARK: - UI SetUp
    func setUpSearchBar() {
        searchBar.delegate = self
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
            
        }
        view.layoutSubviews()
        view.layoutIfNeeded()
    }
    
    func setUpCollectionView() {
        computersCollectionView.register(ComputerCell.self, forCellWithReuseIdentifier: cellId)
        computersCollectionView.delegate = self
        computersCollectionView.dataSource = self
        computersCollectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        computersCollectionView.backgroundColor = UIColor.white
        view.addSubview(computersCollectionView)
        
        computersCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        
        fetchData(at: curPage,searchString: nil, filters: nil)
        computersCollectionView.reloadData()
    }

    
    func fetchData(at page: Int, searchString: String!, filters: [String: Any]!) {
        APIServices.shared.fetchComputers(fromPage: curPage, searchString: searchString, filters: filters) { (computers, error) in
            guard let computers = computers, error == nil else {
                print("An error occured")
                return
            }
            guard self.keepFetching else { return }
            self.computers.append(contentsOf: computers)
            self.curPage = self.curPage + 1
            self.computersCollectionView.reloadData()
            if computers.count == 0 {
                self.keepFetching = false
            }
            
        }
    }

}

//MARK: - UISearchBarDelegate and Search Handlers
extension ComputersViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBarIsEditing = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search()
        searchBar.endEditing(true)
    }
    
    func search() {
        refresh()
        activeFilters = nil
        activeSearchString = searchBar.text!
        fetchData(at: curPage, searchString: activeSearchString, filters: nil)
        searchBarIsEditing = false
    }
}

//MARK: - UICollectionViewDataSource
extension ComputersViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return computers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ComputerCell
        cell.item = computers[indexPath.row]
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension ComputersViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if searchBarIsEditing {
            return
        }
        computerViewController.computer = computers[indexPath.row]
        navigationController?.pushViewController(computerViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionViewCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row + 1 == computers.count {
            fetchData(at: curPage, searchString: activeSearchString, filters: activeFilters)
        }
    }

}

//MARK: - MainViewControllerDelegate
extension ComputersViewController: MainViewControllerDelegate {
    func applyFilters(filters: [String : Any]) {
        refresh()
        activeSearchString = nil
        activeFilters = filters
        fetchData(at: curPage, searchString: activeSearchString, filters: activeFilters)
    }
    
    func resetFilters() {
        refresh()
        searchBar.text = ""
        activeFilters = nil
        activeSearchString = nil
        fetchData(at: curPage, searchString: nil, filters: nil)
    }
    
    func refresh() {
        computersCollectionView.contentOffset = CGPoint(x: 0, y: 0)
        curPage = 1
        keepFetching = true
        computers.removeAll()
        computersCollectionView.reloadData()
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        searchBar.endEditing(true)
    }
    
}






















