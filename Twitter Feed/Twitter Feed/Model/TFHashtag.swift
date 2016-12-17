//
//  TFHashtag.swift
//  Twitter Feed
//
//  Created by Muhamed Hafez on 12/16/16.
//  Copyright © 2016 Muhamed Hafez. All rights reserved.
//

import Foundation

class TFHashTag: TFBaseModel {
    var text: String!
    var from = 0
    var to = 0

    var range: NSRange {
        get {
            return NSRange(location: from, length: to - from)
        }
    }
    
    required init(withDictionary dictionary: NSDictionary) {
        super.init(withDictionary: dictionary)
        text = dictionary["text"] as? String ?? ""
        guard let indices = dictionary["indices"] as? [Int] else { return }
        from = indices.first ?? 0
        to = indices.last ?? 0
    }
}
