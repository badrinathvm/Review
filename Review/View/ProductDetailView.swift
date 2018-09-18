//
//  ProductDetailView.swift
//  Review
//
//  Created by Badrinath on 9/15/18.
//  Copyright © 2018 Badrinath. All rights reserved.
//

import UIKit

class ProductDetailView: UIView {

    let productImage:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let name: UILabel = {
        var name = UILabel()
        name.textColor = UIColor.gray
        name.font = UIFont.boldSystemFont(ofSize: 20)
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    let price : UILabel = {
        var position = UILabel()
        position.textColor = UIColor.gray
        position.translatesAutoresizingMaskIntoConstraints = false
        position.font = UIFont.boldSystemFont(ofSize: 15)
        return position
    }()
    
    let descText : UITextView = {
        var desc = UITextView(frame: CGRect(x: 15, y: 380, width: UIScreen.main.bounds.width - 20, height: 40))
        desc.textColor = UIColor.gray
        desc.translatesAutoresizingMaskIntoConstraints = false
        desc.font = UIFont.boldSystemFont(ofSize: 15)
        return desc
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(product: Product? = nil){
        super.init(frame: .zero)
    
        [productImage,name,price,descText].forEach  {
            addSubview($0)
        }
        
        guard let product = product,
            let price = product.price,
            let imageUrl = product.imageUrl else { return }
        
        self.name.text = product.name
        self.price.text = "$\(price/100)"
        self.descText.text = product.desc
        self.productImage.loadImage(url: imageUrl)
        
        setupConstraints()
    }
    
    func setupConstraints() {

        productImage.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 65, left: UIScreen.main.bounds.width/5, bottom: 0, right: 0), size: .init(width: 0, height: 330))
          productImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        name.anchor(top: productImage.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 250, left: 20, bottom: 0, right: 10),
                    size: .init(width: UIScreen.main.bounds.width - 20, height: 40))
        
        price.anchor(top: name.topAnchor, leading: leadingAnchor, bottom:nil, trailing: trailingAnchor, padding: .init(top: 30, left: 20, bottom: 0, right: 10),  size: .init(width: UIScreen.main.bounds.width - 20, height: 40))
        
    }
    
}
