//
//  DataModel.swift
//  GoldmanSachs
//
//  Created by Gurwinder singh on 19/03/22.
//

import Foundation
class APOD {
    
    var title          : String?
    var date           : String?
    var explanation    : String?
    var hdurl          : String?
    var media_type      : String?
    var service_version : String?
    var url            : String?
    var copyright      : String?
    var id             = UUID()
    var isCheck : Bool?
    init(data : [String : Any]){
        self.title = data["title"] as? String
        self.date = data["date"] as? String
        self.explanation = data["explanation"] as? String
        self.media_type = data["media_type"] as? String
        self.service_version = data["service_version"] as? String
        self.url = data["url"] as? String
        self.copyright = data["copyright"] as? String
        self.hdurl = data["hdurl"] as? String
        isCheck = false
    }
}
