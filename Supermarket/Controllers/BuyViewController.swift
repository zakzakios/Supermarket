//
//  BuyViewController.swift
//  Supermarket
//
//  Created by Алексей Лаухин on 24.06.2019.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import GMStepper
import RealmSwift

class BuyViewController: UIViewController {
    
    var arrayProduct: [ProductModel] = []
    var recivedId: Int?
    let dataBase = DBManager.sharedInstance
    @IBOutlet weak var buyTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableViewCell.register(inTableView: buyTableView)
        buyTableView.dataSource = self
        buyTableView.delegate = self
        self.title = String.titleBuy
        createMockData()
        arrayProduct = Array(dataBase.getProductsFromDB())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        buyTableView.reloadData()
    }
    
}

extension BuyViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayProduct.count != 0 {
            return arrayProduct.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if  let cell = self.buyTableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell
         {
            cell.configureWithItem(product: arrayProduct[indexPath.row], indexPatch: indexPath.row,
                                   cell: cell, transactionType: Transaction.Buy.rawValue, isCart: false)
          return cell
          }
        return UITableViewCell()
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recivedId = arrayProduct[indexPath.row].ID
        self.performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let recivedId = recivedId else { return }
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.recivedId = recivedId
        detailViewController.transactionType = Transaction.Buy.rawValue
    }
    
}


func createMockData() {
    let extansion = Extension()
    extansion.createMockData()
}

