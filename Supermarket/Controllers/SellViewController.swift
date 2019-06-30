//
//  SellViewController.swift
//  Supermarket
//
//  Created by Алексей Лаухин on 24.06.2019.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import GMStepper
import RealmSwift
import BTNavigationDropdownMenu

class SellViewController: UIViewController {
    
    var arrayProduct: [ProductModel] = []
    var arrayProductCategory: [ProductModel] = []
    var recivedId: Int?
    var categoryList: [String] = []
    var categorySelected: String?
    let dataBase = DBManager.sharedInstance
    @IBOutlet weak var sellTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sellTableView.dataSource = self
        sellTableView.delegate = self
        self.title = String.titleSell
        
        categoryList.append(String.allCategory)
        for category in Category.allValues {
            categoryList.append(category.rawValue)
        }
        categorySelected = String.allCategory
        selectCategory()
        configureMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        selectCategory()
        sellTableView.reloadData()
    }
    
    func selectCategory() {
        if let categorySelected = categorySelected {
              if categorySelected == String.allCategory {
                  self.arrayProduct = Array(dataBase.getProductsFromDB())
              } else {
                  self.arrayProductCategory = Array(dataBase.getProductsByCategory(category: categorySelected))
                  self.arrayProduct = self.arrayProductCategory
            }
        }
    }
    
    private func configureMenu() {
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: BTTitle.title(categoryList[0]), items: categoryList)
        menuView.arrowTintColor = .black
        menuView.arrowPadding = 15
        menuView.cellBackgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        menuView.cellSelectionColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        menuView.shouldKeepSelectedCellColor = true
        menuView.cellTextLabelFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
        menuView.navigationBarTitleFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> Void in
            self.categorySelected = self.categoryList[indexPath]
            self.selectCategory()
            self.sellTableView.reloadData()
        }
        self.navigationItem.titleView = menuView
    }
}

extension SellViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayProduct.count != 0 {
            return arrayProduct.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.sellTableView.dequeueReusableCell(withIdentifier: "SellCell", for: indexPath as IndexPath) as! SellCell
        configureCell(cell: cell, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recivedId = arrayProduct[indexPath.row].ID
        self.performSegue(withIdentifier: "detailSellSegue", sender: self)
    }
    
    private func configureCell(cell: SellCell, for indexPatch: IndexPath) {
        let product = arrayProduct[indexPatch.row]
        cell.titleLabel.text = product.title
        cell.costLabel.text = "$" + String(product.cost)
        let tag = indexPatch.row
        cell.tag = tag
        if cell.tag == tag {
            cell.previewImage.downloaded(from: product.url)
        }
        
        cell.stepper.labelFont = UIFont(name: String.fontStepper, size: 14.0)!
        cell.stepper.tag = product.ID
        if let countCart = dataBase.getCountToId(productId: product.ID, transactionType: Transaction.Sell.rawValue) {
            cell.stepper.value = Double(countCart)
        } else {
            cell.stepper.value = 0
        }
        cell.stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let recivedId = recivedId else { return }
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.recivedId = recivedId
        detailViewController.transactionType = Transaction.Sell.rawValue
    }
    
    @objc func stepperValueChanged(stepper: GMStepper) {
        let id = stepper.tag
        if dataBase.getCartById(productId: id, transactionType: Transaction.Sell.rawValue) != nil {
            dataBase.updateCountCart(productId: id, transactionType: Transaction.Sell.rawValue, count: Int(stepper.value))
        } else {
            let cartModel = CartModel()
            cartModel.productId = id
            cartModel.count = Int(stepper.value)
            cartModel.transactionEnum = .Sell
            dataBase.addProductToCart(object: cartModel)
        }
    }
    
}

class SellCell: UITableViewCell {
    @IBOutlet weak var stepper: GMStepper!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
}


