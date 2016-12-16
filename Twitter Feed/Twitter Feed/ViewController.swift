//
//  ViewController.swift
//  Twitter Feed
//
//  Created by Muhamed Hafez on 12/16/16.
//  Copyright © 2016 Muhamed Hafez. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tweetTableView: UITableView!
    var tweets = [TFTweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tweetTableView.dataSource = self
        self.tweetTableView.rowHeight = UITableViewAutomaticDimension
        self.tweetTableView.estimatedRowHeight = 130.0
        self.tweetTableView.tableFooterView = UIView()
        
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
        
        searchForTweets(withQuery: "#test")
    }

    func searchForTweets(withQuery query: String) {
        let header = ["Authorization": "Bearer AAAAAAAAAAAAAAAAAAAAAGypyQAAAAAAsVjOEduC%2BTXBM6imanaJSM8PSaI%3DRd7E9j1akp3SX7thVr2s3kkh5PwKxCAgYCpjelTeSxgQFXrDDz"]
        let urlString = "https://api.twitter.com/1.1/search/tweets.json?q=" + query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TFTweetTableViewCell
        cell.bind(tweet: tweets[indexPath.row])
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
        print("searching for \(searchBar.text)")
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()

        // Though, search button won't be enabled unless there is a search query
        // it is good practice to check
        if searchBar.text?.isEmpty == false {
            searchForTweets(withQuery: searchBar.text!)
        }
    }
}

