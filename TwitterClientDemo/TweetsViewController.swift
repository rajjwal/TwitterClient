//
//  TweetsViewController.swift
//  TwitterClientDemo
//
//  Created by Rajjwal Rawal on 2/27/17.
//  Copyright © 2017 Rajjwal Rawal. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    var tweets = [Tweet]()
    
    var isMoreDataLoading = false;
    var loadingMoreView: InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        
        // Set up Pull-to-refresh view
        refreshControl.addTarget(self, action: #selector(TweetsViewController.loadMoreTimelineTweets(mode:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
            
            
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        loadMoreTimelineTweets(mode: .EarlierTweets)
    }
    
    func loadMoreTimelineTweets(mode: TwitterClient.LoadingMode) {
        TwitterClient.sharedInstance?.homeTimeline(
            mode: mode,
            success: { (tweets) in
                
                self.isMoreDataLoading = false
                self.loadingMoreView?.stopAnimating()
                
                switch mode {
                case .RefreshTweets:
                    self.tweets.insert(contentsOf: tweets, at: 0)
                    self.refreshControl.endRefreshing()
                case .EarlierTweets:
                    self.tweets.append(contentsOf: tweets)
                }
                
                self.tableView.reloadData()
                
        }, failure: { (error) in
            print(error.localizedDescription)}
        )
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                loadMoreTimelineTweets(mode: .EarlierTweets)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: Substitute with custom cell later
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TweetInfoCell", for: indexPath) as? TweetInfoCell {
            let tweet = tweets[indexPath.row]
            cell.profileButton.tag = indexPath.row
            cell.replyButton.tag = indexPath.row
            cell.tweet = tweet
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    

    
    @IBAction func onLogoutButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.logout()
    }


    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing for segue: \(segue.identifier!)")
        if (segue.identifier == "TweetDetailsSegue") {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[indexPath!.row]
            
            let tweetDetailVC = segue.destination as! TweetDetailViewController
            tweetDetailVC.tweet = tweet
            
        } else if (segue.identifier == "ReplySegue") {
            let indexPathRow = (sender as! UIButton).tag
            let tweet = tweets[indexPathRow];
            
            let composeVC = segue.destination as! ComposeViewController
            composeVC.startingText = "@\(tweet.username!)"
        
        } else if (segue.identifier == "ProfileSegue") {
            let indexPathRow = (sender as! UIButton).tag
            let tweet = tweets[indexPathRow];
            
            let profileVC = segue.destination as! ProfileViewController
            profileVC.user = tweet.author
            
        }
    }
}


