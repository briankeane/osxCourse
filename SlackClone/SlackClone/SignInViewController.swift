//
//  SignInViewController.swift
//  SlackClone
//
//  Created by Brian D Keane on 9/25/17.
//  Copyright © 2017 Brian D Keane. All rights reserved.
//

import Cocoa

class SignInViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func createAccountClicked(_ sender: NSButton)
    {
        if let mainWC = self.view.window?.windowController as? MainWindowController
        {
            mainWC.moveToVC(identifier: kCreateAccountViewControllerIdentifier)
        }
    }
}
