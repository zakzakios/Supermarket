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
        TableViewCell.register(inTableView: cartTableView)
        cartTableView.dataSource = self
        cartTableView.delegate = self
        self.title = String.titleCart
        for transaction in Transaction.allValues {
            transactionList.append(transaction.rawValue)
        }
        transactionSelected = Transaction.Buy.rawValue
        selectTransaction()
        configureMenu(navigationController: self.navigationController!, items: transactionList,
                      navigationItem: self.navigationItem).didSelectItemAtIndexHandler = {(indexPath: Int) -> Void in
                        self.transactionSelected = self.transactionList[indexPath]
                        self.selectTransaction()
                        self.cartTableView.reloadData()
        }
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
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayCart.count != 0 {
        return arrayCart.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  let cell = self.cartTableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell
        {
            guard let product = dataBase.getProductById(id: arrayCart[indexPath.row].productId),
                let transactionSelected = transactionSelected else { return UITableViewCell() }
            cell.configureWithItem(product: product, indexPatch: indexPath.row, cell: cell,
                                   transactionType: transactionSelected, isCart: true)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataBase.removeProductFromCart(productId: arrayCart[indexPath.row].productId, transactionType: arrayCart[indexPath.row].transactionType)
            arrayCart.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
