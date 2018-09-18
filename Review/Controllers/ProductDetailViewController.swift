//
//  ProductDetailViewController.swift
//  Review
//
//  Created by Badrinath on 9/15/18.
//  Copyright © 2018 Badrinath. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    var product: Product?
    
    lazy var productView:ProductDetailView = {
        var productView = ProductDetailView(product: product)
        return productView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(productView)
        // Do any additional setup after loading the view.
    }
}
