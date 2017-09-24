//
//  EpisodesViewController.swift
//  PodPlayer
//
//  Created by Brian D Keane on 9/23/17.
//  Copyright © 2017 Brian D Keane. All rights reserved.
//

import Cocoa
import AVFoundation

// broadcast events
let kPodcastDeleted = Notification.Name("kPodcastDeleted")

class EpisodesViewController: ViewController, NSTableViewDataSource, NSTableViewDelegate
{
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var playPauseButton: NSButton!
    @IBOutlet weak var deleteButton: NSButton!
    @IBOutlet weak var episodesTableView: NSTableView!
    
    var podcast:Podcast?
    var episodes:[Episode] = Array()
    var player:AVPlayer? = nil
    
    //------------------------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupEpisodesTableView()
        self.updateView()
    }
    
    //------------------------------------------------------------------------------
    
    func setupEpisodesTableView()
    {
        self.episodesTableView.dataSource = self
        self.episodesTableView.delegate = self
    }
    
    //------------------------------------------------------------------------------
    
    func updateView()
    {
        if (self.podcast == nil)
        {
            return self.clearView()
        }
        
        self.episodesTableView.isHidden = false
        self.deleteButton.isHidden = false
        self.playPauseButton.isHidden = false
        
        if let title = podcast?.title
        {
            self.titleLabel.stringValue = title
        }
        
        if let imageURLString = podcast?.imageURL
        {
            if let imageURL = URL(string: imageURLString)
            {
                let image = NSImage(byReferencing: imageURL)
                self.imageView.image = image
            }
        }
        self.getEpisodes()
    }
    
    //------------------------------------------------------------------------------
    
    func clearView()
    {
        self.imageView.image = nil
        self.titleLabel.stringValue = ""
        self.episodesTableView.isHidden = true
        self.deleteButton.isHidden = true
        self.playPauseButton.isHidden = true
    }
    
    //------------------------------------------------------------------------------
    
    func getEpisodes()
    {
        if let urlString = podcast?.rssURL
        {
            if let url = URL(string: urlString)
            {
                URLSession.shared.dataTask(with: url)
                {
                    (data, response, error) -> Void in
                
                    // if there was an error
                    guard (error == nil) else {
                        print(error!.localizedDescription)
                        return
                    }
                
                    guard let data = data else
                    { return }
                
                    let parser = Parser()
                    let episodes = parser.getEpisodes(data: data)
                    self.episodes = episodes
                    
                    for episode in episodes
                    {
                        print(episode.audioURL)
                    }
                    
                    DispatchQueue.main.async
                    {
                        self.episodesTableView.reloadData()
                    }
                }.resume()
        
            }
        }
    }
    
    //------------------------------------------------------------------------------
    
    @IBAction func deleteClicked(_ sender: NSButton)
    {
        if (self.podcast != nil)
        {
            if let context = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext
            {
                self.player?.pause()
                self.player = nil
                
                context.delete(self.podcast!)
                (NSApplication.shared().delegate as? AppDelegate)?.saveAction(nil)
                NotificationCenter.default.post(name: kPodcastDeleted, object: nil)
                self.podcast = nil
                self.updateView()
            }
        }
    }
    
    //------------------------------------------------------------------------------
    
    @IBAction func playPauseButtonClicked(_ sender: NSButton)
    {
        if (self.player?.timeControlStatus == .playing)
        {
            self.player?.pause()
            self.playPauseButton.title = "Play"
        }
        else
        {
            self.startPlaying()
        }
    }
    
    //------------------------------------------------------------------------------
    
    func startPlaying()
    {
        if (self.episodesTableView.selectedRow >= 0)
        {
            let episode = self.episodes[self.episodesTableView.selectedRow]
            
            if let audioURL = URL(string: episode.audioURL)
            {
                self.player?.pause()
            
                self.player = AVPlayer.init(url: audioURL)
                self.player?.play()
            }
            self.playPauseButton.isHidden = false
            self.playPauseButton.title = "Pause"
            
        }
    }
    
    //------------------------------------------------------------------------------
    // MARK: TableView stuff
    //------------------------------------------------------------------------------
    func numberOfRows(in tableView: NSTableView) -> Int
    {
        return self.episodes.count
    }
    
    //------------------------------------------------------------------------------
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        let episode = self.episodes[row]
        
        let cell = self.episodesTableView.make(withIdentifier: "episodeCell", owner: self) as! EpisodeCell
        cell.titleLabel.stringValue = episode.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        cell.pubDateLabel.stringValue = dateFormatter.string(from: episode.pubDate)
        cell.descriptionWebView.loadHTMLString(episode.htmlDescription, baseURL: nil)
        return cell
    }
    
    //------------------------------------------------------------------------------
    
    func tableViewSelectionDidChange(_ notification: Notification)
    {
        if (self.episodesTableView.selectedRow >= 0)
        {
            let episode = self.episodes[self.episodesTableView.selectedRow]
            
            if let audioURL = URL(string: episode.audioURL)
            {
                self.player = AVPlayer.init(url: audioURL)
                self.player?.play()
            }
        }
    }
    
    //------------------------------------------------------------------------------
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat
    {
        return 100
    }
    
}
