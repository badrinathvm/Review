//
//  ProductService.swift
//  Review
//
//  Created by Badrinath on 9/21/18.
//  Copyright © 2018 Badrinath. All rights reserved.
//

import Foundation

protocol ProductServiceProtocol: class {
      func fetchProduct(_ completion: @escaping ((Result<Product, ErrorResult>) -> Void))
}

class ProductService: RequestHandler, ProductServiceProtocol {
    
    static let shared = ProductService()
    
    var task : URLSessionTask?
    
    let endPoint = "https://s3.us-east-2.amazonaws.com/juul-coding-challenge/products.json"
    
    func fetchProduct(_ completion: @escaping ((Result<Product, ErrorResult>) -> Void)) {
        
        // cancel previous request if already in progress
        self.cancelFetchProducts()
        
        //self.networkResult(completion: completion)
        
        //task = RequestService().loadData(urlString: endPoint, completion: nil)
    }
    
    func cancelFetchProducts() {
        
        if let task = task {
            task.cancel()
        }
        task = nil
    }

}
