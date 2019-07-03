//
//  TableViewCell.swift
//  Supermarket
//
//  Created by Алексей Лаухин on 03.07.2019.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import GMStepper

class TableViewCell: UITableViewCell {
    
    class var identifier: String {
        return String(describing: self)
    }
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static func register(inTableView tableView: UITableView) {
        tableView.register(self.nib, forCellReuseIdentifier: self.identifier)
    }
    let dataBase = DBManager.sharedInstance
    var transactionTypes: String?
    
    @IBOutlet weak var stepper: GMStepper!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    func configureWithItem(product: ProductModel, indexPatch: Int, cell: TableViewCell, transactionType: String, isCart: Bool) {
        titleLabel.text = product.title
        costLabel.text = "$" + String(product.cost)
        transactionTypes = transactionType
        let tag = indexPatch
        cell.tag = tag
        if cell.tag == tag {
            cell.previewImage.downloaded(from: product.url)
        }
        cell.stepper.labelFont = UIFont(name: String.fontStepper, size: 14.0)!
        cell.stepper.tag = product.ID
        
        if let countCart = dataBase.getCountToId(productId: product.ID, transactionType: transactionType) {
            cell.stepper.value = Double(countCart)
        } else {
            cell.stepper.value = 0
        }
        if isCart {
            cell.stepper.isUserInteractionEnabled = false
        } else {
        cell.stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        }
    }
    
    @objc func stepperValueChanged(stepper: GMStepper) {
        let id = stepper.tag
        guard let transactionTypes = transactionTypes else { return }
        if dataBase.getCartById(productId: id, transactionType: transactionTypes) != nil {
            dataBase.updateCountCart(productId: id, transactionType: transactionTypes, count: Int(stepper.value))
        } else {
            let cartModel = CartModel()
            cartModel.productId = id
            cartModel.count = Int(stepper.value)
            cartModel.transactionType = transactionTypes
            dataBase.addProductToCart(object: cartModel)
        }
    }
    
}
