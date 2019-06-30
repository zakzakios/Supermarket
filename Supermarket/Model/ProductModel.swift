//
//  ProductModel.swift
//  Supermarket
//
//  Created by Алексей Лаухин on 26.06.2019.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation
import RealmSwift

class ProductModel: Object {
   @objc dynamic var ID = 0
   @objc dynamic var title = ""
   @objc dynamic var cost = 25.00
   @objc dynamic var url = ""
   @objc dynamic var category = Category.Food.rawValue
    var categoryEnum: Category {
        get {
            return Category(rawValue: category)!
        }
        set {
            category = newValue.rawValue
        }
    }
    
    
   override static func primaryKey() -> String? {
        return "ID"
    }
}

enum Category: String {
    case ForHome = "Для дома"
    case Appliances = "Бытовая техника"
    case Food = "Еда"
    case Clothing = "Одежда"
    
    static let allValues = [ForHome, Appliances, Food, Clothing]
    
    init?(id : Int) {
        switch id {
        case 1: self = .ForHome
        case 2: self = .Appliances
        case 3: self = .Food
        case 4: self = .Clothing
        default: return nil
        }
    }
}
