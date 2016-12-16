//
//  TFTweetTableViewCell.swift
//  Twitter Feed
//
//  Created by Muhamed Hafez on 12/16/16.
//  Copyright © 2016 Muhamed Hafez. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class TFTweetTableViewCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: TTTAttributedLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        photo.layer.cornerRadius = 5.0
        photo.clipsToBounds = true
    
        tweetTextLabel.enabledTextCheckingTypes = NSTextCheckingAllTypes
    }

    func bind(tweet: TFTweet) {
        photo.sd_setImage(with: URL(string: tweet.user.imageURL)!)
        nameLabel.text = tweet.user.name
        screenNameLabel.text = "@" + tweet.user.screenName
        tweetTextLabel.text = tweet.text
    }
    
}
