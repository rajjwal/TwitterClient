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
    var tagline: NSString?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String as NSString?
        screenname = dictionary["screen_name"] as? String as NSString?
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
        
        tagline = dictionary["description"] as? String as NSString?
        
    }
    
    
    static let userDidLogoutNotification = "UserDidLogOut"
    
    static var _currentUser: User?
    
    class var currentUser : User? {
        get {
            
            if _currentUser == nil {
                let defaults = UserDefaults.init()
                let userData = defaults.object(forKey: "currentUserData")
                
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData as! Data, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            
            return _currentUser
        
        }
        set(user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set (data, forKey: "currentUserData")
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
    

}
