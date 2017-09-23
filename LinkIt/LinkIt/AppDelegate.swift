//
//  AppDelegate.swift
//  LinkIt
//
//  Created by Brian D Keane on 9/23/17.
//  Copyright © 2017 Brian D Keane. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem:NSStatusItem?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.setupStatusItem()
        self.setupMenu()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    //------------------------------------------------------------------------------
    
    func setupStatusItem()
    {
        self.statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
        self.statusItem?.image = NSImage(named:"linkIcon")
        
        // IF we wanted it to work without a menu, this is what we'd do
        // self.statusItem?.action = #selector(AppDelegate.linkIt)
    }

    //------------------------------------------------------------------------------
    
    func setupMenu()
    {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Link It!", action: #selector(AppDelegate.linkIt), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(AppDelegate.quit), keyEquivalent: ""))
        self.statusItem?.menu = menu
    }
    
    //------------------------------------------------------------------------------
    
    func linkIt()
    {
        print("working")
        if var urlString = getStringFromPasteboard()
        {
            urlString = self.addHTTPIfNecessary(text: urlString)
            
            // clear pasteboard
            NSPasteboard.general().clearContents()
            
            self.copyStringAsToPasteboardAsLink(text: urlString)
        }
    }
    
    //------------------------------------------------------------------------------
    
    func getStringFromPasteboard() -> String?
    {
        if let items = NSPasteboard.general().pasteboardItems
        {
            for item in items
            {
                for type in item.types
                {
                    if (type == "public.utf8-plain-text")
                    {
                        if let url = item.string(forType: type)
                        {
                            return url
                        }
                    }
                }
            }
        }
        return nil
    }
    
    //------------------------------------------------------------------------------
    
    func copyStringAsToPasteboardAsLink(text:String)
    {
        // this makes it clickable
        NSPasteboard.general().setString("<a href=\"\(text)\">\(text)</a>", forType: "public.html")
        
        // this has the string -- applications can choose between the two types
        NSPasteboard.general().setString(text, forType: "public.utf8-plain-text")
    }
    
    //------------------------------------------------------------------------------
    
    func addHTTPIfNecessary(text:String) -> String
    {
        if (text.hasPrefix("http://") || text.hasPrefix("https://"))
        {
            return text
        }
        return "http://\(text)"
    }
    //------------------------------------------------------------------------------
    
    func quit()
    {
        NSApplication.shared().terminate(self)
    }
}

