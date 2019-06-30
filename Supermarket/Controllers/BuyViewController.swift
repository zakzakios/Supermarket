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
        let cell = self.buyTableView.dequeueReusableCell(withIdentifier: "BuyCell", for: indexPath as IndexPath) as! BuyCell
        configureCell(cell: cell, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recivedId = arrayProduct[indexPath.row].ID
        self.performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
    private func configureCell(cell: BuyCell, for indexPatch: IndexPath) {
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
        if let countCart = dataBase.getCountToId(productId: product.ID, transactionType: Transaction.Buy.rawValue) {
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
        detailViewController.transactionType = Transaction.Buy.rawValue
    }
    
    @objc func stepperValueChanged(stepper: GMStepper) {
        let id = stepper.tag
        if dataBase.getCartById(productId: id, transactionType: Transaction.Buy.rawValue) != nil {
            dataBase.updateCountCart(productId: id, transactionType: Transaction.Buy.rawValue, count: Int(stepper.value))
        } else {
            let cartModel = CartModel()
            cartModel.productId = id
            cartModel.count = Int(stepper.value)
            cartModel.transactionEnum = .Buy
            dataBase.addProductToCart(object: cartModel)
        }
    }
    
}

class BuyCell: UITableViewCell {
    @IBOutlet weak var stepper: GMStepper!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
}


func createMockData() {
    let extansion = Extension()
    extansion.createMockData()
}

