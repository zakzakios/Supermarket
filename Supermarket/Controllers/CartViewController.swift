//
//  CartViewController.swift
//  Supermarket
//
//  Created by Алексей Лаухин on 28.06.2019.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import GMStepper
import RealmSwift
import BTNavigationDropdownMenu

class CartViewController: UIViewController {
    
    var arrayCart: [CartModel] = []
    var arrayCartTransaction: [CartModel] = []
    var transactionList: [String] = []
    var transactionSelected: String?
    let dataBase = DBManager.sharedInstance
    @IBOutlet weak var cartTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartTableView.dataSource = self
        cartTableView.delegate = self
        self.title = String.titleCart
        
        for transaction in Transaction.allValues {
            transactionList.append(transaction.rawValue)
        }
        transactionSelected = Transaction.Buy.rawValue
        selectTransaction()
        configureMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        selectTransaction()
        cartTableView.reloadData()
    }
    
    private func selectTransaction() {
        if let transactionSelected = self.transactionSelected {
            self.arrayCartTransaction = Array(dataBase.getProductsByTransactionType(transactionType: transactionSelected))
            self.arrayCart = self.arrayCartTransaction
        }
    }
    
    private func configureMenu() {
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: BTTitle.title(transactionList[0]), items: transactionList)
        menuView.arrowTintColor = .black
        menuView.arrowPadding = 15
        menuView.cellBackgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        menuView.cellSelectionColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        menuView.shouldKeepSelectedCellColor = true
        menuView.cellTextLabelFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
        menuView.navigationBarTitleFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> Void in
            self.transactionSelected = self.transactionList[indexPath]
            self.selectTransaction()
            self.cartTableView.reloadData()
        }
        self.navigationItem.titleView = menuView
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayCart.count != 0 {
        return arrayCart.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.cartTableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath as IndexPath) as! CartCell
        configureCell(cell: cell, for: indexPath)
        return cell
    }
    
    private func configureCell(cell: CartCell, for indexPatch: IndexPath) {
        let product = dataBase.getProductById(id: arrayCart[indexPatch.row].productId)
         if let product = product, let transactionSelected = transactionSelected {
            cell.titleLabel.text = product.title
            cell.costLabel.text = "$" + String(product.cost)
            cell.previewImage.downloaded(from: product.url)
            
            cell.stepper.labelFont = UIFont(name: String.fontStepper, size: 14.0)!
            if let countCart = dataBase.getCountToId(productId: product.ID, transactionType: transactionSelected) {
                cell.stepper.value = Double(countCart)
            } else {
                cell.stepper.value = 0
            }
        }
    }
    
}

class CartCell: UITableViewCell {
    @IBOutlet weak var stepper: GMStepper!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
}
