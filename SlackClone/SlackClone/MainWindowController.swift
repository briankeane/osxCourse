//
//  MainWindowController.swift
//  SlackClone
//
//  Created by Brian D Keane on 9/25/17.
//  Copyright © 2017 Brian D Keane. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    var activeVC:ViewController?

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    func moveToVC(identifier:String)
    {
        self.activeVC = storyboard?.instantiateController(withIdentifier: identifier) as? ViewController
        self.window?.contentView = self.activeVC?.view
    }

}
