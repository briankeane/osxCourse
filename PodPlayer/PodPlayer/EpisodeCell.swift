//
//  EpisodeCell.swift
//  PodPlayer
//
//  Created by Brian D Keane on 9/24/17.
//  Copyright © 2017 Brian D Keane. All rights reserved.
//

import Cocoa
import WebKit

class EpisodeCell: NSTableCellView
{
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var pubDateLabel: NSTextField!
    @IBOutlet weak var descriptionWebView: WKWebView!
}
