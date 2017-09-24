//
//  Parser.swift
//  PodPlayer
//
//  Created by Brian D Keane on 9/23/17.
//  Copyright © 2017 Brian D Keane. All rights reserved.
//

import Foundation
import SWXMLHash

class Parser {
    
    func getPodcastMetadata(data:Data) -> (title:String?, imageURL:String?)
    {
        let xml = SWXMLHash.parse(data)
        return (xml["rss"]["channel"]["title"].element?.text, xml["rss"]["channel"]["itunes:image"].element?.attribute(by: "href")?.text)
    }
    
    //------------------------------------------------------------------------------
    
    func getEpisodes(data:Data) -> [Episode]
    {
        let xml = SWXMLHash.parse(data)
        let items = xml["rss"]["channel"]["item"].all
        
        var episodes:[Episode] = Array()
        for item in items
        {
            let episode = Episode()
            if let title = item["title"].element?.text
            {
                episode.title = title
            }
            
            if let htmlDescription = item["description"].element?.text
            {
                episode.htmlDescription = htmlDescription
            }
            
            if let audioURL = item["enclosure"].element?.attribute(by: "url")?.text
            {
                episode.audioURL = audioURL
            }
            
            if let pubDateString = item["pubDate"].element?.text
            {
                if let pubDate = Episode.formatter.date(from: pubDateString)
                {
                    episode.pubDate = pubDate
                }
            }
            episodes.append(episode)
        }
        return episodes
    }
}
