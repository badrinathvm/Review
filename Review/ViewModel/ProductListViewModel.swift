//
//  ProductViewModel.swift
//  Review
//
//  Created by Badrinath on 9/18/18.
//  Copyright © 2018 Badrinath. All rights reserved.
//

import Foundation
import UIKit

class ProductListViewModel {
    
    private (set) var productViewModel = [ProductViewModel]()
    
    private var dataAccess: API?
    private var completion :() -> () = {  }

    lazy var productModal: ProductModal = { [unowned self] in
        let modal = ProductModal()
        return modal
    }()

    init(dataAccess: API, completion:@escaping ()-> ()) {
        self.dataAccess = dataAccess
        self.completion = completion
        fetchProducts()
    }
    
    init(viewModel: [ProductViewModel] ){
        self.productViewModel = viewModel
        self.dataAccess = nil
        self.completion = { }
    }
    
    func fetchProducts() {
        self.dataAccess?.getData { products in
            self.productViewModel = products.map(ProductViewModel.init)
            //store in cache.
            PersistenceHelper.shared.updateUserDefaults(for: products)
            self.completion()
        }
    }

    func productAt(index: Int) -> ProductViewModel {
        return self.productViewModel[index]
    }
    
    func updateViewModel(for products: [ProductViewModel]) {
        self.productViewModel = products
    }
}

class ProductViewModel {
    
    private let product: Product

    init(product: Product) {
        self.product = product
    }

    var productId: String? {
        return product.id
    }

    var name: String? {
        get {
            return product.name
        }
        set {
           product.name = newValue
        }
    }

    var desc: String? {
        return product.desc
    }

    var price: String?  {
        return "$\(product.price! / 100)"
    }

    var thumbnailUrl: String? {
        return product.thumbailUrl
    }

    var imageUrl: String? {
        return product.imageUrl
    }
}

extension ProductViewModel {
    
    public func configure(_ view: ProductDetailView) {
      view.name.text = name
      view.price.text = price
      view.descText.text = desc
      view.productImage.loadImage(url: imageUrl!)
    }
    
    public func configure(_ view: ProductTableViewCell) {
        view.name.text = name
        view.price.text = price
        view.productImage.loadImage(url: thumbnailUrl!)
        
        guard let favFlag = product.fav else  { return }
        if favFlag {
            view.favImg.image = UIImage(named: "filled.png")
        }else{
            view.favImg.image = UIImage(named: "outline.png")
        }
    }
}


/* Deprecated Code
 
 
 func populateProducts() {
 productModal.fetchProductDataToModelView { (products) in
 self.productViewModel = products.compactMap { (product) in
 return ProductViewModel(product: product)
 }
 }
 }
 */
