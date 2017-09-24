//
//  Episode.swift
//  PodPlayer
//
//  Created by Brian D Keane on 9/24/17.
//  Copyright © 2017 Brian D Keane. All rights reserved.
//

import Foundation

class Episode
{
    var title:String = ""
    var pubDate:Date = Date()
    var htmlDescription:String = ""
    var audioURL:String = ""
    
    static let formatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        return formatter
    }()
}
