//
//  News.swift
//  SportReader
//
//  Created by  Arian Niaki on 5/8/1395 AP.
//  Copyright © 1395 AP  Arian Niaki. All rights reserved.
//

import UIKit

class News {
    var title: String
    var html: String
    var type: String
//    var photo: UIImage?
//    var text: String
    
    // MARK: Initialization
    
    init(title: String,html: String, type:String) {
        self.title = title
        self.html = html
        self.type = type
//        self.photo = photo
//        self.text = text
    }
}
