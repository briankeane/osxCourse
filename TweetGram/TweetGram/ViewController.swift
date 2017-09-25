//
//  ViewController.swift
//  TweetGram
//
//  Created by Brian D Keane on 9/24/17.
//  Copyright © 2017 Brian D Keane. All rights reserved.
//

import Cocoa
import OAuthSwift
import SwiftyJSON
import Kingfisher

class ViewController: NSViewController, NSCollectionViewDelegate, NSCollectionViewDataSource
{
    @IBOutlet weak var signInSignOutButton: NSButton!
    @IBOutlet weak var collectionView: NSCollectionView!
    
    // OAuthSwift setup
    let oauthSwift = OAuth1Swift(
        consumerKey:    APIKeys.TwitterConsumerKey,
        consumerSecret: APIKeys.TwitterConsumerSecret,
        requestTokenUrl: "https://api.twitter.com/oauth/request_token",
        authorizeUrl:    "https://api.twitter.com/oauth/authorize",
        accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
    )
    
    var tweets:[(imageURLString:String, tweetURL:String)] = Array()
    
    //------------------------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupCollectionView()
        if (self.checkSignedIn())
        {
            self.getImages()
        }
    }
    
    func setupCollectionView()
    {
        let layout = NSCollectionViewFlowLayout()
        layout.itemSize = NSSize(width: 300, height: 300)
        layout.sectionInset = EdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        layout.minimumLineSpacing = 5.0
        layout.minimumInteritemSpacing = 5.0
        self.collectionView.collectionViewLayout = layout
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isSelectable = true
    }
    
    func signIn()
    {
        let _ = self.oauthSwift.authorize(
            withCallbackURL: URL(string: "TweetGram://oauth-callback/twitter")!,
            success:
            {
                (credential, response, parameters) in
                self.saveTwitterTokens(token: credential.oauthToken, secret: credential.oauthTokenSecret)
                self.signInSignOutButton.title = "Sign Out"
                self.getImages()
            },
            failure:
            {
                (error) in
                print(error.localizedDescription)
            })
    }
    
    func getImages()
    {
        let _ = self.oauthSwift.client.get("https://api.twitter.com/1.1/statuses/home_timeline.json", parameters: ["tweet_mode":"extended", "count": 200],
        success:
        {
            (response) in
            let json = JSON(data: response.data)
            
            var foundTweets:[(imageURLString:String, tweetURL:String)] = Array()
            
            for (_, tweetJson) in json
            {
                var hasBeenAdded = false
                // get regular tweets with pics
                for (_, mediaJSON):(String, JSON) in tweetJson["extendded_entities"]["media"]
                {
                    if let imageURLString = mediaJSON["media_url_https"].string
                    {
                        if let tweetURL = mediaJSON["expanded_url"].string
                        {
                            foundTweets.append((imageURLString: imageURLString, tweetURL: tweetURL))
                            hasBeenAdded = true
                        }
                    }
                }
                
                if (!hasBeenAdded)
                {
                    // get retweeted pics (different JSON structure)
                    for (_, mediaJSON):(String, JSON) in tweetJson["retweeted_status"]["extended_entities"]["media"]
                    {
                        if let imageURLString = mediaJSON["media_url_https"].string
                        {
                            if let tweetURL = mediaJSON["expanded_url"].string
                            {
                                foundTweets.append((imageURLString: imageURLString, tweetURL: tweetURL))
                            }
                        }
                    } 
                }
                
            }
            self.tweets = foundTweets
            self.collectionView.reloadData()
        })
        {
            (error) in
            print(error)
        }
    }
    
    func checkSignedIn() -> Bool
    {
        if let token = UserDefaults.standard.string(forKey: "twitterToken")
        {
            if let secret = UserDefaults.standard.string(forKey: "twitterSecret")
            {
                oauthSwift.client.credential.oauthToken = token
                oauthSwift.client.credential.oauthTokenSecret = secret
                self.signInSignOutButton.title = "Sign Out"
                return true
            }
        }
        self.signInSignOutButton.title = "Sign In"
        return false
    }
    
    func saveTwitterTokens(token:String, secret:String)
    {
        UserDefaults.standard.set(token, forKey: "twitterToken")
        UserDefaults.standard.set(secret, forKey: "twitterSecret")
        UserDefaults.standard.synchronize()
        
    }
    
    func removeTwitterTokens()
    {
        UserDefaults.standard.removeObject(forKey: "twitterToken")
        UserDefaults.standard.removeObject(forKey: "twitterSecret")
        UserDefaults.standard.synchronize()
    }
    
    func signOut()
    {
        self.signInSignOutButton.title = "Sign In"
        self.removeTwitterTokens()
        self.resetTweets()
    }
    
    func resetTweets()
    {
        self.tweets = Array()
        self.collectionView.reloadData()
    }
    
    @IBAction func signInSignOutButtonClicked(_ sender: Any)
    {
        if (self.signInSignOutButton.title == "Sign In")
        {
            self.signIn()
        }
        else
        {
            self.signOut()
        }
    }
    
    //------------------------------------------------------------------------------
    // MARK: CollectionView Stuff
    //------------------------------------------------------------------------------
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem
    {
        let imageURLString = self.tweets[indexPath.item].imageURLString
        let item = self.collectionView.makeItem(withIdentifier: "TweetGramCollectionViewItem", for: indexPath)
        item.imageView?.kf.setImage(with: URL(string: imageURLString))
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>)
    {
        print("hi")
        self.collectionView.deselectAll(nil)
        if let indexPath = indexPaths.first
        {
            let urlString = tweets[indexPath.item].tweetURL
            if let url = URL(string: urlString)
            {
                NSWorkspace.shared().open(url)
            }
        }
    }
    
    
    
}

