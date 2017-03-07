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
    
    
    @objc enum LoadingMode: Int {
        case RefreshTweets
        case EarlierTweets
    }
    
    var maxTweetId: Int?
    var minTweetId: Int?
    
    
    
    var loginSuccess: (() -> ())?
    var loginFailure:((NSError) -> ())?
    
    
    func homeTimeline(mode: LoadingMode, success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()) {
        
        
        var parameters = ["count": 20]
            switch mode {
            case .RefreshTweets:
                if let maxTweetId = maxTweetId {
                    parameters["since_id"] = maxTweetId
                }
            case .EarlierTweets:
                if let minTweetId = minTweetId {
                    parameters["max_id"] = minTweetId - 1
                }
            }
        
        get("1.1/statuses/home_timeline.json",
            parameters: parameters,
            progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            
            
            //            print (response!)
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                
            let tweetIDs = tweets.reduce([]) { (result, tweet) -> [Int] in
                if let id = tweet.tweetID {
                    return result + [id]
                } else {
                    return result
                }
            }
                
                self.maxTweetId = tweetIDs.sorted().last
                self.minTweetId = tweetIDs.sorted().first
            
            
            success(tweets)
            
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
            
        })
        
        
    }
    
    
    
    func login(success: @escaping () -> (), failure:@escaping (NSError) -> ()) {
        
        loginSuccess = success
        loginFailure = failure
        

        TwitterClient.sharedInstance?.deauthorize() //logout -- clears the key chain
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string:"twitterClientDemo://oauth") as URL!, scope: nil, success: { (requestToken:
            BDBOAuth1Credential?) -> Void in
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)") as URL!
            UIApplication.shared.open(url!)
        }) { (error: Error?) -> Void in
            
            print ("error: \(error!.localizedDescription)")
            self.loginFailure!(error as! NSError)
            
        }
    }
    
    
    func retweetStatus(retweeting: Bool, id: String) {
        let endpoint = retweeting ? "retweet" : "unretweet"
        post("1.1/statuses/\(endpoint)/\(id).json",
            parameters: nil,
            progress: nil,
            success: {
                (task: URLSessionDataTask, response: Any?) in
            print("retweetStatus(): \(endpoint): success")
        },
             failure: { (task: URLSessionDataTask?, error: Error) in
                print("retweetStatus(): ERROR: \(error)")
        })
        
    }
    
    func postTweet(success: @escaping () -> (), failure: @escaping (Error) -> (), status: String) {
        post("1.1/statuses/update.json", parameters: ["status": status], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print("posted tweet!! \(status)")
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    
    func favoriteStatus(favoriting: Bool, id: String) {
        let endpoint = favoriting ? "create" : "destroy"
        post("1.1/favorites/\(endpoint).json?id=\(id)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print("favoriteStatus(): \(endpoint): success")
            },
            failure: { (task: URLSessionDataTask?, error: Error) in
            print("favoriteStatus(): ERROR: \(error)")
            })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
        
    }
    
    func handleOpenUrl(url: NSURL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
         fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in
            self.currentAccount( success: { (user: User) -> () in
                User.currentUser = user
                self.loginSuccess!()
            }, failure: { (error: NSError) -> () in
                self.loginFailure!(error)
            })
            
        }) { (error: Error?) -> Void in
            print ("error: \(error?.localizedDescription)")
            self.loginFailure!(error as! NSError)
        }
    }
    
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (NSError) -> ()) {
        
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            
            // print ("account: \(response)")
            
            let userDictionary = response as! NSDictionary
            
            let user = User(dictionary: userDictionary)
            
            
            success(user)
            
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
            
        })
        
    }
}
