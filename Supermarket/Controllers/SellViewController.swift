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
        TableViewCell.register(inTableView: sellTableView)
        self.title = String.titleSell
        categoryList.append(String.allCategory)
        for category in Category.allValues {
            categoryList.append(category.rawValue)
        }
        categorySelected = String.allCategory
        selectCategory()
        configureMenu(navigationController: self.navigationController!, items: categoryList,
                      navigationItem: self.navigationItem).didSelectItemAtIndexHandler = {(indexPath: Int) -> Void in
                        self.categorySelected = self.categoryList[indexPath]
                        self.selectCategory()
                        self.sellTableView.reloadData()
        }
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
    
   
}

extension SellViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayProduct.count != 0 {
            return arrayProduct.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  let cell = self.sellTableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell
        {
            cell.configureWithItem(product: arrayProduct[indexPath.row], indexPatch: indexPath.row,
                                   cell: cell, transactionType: Transaction.Sell.rawValue, isCart: false)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recivedId = arrayProduct[indexPath.row].ID
        self.performSegue(withIdentifier: "detailSellSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let recivedId = recivedId else { return }
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.recivedId = recivedId
        detailViewController.transactionType = Transaction.Sell.rawValue
    }
    
}



