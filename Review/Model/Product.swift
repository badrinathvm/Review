//
//  Product.swift
//  Review
//
//  Created by Badrinath on 9/15/18.
//  Copyright © 2018 Badrinath. All rights reserved.
//

import Foundation

class Product : NSObject , NSCoding{
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as? String
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.desc = aDecoder.decodeObject(forKey: "desc") as? String
        self.price = aDecoder.decodeObject(forKey: "price") as? Double
        self.thumbailUrl = aDecoder.decodeObject(forKey: "thumbailUrl") as? String
        self.imageUrl = aDecoder.decodeObject(forKey: "imageUrl") as? String
        self.fav = aDecoder.decodeObject(forKey: "fav") as? Bool
    }

    var id:String?
    var name:String?
    var desc:String?
    var price:Double?
    var thumbailUrl:String?
    var imageUrl:String?
    var fav:Bool?
    
    init(id:String, name:String, desc: String , price: Double, thumbailUrl: String , imageUrl: String , fav: Bool = false) {
        self.id = id
        self.name = name
        self.desc = desc
        self.price = price
        self.thumbailUrl = thumbailUrl
        self.imageUrl = imageUrl
        self.fav = fav
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.desc, forKey: "desc")
        aCoder.encode(self.price, forKey: "price")
        aCoder.encode(self.thumbailUrl, forKey: "thumbailUrl")
        aCoder.encode(self.imageUrl, forKey: "imageUrl")
        aCoder.encode(self.fav, forKey: "fav")
    }
}




//extension Product : Parceable {
//
//    static func parseObject(dictionary: [String : AnyObject]) -> Result<Products, ErrorResult> {
//        guard let productId = dictionary["id"] as? String,
//            let name = dictionary["name"] as? String,
//            let description = dictionary["description"] as? String,
//            let price = dictionary["price"] as? Double,
//            let thumbailUrl = dictionary["thumbnail_url"] as? String,
//            let imageUrl = dictionary["image_url"] as? String
//            else{
//                print("Failed to extract Product Data")
//                 return Result.failure(ErrorResult.parser(string: "Unable to parse conversion rate"))
//        }
//
//        let products = Product(id: productId, name: name, desc: description, price: price, thumbailUrl: thumbailUrl, imageUrl: imageUrl,fav: false)
//         return Result.success(products)
//    }
//}
