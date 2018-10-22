//
//  RecentsViewController.swift
//  engmyan
//
//  Created by Soe Minn Minn on 10/3/18.
//  Copyright © 2018 S16. All rights reserved.
//

import Cocoa
import CoreData

class RecentsViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    
    var fetchedItems: [UserRecents]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func dataBind() {
        let fetchRequest = NSFetchRequest<UserRecents>(entityName: "UserRecents")
        do {
            self.fetchedItems = try self.managedObjectContext?.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        self.tableView.reloadData()
    }
    
}

extension RecentsViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.fetchedItems?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if let item = self.fetchedItems?[row] {
            let identifier = NSUserInterfaceItemIdentifier("itemCellView")
            if let cell = tableView.makeView(withIdentifier: identifier, owner: nil) as? NSTableCellView {
                cell.textField?.stringValue = item.word ?? ""
                return cell
            }
        }
        
        return nil
    }
    
}

extension RecentsViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 24.0
    }
    
}
