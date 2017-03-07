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
    
    
    var timeStampLongText: String {
        get {
            let calendar = Calendar.current
            let TSYear = calendar.component(.year, from: timestamp as! Date)
            let TSMonth = calendar.component(.month, from: timestamp as! Date)
            let TSDay = calendar.component(.day, from: timestamp as! Date)
            let TSHour = calendar.component(.hour, from: timestamp as! Date)
            let TSMinute = calendar.component(.minute, from: timestamp as! Date)
            
            var hour = TSHour
            var AMPM: String
            if hour < 12 {
                if hour == 0 {
                    hour = 12
                }
                AMPM = "AM"
            } else {
                hour -= 12
                AMPM = "PM"
            }
            return "\(TSMonth)/\(TSDay)/\(TSYear), \(TSHour):\(TSMinute) \(AMPM)"
        }
    }

    var profileImageURL: URL?
    
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    
    var author: User
    
    
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
        
        
        // profile image
        if let profileImageURLString = user?["profile_image_url_https"] as? String,
            let profileImageURL = URL(string: profileImageURLString) {
            self.profileImageURL = profileImageURL
        } else {
            self.profileImageURL = nil
        }
        
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
        
        author = User(dictionary: dictionary["user"] as! NSDictionary)
        
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
