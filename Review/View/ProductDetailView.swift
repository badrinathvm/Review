//
//  ProductDetailView.swift
//  Review
//
//  Created by Badrinath on 9/15/18.
//  Copyright © 2018 Badrinath. All rights reserved.
//

import UIKit

class ProductDetailView: UIView {
    
    var viewModel:ProductViewModel?
    
    init(viewModel : ProductViewModel){

        self.viewModel = viewModel
        super.init(frame: .zero)
        
        [productImage, name,price,descText].forEach  {
            addSubview($0)
        }
            
        setupConstraints()
    }
    
    let stackView: UIStackView = {
       let stackView = UIStackView()
       stackView.translatesAutoresizingMaskIntoConstraints = false
       stackView.axis = .vertical
       stackView.alignment = .fill
       stackView.spacing = 0
       return stackView
    }()
    
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
        name.font = UIFont.boldSystemFont(ofSize: 16)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.numberOfLines = 2
        return name
    }()
    
    let price : UILabel = {
        var position = UILabel()
        position.textColor = UIColor.gray
        position.translatesAutoresizingMaskIntoConstraints = false
        position.font = UIFont.boldSystemFont(ofSize: 14)
        return position
    }()
    
    let descText : UITextView = {
        var desc = UITextView()
        desc.textColor = UIColor.gray
        desc.translatesAutoresizingMaskIntoConstraints = false
        desc.font = UIFont.boldSystemFont(ofSize: 15)
        return desc
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        
       NSLayoutConstraint.activate([
            productImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            productImage.topAnchor.constraint(equalTo: topAnchor, constant: 50)
        ])

      NSLayoutConstraint.activate([
            name.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            name.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            name.heightAnchor.constraint(equalToConstant: 25),
            name.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 16)
      ])

     NSLayoutConstraint.activate([
            price.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            price.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            price.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10),
            price.heightAnchor.constraint(equalToConstant: 25)
        ])

    NSLayoutConstraint.activate([
            descText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descText.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 10),
            descText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            descText.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
}
