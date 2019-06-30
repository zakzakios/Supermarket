//
//  DetailViewController.swift
//  Supermarket
//
//  Created by Алексей Лаухин on 25.06.2019.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import GMStepper


class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var detailStepper: GMStepper!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    
    let dataBase = DBManager.sharedInstance
    var recivedId: Int?
    var transactionType: String?
    var activeField: UITextField?
    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat!
    var categoryList: [String] = []
    var productModel: ProductModel?
    var selected: String? {
        return UserDefaults.standard.string(forKey: "selected") ?? ""
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTextField.delegate = self
        titleTextField.delegate = self
        costTextField.delegate = self
        self.title = String.titleDetail
        self.hideKeyboardWhenTappedAround()
        addNavigationButton(title: String.titleEditButton, action: #selector(editTapped))
        prepareData()
        initView(productModel: productModel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(returnTextView(gesture:))))
        scrollView.delegate = self
        scrollViewDidScroll(scrollView)
    }
    
    func prepareData() {
        if let recivedId = recivedId {
            productModel = dataBase.getProductById(id: recivedId)
        }
        for category in Category.allValues {
            categoryList.append(category.rawValue)
        }
    }
    
    func addNavigationButton(title: String, action: Selector?) {
        let navigationButton = UIBarButtonItem(title: title, style: .plain, target: self, action: action)
        self.navigationItem.rightBarButtonItem = navigationButton
    }
    
    func initView(productModel: ProductModel?) {
        if let cost = productModel?.cost, let url = productModel?.url, let id = productModel?.ID,
            let category = productModel?.category, let title = productModel?.title {
            categoryTextField.text = category
            titleTextField.text = title
            costTextField.text = "$" + String(cost)
            previewImage.downloaded(from: url)
            
            if let transactionType = transactionType {
                if let countCart = dataBase.getCountToId(productId: id, transactionType: transactionType) {
                    detailStepper.value = Double(countCart)
                } else {
                    self.detailStepper.value = 0
                }
            }
            detailStepper.labelFont = UIFont(name: String.fontStepper, size: 14.0)!
            detailStepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
    
    @objc func stepperValueChanged(stepper: GMStepper) {
        guard let id = productModel?.ID, let transactionType = transactionType else { return }
        if dataBase.getCartById(productId: id, transactionType: transactionType) != nil {
            dataBase.updateCountCart(productId: id, transactionType: transactionType, count: Int(stepper.value))
        } else {
            let cartModel = CartModel()
            cartModel.productId = id
            cartModel.count = Int(stepper.value)
            cartModel.transactionType = transactionType
            dataBase.addProductToCart(object: cartModel)
        }
    }
    
    
    @objc func returnTextView(gesture: UIGestureRecognizer) {
        guard activeField != nil else {
            return
        }
        
        activeField?.resignFirstResponder()
        activeField = nil
    }
    
   @objc func editTapped(){
        isEditableView(editable: true, borderStyle: .roundedRect)
        categoryTextField.addTarget(self, action: #selector(chooseCategory), for: .editingDidBegin)
        costTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        addNavigationButton(title: String.titleSaveButton, action: #selector(saveTapped))
    }
    
    @objc func saveTapped(){
        isEditableView(editable: false, borderStyle: .none)
        addNavigationButton(title: String.titleEditButton, action: #selector(editTapped))
        let delCharSet = CharacterSet(charactersIn: "$")
        if let category = categoryTextField.text, let title = titleTextField.text,
            let cost = Double(costTextField.text!.trimmingCharacters(in: delCharSet)), let id = recivedId {
               dataBase.updateProduct(id: id, category: category, title: title, cost: cost)
        }
    }
    
    func isEditableView(editable: Bool, borderStyle: UITextField.BorderStyle) {
        categoryTextField.isUserInteractionEnabled = editable
        categoryTextField.borderStyle = borderStyle
        categoryTextField.returnKeyType = UIReturnKeyType.next
        titleTextField.isUserInteractionEnabled = editable
        titleTextField.borderStyle = borderStyle
        titleTextField.returnKeyType = UIReturnKeyType.next
        costTextField.isUserInteractionEnabled = editable
        costTextField.borderStyle = borderStyle
        costTextField.returnKeyType = UIReturnKeyType.done
    }
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        if let amountString = costTextField.text?.currencyInputFormatting() {
            costTextField.text = amountString
        }
    }
    
    @objc func chooseCategory() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: String.titleChoceCategory, message: "", preferredStyle: UIAlertController.Style.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: String.titleSaveButton, style: .default, handler: { action in
            guard let selectedCategory = self.selected else { return }
            self.categoryTextField.text = selectedCategory
        }))

        editRadiusAlert.addAction(UIAlertAction(title: String.titleCancelButton, style: .cancel, handler: nil))
        self.present(editRadiusAlert, animated: true)
    }
    
}

extension DetailViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        lastOffset = self.scrollView.contentOffset
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField?.resignFirstResponder()
        activeField = nil
        
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    
}

extension DetailViewController {
  @objc  func keyboardWillShow(notification: NSNotification) {
        if keyboardHeight != nil {
            return
        }
        
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
        
            UIView.animate(withDuration: 0.3, animations: {
                self.constraintContentHeight.constant += self.keyboardHeight
            })
        
            let distanceToBottom = self.scrollView.frame.size.height - (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
            let collapseSpace = keyboardHeight - distanceToBottom
            
            if collapseSpace < 0 {
                return
            }
            
        
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: collapseSpace + 10)
            })
        }
    }
    
 @objc   func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            if let keyboardHeight = self.keyboardHeight {
                 self.constraintContentHeight.constant -= keyboardHeight
                 self.scrollView.contentOffset = self.lastOffset
            }
        }
        
        keyboardHeight = nil
    }
}

extension DetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaults.standard.set(categoryList[row], forKey: "selected")
    }
}

