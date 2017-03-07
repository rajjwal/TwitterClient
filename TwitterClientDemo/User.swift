//
//  User.swift
//  TwitterClientDemo
//
//  Created by Rajjwal Rawal on 2/22/17.
//  Copyright © 2017 Rajjwal Rawal. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: NSString?
    var screenname: NSString?
    var profileUrl: NSURL?
    var bannerImageURL: URL?
    var tagline: NSString?
    
    var followingCount: Int = 0
    var followingString: String {
        get {
            if followingCount >= 1000000 {
                return "\(Double(followingCount/100000).rounded()/10)m"
            } else if followingCount >= 1000 {
                return "\(Double(followingCount/100).rounded()/10)k"
            } else {
                return "\(followingCount)"
            }
        }
    }

    var tweetsCount: Int = 0
    var tweetsString: String {
        get {
            if tweetsCount >= 1000000 {
                return "\(Double(tweetsCount/100000).rounded()/10)m"
            } else if tweetsCount >= 1000 {
                return "\(Double(tweetsCount/100).rounded()/10)k"
            } else {
                return "\(tweetsCount)"
            }
        }
    }
    
    var followersCount: Int = 0
    var followersString: String {
        get {
            if followersCount >= 1000000 {
                return "\(Double(followersCount/100000).rounded()/10)m"
            } else if followersCount >= 1000 {
                return "\(Double(followersCount/100).rounded()/10)k"
            } else {
                return "\(followersCount)"
            }
        }
    }

    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String as NSString?
        screenname = dictionary["screen_name"] as? String as NSString?
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
        
        bannerImageURL = URL(string: dictionary["profile_banner_url"] as? String ?? "")
        
        tagline = dictionary["description"] as? String as NSString?
        
        followingCount = dictionary["friends_count"] as! Int
        followersCount = dictionary["followers_count"] as! Int
        tweetsCount = dictionary["statuses_count"] as! Int
        
    }
    
    
    static let userDidLogoutNotification = "UserDidLogOut"
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if let _currentUser = _currentUser {
                return _currentUser
            } else {
                let defaults = UserDefaults.standard
                if let data = defaults.data(forKey: "currentUserData"),
                    let jsonData = try? JSONSerialization.jsonObject(with: data, options: []),
                    let dictionary = jsonData as? [String: AnyObject] {
                    _currentUser = User(dictionary: dictionary as NSDictionary)
                    return _currentUser
                }
                return nil
            }
        }
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            if let user = user {
                if let data = try? JSONSerialization.data(withJSONObject: user.dictionary!, options: []) {
                    defaults.set(data, forKey: "currentUserData")
                } else {
                    defaults.set(nil, forKey: "currentUserData")
                }
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
}

