//
//  Extension.swift
//  Supermarket
//
//  Created by Алексей Лаухин on 29.06.2019.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

class Extension {
    func createMockData() {
        
        if (DBManager.sharedInstance.getProductsFromDB().isEmpty) {
            let washingPowder = ProductModel()
            createProduct(product: washingPowder, id: 0, title: "Стиральный порошок Tide", cost: 33.00, url: "https://static.onlinetrade.ru/img/items/b/stiralniy_poroshok_tide_alpiyskaya_svegest_6kg_137760_1.jpg", category: Category.ForHome.rawValue)
            let cleanser = ProductModel()
            createProduct(product: cleanser, id: 1, title: "Мистер Пропер для полов и стен ", cost: 22.00, url: "https://res.cloudinary.com/pxty/image/upload/c_scale,f_auto,q_60/v1/joltc2/~/media/growing-families-version1/gf-ru/icnx/products/mr_proper/5413149070066.png?la=ru-ru&v=1", category: Category.ForHome.rawValue)
            let coffeeMachine = ProductModel()
            createProduct(product: coffeeMachine, id: 2, title: "Кофемашина DeLonghi ECAM350", cost: 70.00, url: "https://dl-rus.ru/upload/img_cache/a3/cdm/iblock/836/kofemashina_delonghi_ecam350.75.s_1.png", category: Category.Appliances.rawValue)
            let electricKettle = ProductModel()
            createProduct(product: electricKettle, id: 3, title: "Электрочайник Tefal Glass", cost: 90.00, url: "https://static.eldorado.ru/photos/71/713/855/83/new_71385583_l_1542055263.jpeg/resize/380x245/", category: Category.Appliances.rawValue)
            let multiCooker = ProductModel()
            createProduct(product: multiCooker, id: 4, title: "Мультиварка Redmond", cost: 100.00, url: "https://irecommend.ru/sites/default/files/product-images/106713/ff69806b51cc951f51d52da998804814.png", category: Category.Appliances.rawValue)
            let toaster = ProductModel()
            createProduct(product: toaster, id: 5, title: "Тостер Vitek", cost: 120.00, url: "https://cdn1.technopark.ru/technopark/photos_resized/product/600_600/153261/1_153261.jpg", category: Category.Appliances.rawValue)
            let chocolateRitter = ProductModel()
            createProduct(product: chocolateRitter, id: 6, title: "Шоколад Ritter Sport ", cost: 12.00, url: "https://irecommend.img.c3.r-99.com/sites/default/files/imagecache/300o/product-images/10297/Xr8H0wwSOiOosLQQsEg.png", category: Category.Food.rawValue)
            let chocolateKitKat = ProductModel()
            createProduct(product: chocolateKitKat, id: 7, title: "Шоколад Nestle Kit Kat", cost: 15.00, url: "https://fix-price.ru/upload/resize_cache/iblock/e45/330_330_0/e45ce7de721c6e392a3563aecfc8c3d9.png", category: Category.Food.rawValue)
            let tShirtRed = ProductModel()
            createProduct(product: tShirtRed, id: 8, title: "Футболка red", cost: 100.00, url: "https://images.ua.prom.st/370758636_w640_h640_futbolka-muzhskaya-krasnaya.jpg", category: Category.Clothing.rawValue)
            let tShirtBlue = ProductModel()
            createProduct(product: tShirtBlue, id: 9, title: "Футболка blue", cost: 10.00, url: "https://magazin-tolstovok.ru/image/cache//catalog/image/futbolki/mujskie/muzhskaja-sinjaja-futbolka-600x900-500x500.png", category: Category.Clothing.rawValue)
            let washingPowder1 = ProductModel()
            createProduct(product: washingPowder1, id: 10, title: "Стиральный порошок Tide #2", cost: 33.00, url: "https://static.onlinetrade.ru/img/items/b/stiralniy_poroshok_tide_alpiyskaya_svegest_6kg_137760_1.jpg", category: Category.ForHome.rawValue)
            let cleanser1 = ProductModel()
            createProduct(product: cleanser1, id: 11, title: "Мистер Пропер для полов и стен #2", cost: 22.00, url: "https://res.cloudinary.com/pxty/image/upload/c_scale,f_auto,q_60/v1/joltc2/~/media/growing-families-version1/gf-ru/icnx/products/mr_proper/5413149070066.png?la=ru-ru&v=1", category: Category.ForHome.rawValue)
            let coffeeMachine1 = ProductModel()
            createProduct(product: coffeeMachine1, id: 12, title: "Кофемашина DeLonghi ECAM350 #2", cost: 70.00, url: "https://dl-rus.ru/upload/img_cache/a3/cdm/iblock/836/kofemashina_delonghi_ecam350.75.s_1.png", category: Category.Appliances.rawValue)
            let electricKettle1 = ProductModel()
            createProduct(product: electricKettle1, id: 13, title: "Электрочайник Tefal Glass #2", cost: 90.00, url: "https://static.eldorado.ru/photos/71/713/855/83/new_71385583_l_1542055263.jpeg/resize/380x245/", category: Category.Appliances.rawValue)
            let multiCooker1 = ProductModel()
            createProduct(product: multiCooker1, id: 14, title: "Мультиварка Redmond #2", cost: 100.00, url: "https://irecommend.ru/sites/default/files/product-images/106713/ff69806b51cc951f51d52da998804814.png", category: Category.Appliances.rawValue)
            let toaster1 = ProductModel()
            createProduct(product: toaster1, id: 15, title: "Тостер Vitek #2", cost: 120.00, url: "https://cdn1.technopark.ru/technopark/photos_resized/product/600_600/153261/1_153261.jpg", category: Category.Appliances.rawValue)
            let chocolateRitter1 = ProductModel()
            createProduct(product: chocolateRitter1, id: 16, title: "Шоколад Ritter Sport #2", cost: 12.00, url: "https://irecommend.img.c3.r-99.com/sites/default/files/imagecache/300o/product-images/10297/Xr8H0wwSOiOosLQQsEg.png", category: Category.Food.rawValue)
            let chocolateKitKat1 = ProductModel()
            createProduct(product: chocolateKitKat1, id: 17, title: "Шоколад Nestle Kit Kat #2", cost: 15.00, url: "https://fix-price.ru/upload/resize_cache/iblock/e45/330_330_0/e45ce7de721c6e392a3563aecfc8c3d9.png", category: Category.Food.rawValue)
            let tShirtRed1 = ProductModel()
            createProduct(product: tShirtRed1, id: 18, title: "Футболка red #2", cost: 555.00, url: "https://images.ua.prom.st/370758636_w640_h640_futbolka-muzhskaya-krasnaya.jpg", category: Category.Clothing.rawValue)
            let tShirtBlue1 = ProductModel()
            createProduct(product: tShirtBlue1, id: 19, title: "Футболка blue #2", cost: 55.00, url: "https://magazin-tolstovok.ru/image/cache//catalog/image/futbolki/mujskie/muzhskaja-sinjaja-futbolka-600x900-500x500.png", category: Category.Clothing.rawValue)
        }
    }
    
    func createProduct(product: ProductModel, id: Int, title: String, cost: Double, url: String, category: String ) {
        product.ID = id
        product.title = title
        product.cost = cost
        product.url = url
        product.category = category
        DBManager.sharedInstance.addProduct(object: product)
    }
}

private var __maxLengths = [UITextField: Int]()

extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let lengths = __maxLengths[self] else {
                return 150 
            }
            return lengths
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let text = textField.text
        textField.text = text?.safelyLimitedTo(length: maxLength)
    }
}


extension String {
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

extension String {
    
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
}

extension String {
    
    // Constants
    public static let titleBuy = "Купить"
    public static let titleSell = "Продать"
    public static let titleCart = "Корзина"
    public static let titleDetail = "Подробнее"
    public static let allCategory = "Все категории"
    public static let titleEditButton = "Изменить"
    public static let titleSaveButton = "Сохранить"
    public static let titleCancelButton = "Отмена"
    public static let titleChoceCategory = "Выберите категорию"
    public static let fontStepper = "AvenirNext-Bold"
    
}
