//
//  Hero.swift
//  TestTaskHeroes
//
//  Created by leanid niadzelin on 11/23/18.
//  Copyright © 2018 Leanid Niadzelin. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Hero {
    let name: String
    let description: String
    let imageUrl: String
    let id: String
    
    init(json: JSON) {
        self.name = json["name"].string ?? ""
        self.description = json["description"].string ?? ""
        let idInt = json["id"].int
        self.id = String(describing: idInt)
        let url = json["thumbnail"]["path"].string ?? ""
        let imageQuality = "standard_fantastic"
        let imageExtension = json["thumbnail"]["extension"].string ?? ""
        self.imageUrl = "\(url)/\(imageQuality + "." + imageExtension)"
    }
}
