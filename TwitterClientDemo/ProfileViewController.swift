//
//  ProfileViewController.swift
//  TwitterClientDemo
//
//  Created by Rajjwal Rawal on 3/6/17.
//  Copyright © 2017 Rajjwal Rawal. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var UserWrapperView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = user.name as String?
        
        if let bannerImageURL = user.bannerImageURL {
            bannerImageView.setImageWith(bannerImageURL)
        }
        
        UserWrapperView.layer.cornerRadius = 5
        UserWrapperView.clipsToBounds = true
        
        userImageView.setImageWith(user.profileUrl as! URL)
        userImageView.layer.cornerRadius = 5
        userImageView.clipsToBounds = true
        
        nameLabel.text = user.name as String?
        screenNameLabel.text = "@\(user.screenname!)"
        descriptionLabel.text = user.tagline as String?
        tweetsCountLabel.text = user.tweetsString
        followingCountLabel.text = user.followingString
        followersCountLabel.text = user.followersString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
