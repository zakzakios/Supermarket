//
//  DBManager.swift
//  Supermarket
//
//  Created by Алексей Лаухин on 26.06.2019.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import RealmSwift

class DBManager {
    
    private var   database:Realm
    static let   sharedInstance = DBManager()
    
    private init() {
        database = try! Realm()
    }
    
    func getProductsFromDB() ->   Results<ProductModel> {
        let results = database.objects(ProductModel.self)
        return results
    }
    
    func getProductById(id: Int) -> ProductModel? {
        let results = database.objects(ProductModel.self).filter("ID == \(id)").first
        return results
    }
    
    func getCartById(productId: Int, transactionType: String) -> CartModel? {
        let results = database.objects(CartModel.self).filter("productId = %@", productId).filter("transactionType = %@", transactionType).first
        return results
    }
    
    func getProductsByCategory(category: String) -> Results<ProductModel> {
        let results = database.objects(ProductModel.self).filter("category = %@", category)
        return results
    }
    
    func getProductsByTransactionType(transactionType: String) -> Results<CartModel> {
        let results = database.objects(CartModel.self).filter("transactionType = %@", transactionType).filter("count > %@", 0)
        return results
    }
    
    func getCountToId(productId: Int, transactionType: String) -> Int? {
        let countCart = database.objects(CartModel.self).filter("productId = %@", productId).filter("transactionType = %@", transactionType).first
        return countCart?.count
    }
    
    func updateProduct(id: Int, category: String, title: String, cost: Double) {
        let results = database.objects(ProductModel.self).filter("ID == \(id)")
        if let product = results.first {
        try!   database.write {
            product.category = category
            product.title = title
            product.cost = cost
        }
        }
    }
    
    func updateCountCart(productId: Int, transactionType: String, count: Int) {
        let results = database.objects(CartModel.self).filter("productId = %@", productId).filter("transactionType = %@", transactionType)
        if let cart = results.first {
            try!   database.write {
               cart.count = count
            }
        }
    }
    
    func addProduct(object: ProductModel)   {
        try! database.write {
            database.add(object)
        }
    }
    
    func addProductToCart(object: CartModel)   {
        try! database.write {
            database.add(object)
        }
    }
    
    func removeProduct(object: ProductModel)   {
        try!   database.write {
            database.delete(object)
        }
    }
    
    func removeProductFromCart(id: Int)   {
        let result = database.objects(CartModel.self).filter("ID == \(id)")
        if let productCart = result.first {
        try!   database.write {
            database.delete(productCart)
        }
        }
    }
    
}
