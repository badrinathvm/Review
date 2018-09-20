//
//  PersistenceHelper.swift
//  Review
//
//  Created by Badarinath Venkatnarayansetty on 9/19/18.
//  Copyright © 2018 Badrinath. All rights reserved.
//

import Foundation

protocol PersistenceDelegate: class {
    func updateCache(productList: [Product])
    func getProductList() -> [Product]
}

class PersistenceHelper {
    
    weak var delegate:PersistenceDelegate?
    
    let defaults = UserDefaults.standard

    func updateCache(for products: [Product]) {
        delegate?.updateCache(productList: products)
    }
    
    func fetchProductsFromCache() -> [Product] {
        guard let products = delegate?.getProductList() else { return [] }
        return products
    }
    
    func updateUserDefaults(for products: [Product]) {
        let data = NSKeyedArchiver.archivedData(withRootObject: products)
        defaults.set(data, forKey: "starred")
    }
    
    func fetchFromUserDefaults()  -> [Product] {
        guard let data = self.defaults.object(forKey: "starred") as? NSData else { return [] }
        
        guard let productList = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? [Product] else  { return [] }
        
        return productList
    }
    
}
