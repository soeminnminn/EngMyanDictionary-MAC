//
//  MainViewController.swift
//  engmyan
//
//  Created by Soe Minn Minn on 7/10/18.
//  Copyright © 2018 S16. All rights reserved.
//

import Cocoa

class MainViewController: NSSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    public var isSidebarCollapsed: Bool {
        get {
            return self.splitViewItems[0].isCollapsed
        }
    }
    
    public func onSearch(searchText: String?, _ block: @escaping (_: [DictionaryItem]?) -> Void) {
        if let listViewController = self.splitViewItems[0].viewController as? ListViewController {
            listViewController.onSearch(searchText: searchText, block: block)
        }
    }
    
    public func onSelectItem(historyItem: HistoryItem?) {
        if let history = historyItem, let itemData = history.item,
            let detailViewController = self.splitViewItems[1].viewController as? DetailViewController {
            
            detailViewController.data = itemData
            
            if let listViewController = self.splitViewItems[0].viewController as? ListViewController {
                listViewController.onSelectItem(item: itemData)
            }
        }
    }
    
    public func onSelectItem(item: DictionaryItem) {
        if let id = item.id, let itemData = DBManager.shared.queryDefinition(id: id),
            let detailViewController = self.splitViewItems[1].viewController as? DetailViewController {
            
            detailViewController.data = itemData
            
            let url = Bundle.main.bundleURL.appendingPathComponent("\(id)")
            BackForwardList.shared.add(item: HistoryItem(url: url.absoluteString, id: id, item: itemData))
        }
    }
    
    public func onToggleSourceList(_ sender: Any) {
        self.splitViewItems[0].isCollapsed = !self.splitViewItems[0].isCollapsed
    }
    
    public func onCopy(_ sender: Any) {
        print("onCopy")
    }
    
    public func onScale(_ value: Int) {
        if let detailViewController = self.splitViewItems[1].viewController as? DetailViewController {
            detailViewController.scale = value
        }
    }
    
    public func onToggleBookmarks(_ sender: Any) {
        
    }
    
    public func onManageBookmarks(_ sender: Any) {
        let identifier = NSStoryboard.SceneIdentifier("manageBookMarksWindow")
        if let manageBookmarksWindow = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: identifier) as? ManageBookmarksWindowController {
            manageBookmarksWindow.showWindow(self)
        }
    }
    
    public func onRecents(_ sender: Any) {
        let identifier = NSStoryboard.SceneIdentifier("recentsWindow")
        if let recentsWindow = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: identifier) as? RecentsWindowController {
            recentsWindow.showWindow(self)
        }
    }

}

