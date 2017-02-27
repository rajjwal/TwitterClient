//
//  TwitterClient.swift
//  TwitterClientDemo
//
//  Created by Rajjwal Rawal on 2/23/17.
//  Copyright © 2017 Rajjwal Rawal. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: "LM7FnN0nzqpCZ40yUebsFUpbN", consumerSecret: "C7ILb0yv5O7ik52jqaKKswyWdGwUni08cbAZ1IpbTjQ4sWvuDz")
    
    var loginSuccess: (() -> ())?
    var loginFailure:((NSError) -> ())?
    
    
    func login(success: @escaping () -> (), failure:@escaping (NSError) -> ()) {
        
        loginSuccess = success
        loginFailure = failure
        

        TwitterClient.sharedInstance?.deauthorize() //logout -- clears the key chain
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string:"twitterClientDemo://oauth") as URL!, scope: nil, success: { (requestToken:
            BDBOAuth1Credential?) -> Void in
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)") as URL!
            UIApplication.shared.openURL(url!)
            
        }) { (error: Error?) -> Void in
            
            print ("error: \(error!.localizedDescription)")
            self.loginFailure!(error as! NSError)
            
        }
    }
    
    func handleOpenUrl(url: NSURL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
         fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in
            
            self.loginSuccess!()
            
        }) { (error: Error?) -> Void in
            print ("error: \(error?.localizedDescription)")
            self.loginFailure!(error as! NSError)
        }
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()) {
        
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            
            
            // print (response)
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            
            success(tweets)
            
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
            
        })

        
    }
    
    func currentAccount() {
        
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            
            // print ("account: \(response)")
            
            let userDictionary = response as! NSDictionary
            
            let user = User(dictionary: userDictionary)
            
            
            
            
            
            print ("name: \(user.name)")
            print ("screenname: \(user.screenname)")
            print ("profile Url: \(user.profileUrl)")
            print ("description: \(user.tagline)")
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            
        })
        
      
        
    }
}
