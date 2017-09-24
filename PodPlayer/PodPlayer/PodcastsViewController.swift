//
//  PodcastsViewController.swift
//  PodPlayer
//
//  Created by Brian D Keane on 9/23/17.
//  Copyright © 2017 Brian D Keane. All rights reserved.
//

import Cocoa

class PodcastsViewController: ViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var podcastURLTextField: NSTextField!
    @IBOutlet weak var podcastsTableView: NSTableView!
    
    var podcasts:[Podcast] = Array()
    var episodesVC:EpisodesViewController?
    
    //------------------------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupPodcastsTableView()
        self.setupListeners()
        self.refreshPodcastsFromCoreData()
    }
    
    //------------------------------------------------------------------------------
    
    func setupPodcastsTableView()
    {
        self.podcastsTableView.dataSource = self
        self.podcastsTableView.delegate = self
    }
    
    //------------------------------------------------------------------------------
    
    func setupListeners()
    {
        // listen for delete Podcast
        NotificationCenter.default.addObserver(forName: kPodcastDeleted, object: nil, queue: .main)
        {
            (notification) -> Void in
            self.refreshPodcastsFromCoreData()
        }
    }
    
    //------------------------------------------------------------------------------
    
    @IBAction func addPodcastClicked(_ sender: Any)
    {
        self.downloadInformationFrom(urlString: self.podcastURLTextField.stringValue)
    }
    
    //------------------------------------------------------------------------------
    
    func downloadInformationFrom(urlString:String)
    {
        if (self.podcastExists(rssURL: self.podcastURLTextField.stringValue) == true)
        {
            return
        }
        
        guard let url = URL(string: self.podcastURLTextField.stringValue)
            else { return }
        
        URLSession.shared.dataTask(with: url)
        {
            (data, response, error) -> Void in
            
            // if there was an error
            guard (error == nil) else {
                print(error!.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            let parser = Parser()
            let info = parser.getPodcastMetadata(data: data)
            
            if let context = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext
            {
                let podcast = Podcast(context: context)
                podcast.imageURL = info.imageURL
                podcast.title = info.title
                podcast.rssURL = urlString
                (NSApplication.shared().delegate as? AppDelegate)?.saveAction(nil)
                
                self.refreshPodcastsFromCoreData()
                DispatchQueue.main.async {
                    self.podcastURLTextField.stringValue = ""
                }
            }
        }.resume()
    }
    
    //------------------------------------------------------------------------------
    
    func refreshPodcastsFromCoreData()
    {
        if let context = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext
        {
            let fetchRequest = Podcast.fetchRequest() as NSFetchRequest<Podcast>
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            do
            {
                try self.podcasts = context.fetch(fetchRequest)
                DispatchQueue.main.async
                {
                    self.podcastsTableView.reloadData()
                }
            }
            catch
            {
                
                
            }
        }
    }
    
    //------------------------------------------------------------------------------
    
    func podcastExists(rssURL:String) -> Bool
    {
        if let context = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext
        {
            let fetchy = Podcast.fetchRequest() as NSFetchRequest<Podcast>
            fetchy.predicate = NSPredicate(format: "rssURL == %@", rssURL)
            
            do
            {
                let matchingPodcasts = try context.fetch(fetchy)
                
                if (matchingPodcasts.count >= 1)
                {
                    return true
                }
            } catch {}
        }
        
        return false
    }
    
    //------------------------------------------------------------------------------
    // MARK: TableView stuff
    //------------------------------------------------------------------------------
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        let podcast = self.podcasts[row]
        
        if let cell = self.podcastsTableView.make(withIdentifier: "podcastsTableCellView", owner: self) as? NSTableCellView
        {
            // defaults
            cell.textField?.stringValue = "UKNOWN TITLE"
            
            if let title = podcast.title
            {
                cell.textField?.stringValue = title
            }
            return cell
        }
        return nil
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int
    {
        return self.podcasts.count
    }
    
    //------------------------------------------------------------------------------
    
    func tableViewSelectionDidChange(_ notification: Notification)
    {
        if (self.podcastsTableView.selectedRow >= 0)  // -1 if nothing selected
        {
            let podcast = podcasts[self.podcastsTableView.selectedRow]
            self.episodesVC?.podcast = podcast
            self.episodesVC?.updateView()
        }
        
    }
}
