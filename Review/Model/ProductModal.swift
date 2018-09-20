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
}
