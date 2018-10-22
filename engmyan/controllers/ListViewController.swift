//
//  ListViewController.swift
//  engmyan
//
//  Created by Soe Minn Minn on 10/2/18.
//  Copyright © 2018 S16. All rights reserved.
//

import Cocoa

class ListViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    
    let queryLock = NSLock()
    var fetchedItems: [DictionaryItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.selectionHighlightStyle = .sourceList
        
        // Do view setup here.
        self.dataBind(searchText: nil)
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    public func onSearch(searchText: String?, block: @escaping (_: [DictionaryItem]?) -> Void) {
        self.dataBind(searchText: searchText)
        block(self.fetchedItems)
    }
    
    public func onSelectItem(item: DictionaryItem) {
        if let index = self.fetchedItems?.firstIndex(where: { $0.id == item.id } ) {
          self.tableView.selectRowIndexes([index], byExtendingSelection: false)
        }
    }
    
    func dataBind(searchText: String?) {
        queryLock.lock()
        if let constraint = searchText {
            self.fetchedItems = DBManager.shared.queryWord(constraint: constraint)
        } else {
            self.fetchedItems = DBManager.shared.querySuggestWord()
        }
        
        queryLock.unlock()
        self.tableView.reloadData()
    }
    
}

extension ListViewController: NSTableViewDataSource {
    
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

extension ListViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 24.0
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if let mainViewController = self.parent as? MainViewController, let item = self.fetchedItems?[row] {
            mainViewController.onSelectItem(item: item)
        }
        return true
    }
    
}
