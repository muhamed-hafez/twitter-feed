//
//  ViewController.swift
//  Twitter Feed
//
//  Created by Muhamed Hafez on 12/16/16.
//  Copyright © 2016 Muhamed Hafez. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, TFTweetCellDelegate {

    @IBOutlet weak var tweetTableView: UITableView!
    var tweets = [TFTweet]()
    var refreshTimer:Timer?
    var lastQuery: String = "#startup"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initComponents()
        searchForTweets()
    }

    func initComponents() {
        self.tweetTableView.dataSource = self
        self.tweetTableView.rowHeight = UITableViewAutomaticDimension
        self.tweetTableView.estimatedRowHeight = 130.0
        self.tweetTableView.tableFooterView = UIView()
        
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.autocorrectionType = .no
        searchBar.autocapitalizationType = .none
        searchBar.placeholder = "#hashtag_to_search"
        
        navigationItem.titleView = searchBar
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    func dismissKeyboard() {
        let searchBar = navigationItem.titleView as? UISearchBar
        searchBar?.showsCancelButton = false
        searchBar?.resignFirstResponder()
    }
    
    func searchForTweets() {
        let searchBar = navigationItem.titleView as? UISearchBar
        searchBar?.text = lastQuery
        
        let header = ["Authorization": "Bearer AAAAAAAAAAAAAAAAAAAAAGypyQAAAAAAsVjOEduC%2BTXBM6imanaJSM8PSaI%3DRd7E9j1akp3SX7thVr2s3kkh5PwKxCAgYCpjelTeSxgQFXrDDz"]
        let urlString = "https://api.twitter.com/1.1/search/tweets.json?q=" + lastQuery.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!

        Alamofire.request(urlString, headers: header)
            .validate()
            .responseJSON {
                [weak self] response in
                guard let dictionary = response.result.value as? [String: AnyObject] else { return }
                guard let statuses = dictionary["statuses"] as? Array<NSDictionary> else { return }
                self?.tweets = TFTweet.instancesFromArray(array: statuses) as! [TFTweet]
                self?.tweetTableView.reloadData()
        }
    }
    
    func setRefreshRate(_ interval: Int) {
        self.refreshTimer?.invalidate()
        
        if interval > 0 {
            self.refreshTimer = Timer.scheduledTimer(timeInterval: TimeInterval(interval), target: self, selector: #selector(searchForTweets), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func changeRefreshRate(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let timeIntervals = [0, 2, 5, 30, 60]

        timeIntervals.forEach {
            interval in
            var message = "No Refresh"
            if interval > 0 {
                message = "\(interval) Secs"
            }
            let refreshOption = UIAlertAction(title: message, style: .default) {
                [weak self] action in
                self?.setRefreshRate(interval)
            }
            alertController.addAction(refreshOption)
        }
        
        let cancelOption = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(cancelOption)
        
        present(alertController, animated: true)
    }
    
    // MARK: - UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TFTweetTableViewCell
        cell.bind(tweet: tweets[indexPath.row])
        cell.tapDelegate = self
        return cell
    }
    
    // MARK: - UISearchBarDelegate methods
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        searchBar.showsCancelButton = true
        return true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()

        // Though, search button won't be enabled unless there is a search query
        // it is good practice to check
        if searchBar.text?.isEmpty == false {
            lastQuery = searchBar.text!
            searchForTweets()
        }
    }
    
    // MARK: - TFTweetCellDelegate methods
    func didTap(onCell cell: UITableViewCell, atIndex index: Int) {
        guard let indexPath = tweetTableView.indexPath(for: cell) else { return }
        let tweet = tweets[indexPath.row]
        let clickedHashtag = tweet.hashtags?.filter {
            return $0.from <= index && index <= $0.to
        }.first
        
        if let hashtag = clickedHashtag {
            lastQuery = "#" + hashtag.text
            searchForTweets()
        }
    }
    
    deinit {
        refreshTimer?.invalidate()
    }
}

