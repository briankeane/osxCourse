//
//  CreateAccountViewController.swift
//  SlackClone
//
//  Created by Brian D Keane on 9/25/17.
//  Copyright © 2017 Brian D Keane. All rights reserved.
//

import Cocoa

class CreateAccountViewController: ViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do view setup here.
        print("hi")
    }
    
    func goBack()
    {
        if let mainWindowVC = self.view.window?.windowController as? MainWindowController
        {
            mainWindowVC.moveToVC(identifier: kSignInViewController)
        }
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        self.goBack()
    }
    
    
}
