//
//  MyWindowController.swift
//  TouchColorFun
//
//  Created by Brian D Keane on 9/24/17.
//  Copyright © 2017 Brian D Keane. All rights reserved.
//

import Cocoa

@available(OSX 10.12.2, *)
class MyWindowController: NSWindowController {

    
    @IBOutlet weak var colorPicker: NSColorPickerTouchBarItem!
    
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.colorPicker.isEnabled = true
        self.colorPicker.target = self
        self.colorPicker.action = #selector(MyWindowController.colorPicked)
    }
    
    func colorPicked()
    {
         self.contentViewController?.view.layer?.backgroundColor = self.colorPicker.color.cgColor
    }
    
    @IBAction func helloButtonTapped(_ sender: Any)
    {
        print("hello world")
    }
    
}
