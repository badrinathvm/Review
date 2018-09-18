//
//  ProductViewCell.swift
//  Review
//
//  Created by Badrinath on 9/15/18.
//  Copyright © 2018 Badrinath. All rights reserved.
//

import Foundation
import UIKit

class ProductViewCell : UITableViewCell {
    
    var product: Product? {
        didSet{
            guard let product = product,
                let price = product.price,
                let thumbnailUrl = product.thumbailUrl else { return }
            self.name.text = product.name
            self.price.text = "$\(price/100)"
            self.productImage.loadImage(url: thumbnailUrl)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    let productImage:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 35
        img.layer.borderWidth = 3.5
        img.layer.borderColor = UIColor.white.cgColor
        img.clipsToBounds = true
        return img
    }()
    
    
    let favImg:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.isUserInteractionEnabled = true
        img.image = UIImage(named: "outline.png")
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
        var price = UILabel()
        price.textColor = UIColor.gray
        price.translatesAutoresizingMaskIntoConstraints = false
        price.font = UIFont.boldSystemFont(ofSize: 15)
        return price
    }()
    
    let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    
    func setup() {
        addSubview(containerView)
        
        [productImage,name,price,favImg ].forEach {
            containerView.addSubview($0)
        }
        
        containerView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 4, left: 8, bottom: 4, right: 8))
    
        productImage.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: 70, height:  70))
        productImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true

        name.anchor(top: topAnchor, leading: productImage.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 15, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 40))

        price.anchor(top: name.topAnchor, leading: productImage.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding:.init(top: 25, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 40))
        
        favImg.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 30, left: 0, bottom: 0, right: 10),size: .init(width: 30, height:  30))
    }
}
