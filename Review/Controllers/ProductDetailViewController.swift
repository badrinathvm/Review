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
    
    lazy var productDetaiView:ProductDetailView = {
        var productView = ProductDetailView(viewModel: viewModel)
        productView.backgroundColor = .white
        productView.translatesAutoresizingMaskIntoConstraints = false
        return productView
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 0
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(productDetaiView)
        
        NSLayoutConstraint.activate([
            productDetaiView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productDetaiView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            productDetaiView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            productDetaiView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        viewModel.configure(productDetaiView)
    }
}
