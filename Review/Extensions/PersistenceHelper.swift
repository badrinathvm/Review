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
    
    func fetchProducts() -> [Product] {
        guard let products = delegate?.getProductList() else { return [] }
        return products
    }
    
}
