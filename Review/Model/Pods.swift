//
//  Pods.swift
//  Review
//
//  Created by Badarinath Venkatnarayansetty on 10/2/18.
//  Copyright © 2018 Badrinath. All rights reserved.
//

import Foundation


//Sample Data

//"id": "e46567ab82044e528b810850bdeb9228",
//"name": "mango",
//"description": "Ripe mango with hints of tropical fruit.",
//"price": 299,
//"thumbnail_url": "https://s3.us-east-2.amazonaws.com/juul-coding-challenge/images/mango_thumbnail.png",
//"image_url": "https://s3.us-east-2.amazonaws.com/juul-coding-challenge/images/mango_hires.png"
//}


class Pod: Decodable  {
    var id:String
    var name: String
    var description:String
    var price:Int
    var thumbnail_url:String
    var image_url:String
}

struct Pods: Decodable {
    var pods:[Pod]
}
