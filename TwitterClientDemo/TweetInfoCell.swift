//
//  TweetInfoCell.swift
//  TwitterClientDemo
//
//  Created by Rajjwal Rawal on 2/27/17.
//  Copyright © 2017 Rajjwal Rawal. All rights reserved.
//

import UIKit
import AFNetworking

class TweetInfoCell: UITableViewCell {
    
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    var tweet: Tweet! {
        didSet {
            profileNameLabel.text = tweet.profilename
            
            tweetLabel.text = tweet.text as? String
            
            usernameLabel.text = "@" + tweet.username!
            
            if let url = tweet.profileImageURL {
                print (url)
                profileImageView.setImageWith(url)
            }
            
            
            if let timestamp = tweet.timestamp {
                let interval = timestamp.timeIntervalSinceNow
//                print(timestamp)
                if interval < 60 * 60 * 24 {
                    let secs = -Int(interval.truncatingRemainder(dividingBy: 60))
                    let mins = -Int((interval / 60).truncatingRemainder(dividingBy: 60))
                    let hrs = -Int((interval / 3600))
                    
                    let result = (hrs == 0 ? "" : "\(hrs)h ") + (mins == 0 ? "" : "\(mins)m ") + (secs == 0 ? "" : "\(secs)s")
                    timestampLabel.text = result
                } else {
                    let formatter: DateFormatter = {
                        let f = DateFormatter()
                        f.dateFormat = "EEE/MMM/d"
                        return f
                    }()
                    timestampLabel.text = formatter.string(from: timestamp as Date)
                }
                
                retweetCountLabel.text = String(tweet.retweetCount)
                
                favoriteCountLabel.text = String(tweet.favoritesCount)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = 5.0
        profileImageView.clipsToBounds = true
        
        
    }
    

    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
