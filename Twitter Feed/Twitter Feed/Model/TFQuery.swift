//
//  TFQuery.swift
//  Twitter Feed
//
//  Created by Muhamed Hafez on 12/17/16.
//  Copyright © 2016 Muhamed Hafez. All rights reserved.
//

import Foundation

class TFQuery {
    var textQuery = ""
    var sinceID = ""
    var maxID = ""
    
    init(query: String, sinceID: String = "", maxID: String = "") {
        textQuery = query
        self.sinceID = sinceID
        self.maxID = maxID
    }
    
    func constructParameters() -> String {
        var params = "q=" + textQuery.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
        if !sinceID.isEmpty {
            params = params + "&since_id=" + sinceID
        }
        else if !maxID.isEmpty {
            params = params + "&max_id=" + maxID
        }

        return params
    }
}
