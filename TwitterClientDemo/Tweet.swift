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
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var profileImageURL: URL?
    
    
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
        
        //retweet count
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        
        // favourites count
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        // profile image
        if let profileImageURLString = user?["profile_image_url_https"] as? String,
            let profileImageURL = URL(string: profileImageURLString) {
            self.profileImageURL = profileImageURL
        } else {
            self.profileImageURL = nil
        }
        
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
