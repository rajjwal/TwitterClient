//
//  Tweet.swift
//  TwitterClientDemo
//
//  Created by Rajjwal Rawal on 2/22/17.
//  Copyright © 2017 Rajjwal Rawal. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var user: NSDictionary!
    var profilename: String?
    var username: String?
    var text: NSString?
    var timestamp: NSDate?

    var profileImageURL: URL?
    
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    
    
    var favorited: Bool = false
    var retweeted: Bool = false
    
    var retweetedStatus: NSDictionary?
    
    let tweetID: Int?
    
    
    init (dictionary: NSDictionary) {
        // User dictionary, contains profile name, profile image url, date created, location etc.
        user = dictionary["user"] as? NSDictionary
        
        // profilename
        profilename = user["name"] as? String
        
        // Username
        username = user["screen_name"] as? String
        
        // tweet text
        text = dictionary["text"] as? String as NSString?
        
        // time stamp
        if let timestampString = dictionary["created_at"] as? String {
            let formatter: DateFormatter = {
                let f = DateFormatter()
                f.dateFormat = "EEE MMM d HH:mm:ss Z y"
                return f
            }()
            timestamp = formatter.date(from: timestampString) as NSDate?
        } else {
            timestamp = nil
        }
        
        
        retweetedStatus = dictionary["retweeted_status"] as? NSDictionary
        //retweet count
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        
        // favourites count
        if let retweetedStatus = retweetedStatus {
            favoritesCount = (retweetedStatus["favorite_count"] as? Int) ?? 0
        } else {
            favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        }

        
        self.tweetID = dictionary["id"] as? Int
        
        
        
        // profile image
        if let profileImageURLString = user?["profile_image_url_https"] as? String,
            let profileImageURL = URL(string: profileImageURLString) {
            self.profileImageURL = profileImageURL
        } else {
            self.profileImageURL = nil
        }
        
        favorited = dictionary["favorited"] as! Bool
        retweeted = dictionary["retweeted"] as! Bool
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        } 
        return tweets
    }

}
