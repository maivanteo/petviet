//
//  UserLike.swift
//  petviet
//
//  Created by Macintosh HD on 9/23/18.
//  Copyright © 2018 csb. All rights reserved.
//

import Foundation
import ObjectMapper

class UserLike:Mappable {
    var userId:String
    var displayName:String
    var key:String
    required init?(map: Map) {
        userId = ""
        displayName = ""
        key = ""
    }
    func mapping(map: Map) {
        self.userId <- map["userId"]
        self.displayName <- map["displayName"]
    }
    
}
