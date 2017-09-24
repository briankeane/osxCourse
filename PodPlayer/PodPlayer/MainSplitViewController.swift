//
//  MainSplitViewController.swift
//  PodPlayer
//
//  Created by Brian D Keane on 9/23/17.
//  Copyright © 2017 Brian D Keane. All rights reserved.
//

import Cocoa

class MainSplitViewController: NSSplitViewController {

    @IBOutlet weak var podcastsItem: NSSplitViewItem!
    @IBOutlet weak var episodesItem: NSSplitViewItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // give the podcastsVC access to the episodesVC
        if let podcastsVC = podcastsItem.viewController as? PodcastsViewController
        {
            if let episodesVC = episodesItem.viewController as? EpisodesViewController
            {
                podcastsVC.episodesVC = episodesVC
            }
        }
    }
}
