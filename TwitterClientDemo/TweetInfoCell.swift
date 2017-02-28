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
   
    var tweet: Tweet! {
        didSet {
            profileNameLabel.text = tweet.profilename
            tweetLabel.text = tweet.text as? String
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    

    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
