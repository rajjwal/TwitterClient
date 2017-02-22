//
//  LoginViewController.swift
//  TwitterClientDemo
//
//  Created by Rajjwal Rawal on 2/21/17.
//  Copyright © 2017 Rajjwal Rawal. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLoginButton(_ sender: Any) {
         
        let twitterClient = BDBOAuth1SessionManager(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: "LM7FnN0nzqpCZ40yUebsFUpbN", consumerSecret: "C7ILb0yv5O7ik52jqaKKswyWdGwUni08cbAZ1IpbTjQ4sWvuDz")
        twitterClient?.deauthorize() //logout -- clears the key chain
        twitterClient?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string:"twitterClientDemo://oauth") as URL!, scope: nil, success: { (requestToken:
            BDBOAuth1Credential?) -> Void in
            
            print ("Token recieved!")
            
            
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)") as URL!
            UIApplication.shared.openURL(url!)
            print ("Yaaay!")
            
            
            
            
            
            
        }) { (error: Error?) -> Void in
            
            print ("error: \(error!.localizedDescription)")
        
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

}
