//
//  ProductViewModel.swift
//  Review
//
//  Created by Badrinath on 9/18/18.
//  Copyright © 2018 Badrinath. All rights reserved.
//

import Foundation

//protocol ProductViewModel {
//    var productId: String { get }
//    var name: String { get }
//    var desc: String { get }
//    var price: Double { get }
//    var thumbnailUrl : String { get }
//    var imageUrl: String { get }
//}

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
    
    
    public func configure(_ view: ProductViewCell) {
        view.name.text = name
        view.price.text = price
        view.productImage.loadImage(url: thumbnailUrl!)
    }
}

