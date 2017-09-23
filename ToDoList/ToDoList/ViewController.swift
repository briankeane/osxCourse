//
//  ViewController.swift
//  ToDoList
//
//  Created by Brian D Keane on 9/23/17.
//  Copyright © 2017 Brian D Keane. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource
{

    var toDoItems:[ToDoItem] = Array()
    @IBOutlet weak var importantCheckBox: NSButton!
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var toDoTableView: NSTableView!
    @IBOutlet weak var deleteButton: NSButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getToDoItems()
        self.toDoTableView.delegate = self
        self.toDoTableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func resetEntryFields()
    {
        self.textField.stringValue = ""
        self.importantCheckBox.state = 0
    }
    
    //------------------------------------------------------------------------------
    
    func getToDoItems()
    {
        if let context = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext
        {
            do
            {
                self.toDoItems = try context.fetch(ToDoItem.fetchRequest())
                print(self.toDoItems.count)
            }
            catch
            {
            }
            self.toDoTableView.reloadData()
        }
    }
    
    //------------------------------------------------------------------------------
    
    @IBAction func addClicked(_ sender: Any)
    {
        if (textField.stringValue != "")
        {
            if let context = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext
            {
                let toDoItem = ToDoItem(context: context)
                toDoItem.name = textField.stringValue
                if (importantCheckBox.state == 0)  // unchecked
                {
                    toDoItem.important = false
                }
                else
                {
                    toDoItem.important = true
                }
                (NSApplication.shared().delegate as? AppDelegate)?.saveAction(nil)
                self.getToDoItems()
                self.resetEntryFields()
            }
        }
    }
    
    //------------------------------------------------------------------------------
    
    @IBAction func deleteButtonClicked(_ sender: NSButton)
    {
        let toDoItem = toDoItems[self.toDoTableView.selectedRow]
        if let context = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext
        {
            context.delete(toDoItem)
            
            (NSApplication.shared().delegate as? AppDelegate)?.saveAction(nil)
            self.getToDoItems()
            self.deleteButton.isHidden = true
        }
    }
    
    //------------------------------------------------------------------------------
    // MARK: TableViewStuff
    //------------------------------------------------------------------------------
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        let toDoItem = self.toDoItems[row]
        
        var cellIdentifier:String! = ""
        var stringValue = ""
        
        if (tableColumn?.identifier == "importantColumn")
        {
            cellIdentifier = "importantCellView"
            if (toDoItem.important)
            {
                stringValue = "❗️"
            }
        }
        else
        {
            cellIdentifier = "itemCellView"
            stringValue = toDoItem.name!
        }
        
        if let cell = self.toDoTableView.make(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView
        {
            cell.textField?.stringValue = stringValue
            return cell
        }
        return nil
    }
    
    //------------------------------------------------------------------------------
    
    func numberOfRows(in tableView: NSTableView) -> Int
    {
        return self.toDoItems.count
    }
    
    //------------------------------------------------------------------------------
    
    func tableViewSelectionDidChange(_ notification: Notification)
    {
        deleteButton.isHidden = false
    }

}



