//
//  ProductModal.swift
//  Review
//
//  Created by Badarinath Venkatnarayansetty on 9/20/18.
//  Copyright © 2018 Badrinath. All rights reserved.
//

import Foundation

protocol ProductModalDelegate:class {
    func reloadTableView()
}

class ProductModal : NSObject {
    
    @objc dynamic var productData:[Product]  = []
    
    weak var delegate:ProductModalDelegate?
    
    var observers = [NSKeyValueObservation]()
    
    override init() {
        super.init()
        observeModel()
    }
    
    func observeModel() {
        self.observers = [
            self.observe(\.productData, options: [.new , .old]) { [weak self] (model, change) in
                self?.delegate?.reloadTableView()
            }
        ]
    }
    
    func fetchProductData() {
        
        //if products are available in NSUSerDefaults, assing it to the productData Array to populate
        let persistence = PersistenceHelper.shared
        self.productData = persistence.fetchProductsFromCache()
        
        if self.productData.count  == 0  {
            API.getProductData { (result) in
                //Assign the result , if products are not available in NSUserDefaults
                guard let _ = persistence.defaults.object(forKey: "starred") as? NSData else {
                    self.productData = result
                    persistence.updateUserDefaults(for: self.productData)
                    return
                }
            }
        }
    }
}
