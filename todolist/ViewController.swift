//
//  ViewController.swift
//  todolist
//
//  Created by as on 5/24/20.
//  Copyright © 2020 as. All rights reserved.
//

import Cocoa

class ViewController: NSViewController , NSTableViewDataSource , NSTableViewDelegate {
    
    
    @IBOutlet weak var textField: NSTextField!
    
    @IBOutlet weak var checkBox: NSButton!
    
    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet weak var deleteBtn: NSButton!
    
    var todoItems : [ToDoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getToDoItem()
    }
    
    
    
    
    
    @IBAction func deleteClicked(_ sender: Any) {
        
        let todoItem = todoItems[tableView.selectedRow]
        if let context =  (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            
            context.delete(todoItem)
            (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
            getToDoItem()
            deleteBtn.isHidden = true
        }
        
        
    }
    
    
    func getToDoItem(){
        if let context =  (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            
            do{
               todoItems =  try context.fetch(ToDoItem.fetchRequest())
            }catch {}
        }
        
        tableView.reloadData()
    }
    
    
    @IBAction func addBtn(_ sender: Any) {
        
        if textField.stringValue != ""{
            if let context =  (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
                 
                
                let toDoItem = ToDoItem(context: context)
                toDoItem.name = textField.stringValue
                if checkBox.state.rawValue == 0{
                    toDoItem.important = false
                }else{
                    toDoItem.important = true
                }
                (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
                textField.stringValue = ""
                checkBox.state = .off
                getToDoItem()
                
            }
        }
    }
    
    
    
    
    // MARK: - TableView Stuff
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        todoItems.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let toDoitem = todoItems[row]

        
        
        if tableColumn?.identifier.rawValue == "importantColumn"{
            
            
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "importantCell"), owner: self) as? NSTableCellView{
              
                
                if toDoitem.important{
                    cell.textField?.stringValue = "❗️"

                }else{
                    cell.textField?.stringValue = ""

                }
                
                
                
                
                return cell
            }
            
        }else{
            
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "todoColumn"), owner: self) as? NSTableCellView{
              
                
                let toDoitem = todoItems[row]
                
                
                cell.textField?.stringValue = toDoitem.name!
                return cell
            }
        }
        
        
        
        
        return nil
    }
    
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        deleteBtn.isHidden = false
    }
    
    
    

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

