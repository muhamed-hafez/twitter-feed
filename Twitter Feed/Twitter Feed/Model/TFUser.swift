//
//  TFUser.swift
//  Twitter Feed
//
//  Created by Muhamed Hafez on 12/16/16.
//  Copyright © 2016 Muhamed Hafez. All rights reserved.
//

import Foundation

class TFUser: TFBaseModel {
    var ID: String!
    var screenName: String!
    var name: String!
    
    required init(withDictionary dictionary: NSDictionary) {
        super.init(withDictionary: dictionary)
        ID = dictionary["id_str"] as! String
        screenName = dictionary["screen_name"] as? String ?? ""
        name = dictionary["name"] as? String ?? ""
    }
}
