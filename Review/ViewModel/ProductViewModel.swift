//
//  ProductViewModel.swift
//  Review
//
//  Created by Badrinath on 9/18/18.
//  Copyright © 2018 Badrinath. All rights reserved.
//

import Foundation
import UIKit

class Dynamic<T> {
    
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    //Most of the times we need to bind and fire the event
    func bind(listener: Listener?){
        self.listener = listener
        listener?(value!)
    }
    
    //We need to set the callback that fire event
    var value: T?{
        didSet{
            guard let _value  = value else { return }
            listener?(_value)
        }
    }
    
    init(_ v: T) {
        value = v
    }
}

class ProductListViewModel {
    
   var productViewModels = [ProductViewModel]()
    
    private var dataAccess: API
    private var completion : () -> () = { }
    
    lazy var productModal: ProductModal = { [unowned self] in
        let modal = ProductModal()
        return modal
    }()
    
    init(dataAccess: API, completion : @escaping () -> ()) {
        self.dataAccess = dataAccess
        self.completion = completion
        populateProducts()
    }
    
    func populateProducts() {
       let products = productModal.fetchProductDataToModelView()
       self.productViewModels = products.compactMap { (product) in
            return ProductViewModel(product: product)
        }
    }
    
    func productAt(index: Int) -> ProductViewModel {
        return self.productViewModels[index]
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
        return product.name
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

