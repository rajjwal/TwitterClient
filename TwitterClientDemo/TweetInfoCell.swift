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
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    
    var tweet: Tweet! {
        didSet {
            
            profileNameLabel.text = tweet.profilename
            usernameLabel.text = "@" + tweet.username!
            tweetLabel.text = tweet.text as? String
            
            if let url = tweet.profileImageURL {
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
            }
            
            retweetCountLabel.text = String(tweet.retweetCount)
                
            favoriteCountLabel.text = String(tweet.favoritesCount)
            

            
    
            if tweet.favorited {
                favoriteButton.setImage(UIImage(named: "favor-icon-red") , for: .normal)
            } else {
                favoriteButton.setImage(UIImage(named: "favor-icon"), for: .normal)
            }
            
            if tweet.retweeted {
                retweetButton.setImage(UIImage(named: "retweet-icon-red") , for: .normal)
            } else {
                retweetButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
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
    
    
    
    @IBAction func onRetweetButton(_ sender: Any) {
        // locally toggle tweet rted state
        self.tweet.retweeted = !self.tweet.retweeted
        // visually change button based on rted state
        if self.tweet.retweeted {
            retweetButton.setImage(UIImage(named: "retweet-icon-green") , for: .normal)
            self.tweet.retweetCount += 1
        } else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
            self.tweet.retweetCount -= 1
        }
        
        // update count label
        
        self.retweetCountLabel.text = String(self.tweet.retweetCount)
        
        
        // post to Twitter
        
        if let id = self.tweet.tweetID {
            TwitterClient.sharedInstance?.retweetStatus(retweeting: self.tweet.retweeted, id: "\(id)")
        }

    }
    
    
    
    @IBAction func onFavoriteButton(_ sender: Any) {
        
        // toggle tweet favorited state
        self.tweet.favorited = !self.tweet.favorited
            
        // visually change button based on favorited state
        if self.tweet.favorited {
            
            favoriteButton.setImage(UIImage(named: "favor-icon-red") , for: .normal)
            favoriteButton.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: -1.0, bottom: 0.0, right: 0.0)
            self.tweet.favoritesCount += 1
        } else {
            favoriteButton.setImage(UIImage(named: "favor-icon"), for: .normal)
            favoriteButton.imageEdgeInsets = UIEdgeInsets(top: -4.0, left: 0.0, bottom: 0.0, right: 0.0)
            self.tweet.favoritesCount -= 1
        }
        self.favoriteCountLabel.text = String(self.tweet.favoritesCount)
        
        // post to twitter
        
        if let id = self.tweet.tweetID {
            TwitterClient.sharedInstance?.favoriteStatus(favoriting: self.tweet.favorited, id: "\(id)")
        }

        
        
    }
    
    

}
