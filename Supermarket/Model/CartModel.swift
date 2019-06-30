//
//  CartModel.swift
//  Supermarket
//
//  Created by Алексей Лаухин on 26.06.2019.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation
import RealmSwift

class CartModel: Object {
    @objc dynamic var productId = 0
    @objc dynamic var count = 0
    @objc dynamic var transactionType = Transaction.Buy.rawValue
    
    var transactionEnum: Transaction {
        get {
            return Transaction(rawValue: transactionType)!
        }
        set {
            transactionType = newValue.rawValue
        }
    }
    
}

enum Transaction: String {
    case Buy = "Куплено"
    case Sell = "Продано"
    
    static let allValues = [Buy, Sell]
}
