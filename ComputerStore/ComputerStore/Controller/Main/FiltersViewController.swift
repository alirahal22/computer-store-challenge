//
//  FiltersViewController.swift
//  ComputerStore
//
//  Created by Ali Rahal on 5/31/19.
//  Copyright © 2019 Ali Rahal. All rights reserved.
//


import UIKit
import SnapKit


class FiltersViewController: UIViewController {
    
    var delegate: FiltersViewControllerDelegate?
    
    var cpus = ["Any"]
    var brands = ["Any"]
    
    var filters: [String: Any] = [:]
    //constraints
    let buttonsWidth: CGFloat = 100
    let buttonsHeight: CGFloat = 30
    let buttonsOffsetFromCenter = 2
    
    
    //MARK: - UI Elements
    
    let ramsFilterField = EditingTextField()
    let cpusPicker = UIPickerView()
    let brandsPicker = UIPickerView()
    
    let applyFiltersButton: UIButton = {
        let button = UIButton()
        button.setTitle("Apply Filters", for: UIControlState.normal)
        button.titleLabel?.textColor = .white
        button.layer.backgroundColor = UIColor.blue.cgColor
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(applyFilters), for: .touchUpInside)
        return button
    }()
    
    let resetFiltersButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reset Filters", for: UIControlState.normal)
        button.titleLabel?.textColor = .white
        button.layer.backgroundColor = UIColor.blue.cgColor
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(resetFilters), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        
        setUpButtons()
        setUpFilters()
        fetchData()
    }
    
    //MARK: - UI SetUp
    func setUpButtons() {
        view.addSubview(applyFiltersButton)
        view.addSubview(resetFiltersButton)
        applyFiltersButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview().dividedBy(2).offset(-buttonsOffsetFromCenter)
            make.height.equalTo(buttonsHeight)
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(20)
        }
        resetFiltersButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.left.equalTo(applyFiltersButton.snp.right).offset(buttonsOffsetFromCenter)
            make.height.equalTo(buttonsHeight)
            make.top.equalTo(applyFiltersButton)
        }
    }
    
    func setUpFilters() {
        cpusPicker.delegate = self
        cpusPicker.dataSource = self
        brandsPicker.delegate = self
        brandsPicker.dataSource = self
        
        ramsFilterField.title = "RAMs"
        ramsFilterField.textField.keyboardType = UIKeyboardType.numberPad
        addView(newView: ramsFilterField, under: applyFiltersButton, withHeight: 50)
        addView(newView: cpusPicker, under: ramsFilterField, withHeight: 70)
        addView(newView: brandsPicker, under: cpusPicker, withHeight: 70)
    }
    
    func addView(newView: UIView, under topView: UIView, withHeight: CGFloat) {
        self.view.addSubview(newView)
        newView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(10)
            make.height.equalTo(withHeight)
            make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        }
    }
    
    
    //MARK: - Handlers
    
    @objc
    func applyFilters() {
        if ramsFilterField.textField.text != "" {
            filters["rams"] = Int(ramsFilterField.textField.text!)
        }
        if cpusPicker.selectedRow(inComponent: 0) != 0 {
            filters["cpu"] = cpus[cpusPicker.selectedRow(inComponent: 0)]
        }
        if brandsPicker.selectedRow(inComponent: 0) != 0 {
            filters["brand"] = brands[brandsPicker.selectedRow(inComponent: 0)]
        }
        if let delegate = delegate {
            delegate.didApplyFilters(filters: filters)
        }
    }
    
    @objc
    func resetFilters() {
        if let delegate = delegate {
            delegate.didResetFilters()
        }
        cpusPicker.selectRow(0, inComponent: 0, animated: true)
        brandsPicker.selectRow(0, inComponent: 0, animated: true)
        ramsFilterField.textField.text = ""
        filters.removeAll()
    }
    
    func fetchData() {
        APIServices.shared.fetchStrings(from: "cpus") { (array, error) in
            guard let cpus = array, error == nil else {
                print("An error occured")
                return
            }
            self.cpus.append(contentsOf: cpus)
            self.cpusPicker.reloadAllComponents()
        }
        APIServices.shared.fetchStrings(from: "brands") { (array, error) in
            guard let brands = array, error == nil else {
                print("An error occured")
                return
            }
            self.brands.append(contentsOf: brands)
            self.brandsPicker.reloadAllComponents()
        }
    }
    
    
   
}


//MARK: - FiltersViewControllerDelegate protocol
protocol FiltersViewControllerDelegate {
    func didApplyFilters(filters: [String: Any])
    func didResetFilters()
}

//MARK: - PickerView Delegate
extension FiltersViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == cpusPicker {
            if cpus[row] == "Any"{
                filters.removeValue(forKey: "cpu")
                return
            }
            filters["cpu"] = cpus[row]
        }
        if pickerView == brandsPicker {
            if brands[row] == "Any"{
                filters.removeValue(forKey: "brand")
                return
            }
            filters["brand"] = brands[row]
        }
    }
}

//MARK: - PickerView Datasource
extension FiltersViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == cpusPicker {
            return cpus.count
        }
        if pickerView == brandsPicker {
            return brands.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == cpusPicker {
            return cpus[row]
        }
        if pickerView == brandsPicker {
            return brands[row]
        }
        return ""
    }
    
    
}



