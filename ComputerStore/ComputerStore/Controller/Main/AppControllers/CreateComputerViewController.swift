//
//  CreateComputerViewController.swift
//  ComputerStore
//
//  Created by Ali Rahal on 6/2/19.
//  Copyright © 2019 Ali Rahal. All rights reserved.
//

import UIKit

class CreateComputerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    var computer: Computer! {
        didSet { //if a computer is set then we are editing not creating
            if computer == nil {
                return
            }
            clearButton.setTitle("Cancel", for: .normal)
            createButton.setTitle("Update Changes", for: .normal)
            nameTextField.textField.text = computer.name
            priceTextField.textField.text = "\(computer.price!)"
            brandTextField.textField.text = computer.brand
            cpuTextField.textField.text = computer.cpu
            ramsTextField.textField.text = "\(computer.rams!)"
            modelNumberTextField.textField.text = computer.modelNumber
            selectImageButton.setImage(UIImage(named: "computer_image"), for: .normal)
        }
    }
    
    
    //Constraints
    let editingTextFieldsHeight: CGFloat = 44
    
    
    
    //MARK: - UI Elements
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let selectImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "image_placeholder"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        return button
    }()
    
    let clearButton: UIButton = {
        let button = UIButton()
        button.setTitle("Clear", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(clear), for: .touchUpInside)
        return button
    }()
    
    let createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Computer", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(createComputer), for: .touchUpInside)
        return button
    }()
    
    let imagePicker: UIImagePickerController = {
        let image = UIImagePickerController()
        
        image.allowsEditing = false
        return image
    }()

    let nameTextField = EditingTextField()
    let priceTextField = EditingTextField()
    let brandTextField = EditingTextField()
    let cpuTextField = EditingTextField()
    let ramsTextField = EditingTextField()
    let modelNumberTextField = EditingTextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        configureTextFields()
        imagePicker.delegate = self
        
        
        setUpScrollView()
        setUpScrollViewContent()
        
        // Do any additional setup after loading the view.
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
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(stopEditing))
        contentView.addGestureRecognizer(gesture)
    }

    //use contentView instead of self.view
    func setUpScrollViewContent() {
        contentView.addSubview(selectImageButton)
        selectImageButton.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(8)
            make.left.right.equalToSuperview()
            make.height.equalTo(contentView.snp.width).multipliedBy(0.6)
        }
        
        addView(newView: nameTextField, under: selectImageButton)
        addView(newView: priceTextField, under: nameTextField)
        addView(newView: brandTextField, under: priceTextField)
        addView(newView: cpuTextField, under: brandTextField)
        addView(newView: ramsTextField, under: cpuTextField)
        addView(newView: modelNumberTextField, under: ramsTextField)
        addView(newView: createButton, under: modelNumberTextField)
        contentView.addSubview(clearButton)
        clearButton.snp.makeConstraints { (make) in
            make.top.equalTo(createButton.snp.bottom).offset(4)
            make.height.left.right.equalTo(createButton)
            make.bottom.equalTo(contentView.snp.bottom).offset(-4)
        }
    }
    
    func configureTextFields() {
        nameTextField.title = "Name"
        nameTextField.delegate = self
        
        priceTextField.title = "Price"
        priceTextField.delegate = self
        priceTextField.textField.keyboardType = UIKeyboardType.numberPad
        
        brandTextField.title = "brand"
        brandTextField.delegate = self
        
        cpuTextField.title = "CPU"
        cpuTextField.delegate = self
        
        ramsTextField.title = "RAMs"
        ramsTextField.delegate = self
        ramsTextField.textField.keyboardType = UIKeyboardType.numberPad
        
        modelNumberTextField.title = "Model Number"
        modelNumberTextField.delegate = self
    }
    
    func addView(newView: UIView, under topView: UIView) {
        self.contentView.addSubview(newView)
        newView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(10)
            make.height.equalTo(editingTextFieldsHeight)
            make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        }
    }
    
}

//MARK: - EditingTextFieldDelegate
extension CreateComputerViewController: EditingTextFieldDelegate {
    
    @objc
    func stopEditing() {
        nameTextField.endEditing(true)
        priceTextField.endEditing(true)
        brandTextField.endEditing(true)
        cpuTextField.endEditing(true)
        ramsTextField.endEditing(true)
        modelNumberTextField.endEditing(true)
    }
    
    func textFieldWillBeginEditing() {
        let y: CGFloat = 70
        if nameTextField.textField.isEditing {
            adjustPositions(with: y)
        }
        if priceTextField.textField.isEditing {
            adjustPositions(with: y + 50)
        }
        if brandTextField.textField.isEditing {
            adjustPositions(with: y + 100)
        }
        if cpuTextField.textField.isEditing {
            adjustPositions(with: y + 150)
        }
        if ramsTextField.textField.isEditing {
            adjustPositions(with: y + 200)
        }
        if modelNumberTextField.textField.isEditing {
            adjustPositions(with: y + 250)
        }
    }
    
    func textFieldWillEndEditing() {
        if nameTextField.textField.isEditing ||
            priceTextField.textField.isEditing ||
            brandTextField.textField.isEditing ||
            cpuTextField.textField.isEditing ||
            ramsTextField.textField.isEditing ||
            modelNumberTextField.textField.isEditing {
            return
        }
        UIView.animate(withDuration: 0.25) {
            self.selectImageButton.snp.updateConstraints { (make) in
                make.top.equalTo(self.contentView).offset(8)
            }
            self.view.layoutIfNeeded()
        }
        
    }
    
    func adjustPositions(with offset: CGFloat) {
        UIView.animate(withDuration: 0.25) {
            self.selectImageButton.snp.updateConstraints { (make) in
                make.top.equalTo(self.contentView).offset(-offset)
            }
            self.view.layoutIfNeeded()
        }
    }
    
}

//MARK: - Buttons Handlers
extension CreateComputerViewController {
    @objc
    func selectImage() {
        let alert = UIAlertController(title: "Choose Image", message: "Select where to import image from", preferredStyle: .actionSheet)
        
        //select from camera
        alert.addAction(UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.default, handler: { (action) in
            print("Choose from camera")
            self.takePhoto()
        }))
        
        //        select from photos
        alert.addAction(UIAlertAction(title: "From Library", style: UIAlertActionStyle.default, handler: { (action) in
            print("Choose from library")
            self.pickFromLibrary()
        }))
        
        //cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
            print("Cancel")
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func createComputer() {
        if nameTextField.textField.text == "" ||
            priceTextField.textField.text == "" ||
            brandTextField.textField.text == "" ||
            cpuTextField.textField.text == "" ||
            ramsTextField.textField.text == "" ||
            modelNumberTextField.textField.text == "" {
            let alert = UIAlertController(title: "Problem", message: "All Fields Are Required", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        if self.computer != nil {
            updateComputer()
            return
        }
        let computer = Computer()
        computer.name = nameTextField.textField.text!
        computer.price = Float(priceTextField.textField.text!)
        computer.brand = brandTextField.textField.text!
        computer.cpu = cpuTextField.textField.text!
        computer.rams = Int(ramsTextField.textField.text!)
        computer.modelNumber = modelNumberTextField.textField.text!
        
        
        APIServices.shared.createComputer(from: computer) { (error) in
            if let error = error {
                print("\(error)")
            } else {
                print("Computer Created Successfully")
            }
        }
        self.navigationController?.popViewController(animated: true)
        let mainViewController = self.navigationController?.visibleViewController as! MainViewController
        mainViewController.computersViewController.curPage = 1
        mainViewController.computersViewController.keepFetching = true
        mainViewController.computersViewController.fetchData(at: 1, searchString: nil, filters: nil)
        self.computer = nil
    }
    
    func updateComputer() {
        computer.name = nameTextField.textField.text!
        computer.price = Float(priceTextField.textField.text!)
        computer.brand = brandTextField.textField.text!
        computer.cpu = cpuTextField.textField.text!
        computer.rams = Int(ramsTextField.textField.text!)
        computer.modelNumber = modelNumberTextField.textField.text!
        APIServices.shared.updateComputer(computer: computer) { (error) in
            if let error = error {
                print("\(error)")
            } else {
                print("Computer Updated Successfully")
            }
        }
        self.navigationController?.popViewController(animated: true)
        let computerViewController = self.navigationController?.visibleViewController as! ComputerViewController
        computerViewController.computer = self.computer
        self.computer = nil
    }
    
    @objc func clear() {
        selectImageButton.setImage(UIImage(named: "image_placeholder"), for: .normal)
        nameTextField.textField.text = ""
        priceTextField.textField.text = ""
        brandTextField.textField.text = ""
        cpuTextField.textField.text = ""
        ramsTextField.textField.text = ""
        modelNumberTextField.textField.text = ""
    }
}

//MARK: - Image Picking Handlers
extension CreateComputerViewController {
    
    
    func takePhoto() {
        print("Can't test from simulator :(")
    }
    
    func pickFromLibrary() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectImageButton.setImage(image, for: .normal)
        } else {
            print("Error")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

