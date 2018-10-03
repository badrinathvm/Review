//
//  API.swift
//  Review
//
//  Created by Badrinath on 9/15/18.
//  Copyright © 2018 Badrinath. All rights reserved.
//

import Foundation
import Alamofire

class API {
    
    var productModel:[Product] = []
    
    static let endPoint = "https://s3.us-east-2.amazonaws.com/juul-coding-challenge/products.json"
    
    func getData(completion: @escaping([Product]) -> ()) {
        let url = URL(string: API.endPoint)
        let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else { return }
            do{
                let pods = try JSONDecoder().decode(Pods.self, from: data)
                pods.pods.forEach { pod in
                    self.productModel.append(Product(id: pod.id, name: pod.name, desc: pod.description, price: Double(pod.price), thumbailUrl: pod.thumbnail_url, imageUrl: pod.image_url))
                }
                DispatchQueue.main.async {
                     completion(self.productModel)
                }
            }catch let error {
                print("Error is \(error.localizedDescription)")
           }
        }
        dataTask.resume()
    }
    
    func getProductData(completion: @escaping([Product]) -> () ) {
        
        Alamofire.request(API.endPoint,method: .get,parameters: nil,encoding: JSONEncoding.default,headers: nil).responseJSON { response in
            
            guard let result = response.result.value else {
                print("Unable to get response \(String(describing: response.result.value))")
                return
            }
            
            guard let resultDictionary = result as? NSDictionary else {
                print("Failed to \(result)")
                return
            }
            
            guard let resultArray = resultDictionary["pods"] as? NSArray else {
                print("Failed to get \(String(describing: resultDictionary["pods"]))")
                return
            }
            
            print(resultArray.count)
            
            resultArray.forEach({ result in

                guard let productDict = result as? NSDictionary else {
                    print("Failed to fetch Product Data")
                    return
                }

                guard let productId = productDict["id"] as? String,
                     let name = productDict["name"] as? String,
                     let description = productDict["description"] as? String,
                     let price = productDict["price"] as? Double,
                     let thumbailUrl = productDict["thumbnail_url"] as? String,
                     let imageUrl = productDict["image_url"] as? String
                     else{
                        print("Failed to extract Product Data")
                    return
                }
                
                print(productId)
                print(name)
                print(description)
                print(price)
                print(thumbailUrl)
                print(imageUrl)
                
                let product = Product(id: productId, name: name, desc: description, price: price, thumbailUrl: thumbailUrl, imageUrl: imageUrl)
   
                self.productModel.append(product)

           })
            
            print("Product Mode Data is \(self.productModel)")
            completion(self.productModel)
        }
    }
}

