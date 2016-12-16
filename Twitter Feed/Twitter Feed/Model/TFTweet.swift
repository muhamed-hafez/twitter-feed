//
//  TFTweet.swift
//  Twitter Feed
//
//  Created by Muhamed Hafez on 12/16/16.
//  Copyright © 2016 Muhamed Hafez. All rights reserved.
//

import Foundation

class TFTweet: TFBaseModel {
    var ID: String!
    var createdAt: Date!
    var user: TFUser!
    var text: String!
    var hashtags: [TFHashTag]?
    var userMentions: [TFUserMention]?
    var retweetCount = 0
    var favoriteCount = 0
    
    required init(withDictionary dictionary: NSDictionary) {
        super.init(withDictionary: dictionary)
        // parse the remaining fields
        ID = dictionary["id_str"] as! String
        user = TFUser(withDictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String ?? ""
        
        if let retweetStatus = dictionary["retweeted_status"] as? NSDictionary {
            retweetCount = retweetStatus["retweet_count"] as? Int ?? 0
            favoriteCount = retweetStatus["favorite_count"] as? Int ?? 0
        }
        
        guard let entities = dictionary["entities"] as? NSDictionary else { return }
        hashtags = TFHashTag.instancesFromArray(array: entities["hashtags"] as? Array<NSDictionary>) as? [TFHashTag]
        userMentions = TFUserMention.instancesFromArray(array: entities["user_mentions"] as? Array<NSDictionary>) as? [TFUserMention]
    }
    
}
