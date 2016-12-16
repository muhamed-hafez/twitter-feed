//
//  ViewController.swift
//  Twitter Feed
//
//  Created by Muhamed Hafez on 12/16/16.
//  Copyright © 2016 Muhamed Hafez. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let header = ["Authorization": "Bearer AAAAAAAAAAAAAAAAAAAAAGypyQAAAAAAsVjOEduC%2BTXBM6imanaJSM8PSaI%3DRd7E9j1akp3SX7thVr2s3kkh5PwKxCAgYCpjelTeSxgQFXrDDz"]
        Alamofire.request("https://api.twitter.com/1.1/search/tweets.json?q=test", headers: header)
            .validate()
            .responseJSON {
                response in
                guard let dictionary = response.result.value as? [String: AnyObject] else { return }
                guard let statuses = dictionary["statuses"] as? Array<NSDictionary> else { return }
                let tweets = TFTweet.instancesFromArray(array: statuses)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

