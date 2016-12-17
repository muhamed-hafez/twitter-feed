//
//  TFTweetTableViewCell.swift
//  Twitter Feed
//
//  Created by Muhamed Hafez on 12/16/16.
//  Copyright © 2016 Muhamed Hafez. All rights reserved.
//

import UIKit
import TTTAttributedLabel

protocol TFTweetCellDelegate: class {
    func didTap(onCell: UITableViewCell, atIndex: Int)
}

class TFTweetTableViewCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: TTTAttributedLabel!
    
    weak var tapDelegate: TFTweetCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        photo.layer.cornerRadius = 5.0
        photo.clipsToBounds = true
    
        tweetTextLabel.enabledTextCheckingTypes = NSTextCheckingAllTypes

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tweetTextLabel.isUserInteractionEnabled = true
        tweetTextLabel.addGestureRecognizer(tapRecognizer)
    }

    func bind(tweet: TFTweet) {
        photo.sd_setImage(with: URL(string: tweet.user.imageURL)!)
        nameLabel.text = tweet.user.name
        screenNameLabel.text = "@" + tweet.user.screenName
        
        let attributedTweetText = NSMutableAttributedString(string: tweet.text)

        for hashtag in tweet.hashtags! {
            attributedTweetText.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue, range: NSRange(location: hashtag.from, length: hashtag.to - hashtag.from))
        }
        
        for mention in tweet.userMentions! {
            attributedTweetText.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue, range: NSRange(location: mention.from, length: mention.to - mention.from))
        }

        tweetTextLabel.attributedText = attributedTweetText
    }
    
    func handleTap(_ tapRecognizer: UITapGestureRecognizer) {
        let touchPoint = tapRecognizer.location(in: tweetTextLabel)
        
        let textStorage = NSTextStorage(attributedString: tweetTextLabel.attributedText)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: tweetTextLabel.frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = tweetTextLabel.numberOfLines
        textContainer.lineBreakMode = tweetTextLabel.lineBreakMode
        layoutManager.addTextContainer(textContainer)
        
        let index = layoutManager.characterIndex(for: touchPoint, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        self.tapDelegate?.didTap(onCell: self, atIndex: index)
    }
 
}
