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
        var productView = ProductDetailView()
        return productView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let productViewModel = ProductViewModel(product: product!)
        
        productViewModel.configure(productView)
        
        self.view.addSubview(productView)
    }
}
