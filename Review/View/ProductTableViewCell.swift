//
//  ProductViewCell.swift
//  Review
//
//  Created by Badrinath on 9/15/18.
//  Copyright © 2018 Badrinath. All rights reserved.
//

import Foundation
import UIKit


protocol ProductTableViewCellDelegate:class {
    func didTapFavorite(_ sender: ProductTableViewCell)
}

class ProductTableViewCell : UITableViewCell {
    
    weak var delegate: ProductTableViewCellDelegate?
    
    var product: Product? {
        didSet{
            guard let product = product,
                let price = product.price,
                let thumbnailUrl = product.thumbailUrl else { return }
            self.name.text = product.name
            self.price.text = "$\(price/100)"
            self.productImage.loadImage(url: thumbnailUrl)
            
            guard let favFlag = product.fav else  { return }
            if favFlag {
                self.favImg.image = UIImage(named: "filled.png")
            }else{
                self.favImg.image = UIImage(named: "outline.png")
            }
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
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    var produtListViewController: ProductListViewController?
    
    @objc func favTapped() {
        delegate?.didTapFavorite(self)
    }
    
    func setup() {
        addSubview(containerView)
        
        containerView.addSubview(stackView)
        
        [name,price ].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [productImage,favImg ].forEach {
            containerView.addSubview($0)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(favTapped))
        favImg.addGestureRecognizer(tapGestureRecognizer)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            //containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            //stack View
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            stackView.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 4),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -50),
            stackView.heightAnchor.constraint(equalToConstant: 70),
            name.heightAnchor.constraint(equalToConstant: 35),
            //price.heightAnchor.constraint(equalToConstant: 35), //the above name onbe covers proce height constraint.
            
            //product Image
            productImage.widthAnchor.constraint(equalToConstant: 70),
            productImage.heightAnchor.constraint(equalToConstant: 70),
            productImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            productImage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4),
            productImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            
            //fav image
            favImg.widthAnchor.constraint(equalToConstant: 30),
            favImg.heightAnchor.constraint(equalToConstant: 30),
            favImg.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            favImg.topAnchor.constraint(equalTo: topAnchor, constant: 30)
        ])

    }
}
