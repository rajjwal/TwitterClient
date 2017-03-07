//
//  ComposeViewController.swift
//  TwitterClientDemo
//
//  Created by Rajjwal Rawal on 3/6/17.
//  Copyright © 2017 Rajjwal Rawal. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextField: UITextView!
    
    var startingText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        if startingText != nil {
            tweetTextField.text = "\(startingText!) "
        }
        
        tweetTextField.becomeFirstResponder()
        tweetTextField.delegate = self
        
        userImageView.setImageWith((User.currentUser?.profileImageUrl)! as URL)
        nameLabel.text = User.currentUser?.name as String?
        screenNameLabel.text = "@\(User.currentUser!.screenname)"
        
        textViewDidChange(tweetTextField)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTweetButton(_ sender: Any) {
        // TwitterClient.sharedInstance.tweet(tweetTextField.text)
        
        TwitterClient.sharedInstance?.postTweet(success: { () in
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
        }, status: tweetTextField.text!)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        characterCountLabel.text = "\(140 - textView.text.characters.count)"
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
