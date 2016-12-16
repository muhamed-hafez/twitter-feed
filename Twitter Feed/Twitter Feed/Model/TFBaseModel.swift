//
//  TFBaseModel.swift
//  Twitter Feed
//
//  Created by Muhamed Hafez on 12/16/16.
//  Copyright © 2016 Muhamed Hafez. All rights reserved.
//

import Foundation

class TFBaseModel {

    required init(withDictionary dictionary:NSDictionary) {
        
    }
    
    class func instancesFromArray(array:[NSDictionary]?) -> [TFBaseModel]? {
        return array?.map { self.init(withDictionary: $0) }
    }
}
