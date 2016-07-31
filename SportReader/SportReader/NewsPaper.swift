//
//  NewsPaper.swift
//  SportReader
//
//  Created by  Arian Niaki on 5/8/1395 AP.
//  Copyright © 1395 AP  Arian Niaki. All rights reserved.
//

import UIKit

class NewsPaper {
    var html: String
    var title: String
    var tinyimage: String
//    var photo: UIImage?
    //    var text: String
    
    // MARK: Initialization
    
    init(html: String, title: String, tinyimage: String) {
        self.html = html
        self.tinyimage = tinyimage
        self.title = title
    }
}
