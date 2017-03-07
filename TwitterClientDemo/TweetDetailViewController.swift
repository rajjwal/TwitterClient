//
//  TweetDetailViewController.swift
//  TwitterClientDemo
//
//  Created by Rajjwal Rawal on 3/6/17.
//  Copyright © 2017 Rajjwal Rawal. All rights reserved.
//

import UIKit


class TweetDetailViewController: UIViewController {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.setImageWith(tweet.profileImageURL!)
        userImageView.layer.cornerRadius = 5
        userImageView.clipsToBounds = true
        
        nameLabel.text = tweet.profilename
        screenNameLabel.text = "@" + tweet.username!
        timeStampLabel.text = tweet.timeStampLongText
        tweetTextLabel.text = tweet.text as String?
        
        let retweetCount = convertToKFormat(number: tweet.retweetCount)
        let favoriteCount = convertToKFormat(number: tweet.favoritesCount)
        
//        print (retweetCount)
//        print (".........")
//        print(favoriteCount)
        
        
        retweetCountLabel.text = "\(retweetCount)"
        favoriteCountLabel.text = "\(favoriteCount)"
        
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
    
    func convertToKFormat(number: Int) -> String {
//        if (number > 999) {
//            let integerPart = floor(Double(number/1000))
//            let floatingPointPart = (number % 1000) / 1000
//            print (floatingPointPart)
//            return (String(integerPart) + "." + String(floatingPointPart))
//        }
        return String(number)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let profileVC = segue.destination as! ProfileViewController
        profileVC.user = tweet.author
    }
}
