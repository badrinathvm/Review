//
//  ProductDetailViewController.swift
//  Review
//
//  Created by Badrinath on 9/15/18.
//  Copyright © 2018 Badrinath. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
        
    var viewModel: ProductViewModel
    
    init(viewModel : ProductViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var productView:ProductDetailView = {
        var productView = ProductDetailView()
        return productView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        viewModel.configure(productView)
        
        self.view.addSubview(productView)
    }
}
