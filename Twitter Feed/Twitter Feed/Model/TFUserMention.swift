//
//  TFUserMention.swift
//  Twitter Feed
//
//  Created by Muhamed Hafez on 12/16/16.
//  Copyright © 2016 Muhamed Hafez. All rights reserved.
//

import Foundation

class TFUserMention: TFBaseModel {
    var user: TFUser!
    var from = 0
    var to = 0
    
    required init(withDictionary dictionary: NSDictionary) {
        super.init(withDictionary: dictionary)
        user = TFUser(withDictionary: dictionary)
        guard let indices = dictionary["indices"] as? [Int] else { return }
        from = indices.first ?? 0
        to = indices.last ?? 0
    }
}
