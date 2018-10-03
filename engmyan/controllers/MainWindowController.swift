//
//  MainWindowController.swift
//  engmyan
//
//  Created by New Wave Technology on 10/2/18.
//  Copyright © 2018 S16. All rights reserved.
//

import Cocoa

var kDictScrubberItemIdentifier = NSUserInterfaceItemIdentifier(rawValue: "DictScrubberItemIdentifier")

class MainWindowController: NSWindowController {
    
    @IBOutlet weak var toolsItemSearch: NSToolbarItem!
    
    @IBOutlet weak var touchBarNavBack: NSButton!
    @IBOutlet weak var touchbarNavNext: NSButton!
    @IBOutlet weak var touchBarScrubber: NSTouchBarItem!
    
    var fetchedItems: [DictionaryItem]?
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        if let searchField = self.toolsItemSearch?.view as? NSSearchField {
            searchField.delegate = self
        }
        
        if let scrubber = self.touchBarScrubber.view as? NSScrubber {
            scrubber.dataSource = self
            scrubber.delegate = self
            
            scrubber.register(NSScrubberTextItemView.self, forItemIdentifier: kDictScrubberItemIdentifier)
        }
        
        self.updateNavigation()
    }
    
    func updateNavigation() {
        self.touchbarNavNext.isEnabled = BackForwardList.shared.canGoForward
        self.touchBarNavBack.isEnabled = BackForwardList.shared.canGoBack
    }
    
    @IBAction func navigate(_ sender: Any) {
        if let segmented = sender as? NSSegmentedControl {
            if segmented.selectedSegment == 0 {
                self.navigateBackward(sender)
            } else {
                self.navigateForward(sender)
            }
        }
        self.updateNavigation()
    }
    
    @IBAction func navigateBackward(_ sender: Any) {
        if let historyItem = BackForwardList.shared.goBack(),
            let mainViewController = self.contentViewController as? MainViewController {
            
            mainViewController.onSelectItem(historyItem: historyItem)
        }
        
        self.updateNavigation()
    }
    
    @IBAction func navigateForward(_ sender: Any) {
        if let historyItem = BackForwardList.shared.goForward(),
            let mainViewController = self.contentViewController as? MainViewController {
           
            mainViewController.onSelectItem(historyItem: historyItem)
        }
        
        self.updateNavigation()
    }
    
    @IBAction func search(_ sender: Any) {
        if let searchField = self.toolsItemSearch?.view as? NSSearchField {
            self.window?.makeFirstResponder(searchField)
        }
    }
    
    @IBAction func scale(_ sender: Any) {
        if let popUpButton = sender as? NSPopUpButton,
            let mainViewController = self.contentViewController as? MainViewController {
            
            let scaleValue = popUpButton.indexOfSelectedItem == 0 ? 1 : popUpButton.indexOfSelectedItem * 2
            mainViewController.onScale(scaleValue)
        }
    }
    
    @IBAction func bookmarks(_ sender: Any) {
        if let mainViewController = self.contentViewController as? MainViewController {
            mainViewController.onToggleBookmarks(sender)
        }
    }
    
    @IBAction func recents(_ sender: Any) {
        if let mainViewController = self.contentViewController as? MainViewController {
            mainViewController.onRecents(sender)
        }
    }
    
    @IBAction func preferences(_ sender: Any) {
        
    }
}

extension MainWindowController: NSSearchFieldDelegate {
    
    func searchFieldDidEndSearching(_ sender: NSSearchField) {
        //print("searchFieldDidEndSearching")
    }
    
    func controlTextDidChange(_ obj: Notification) {
        if let searchField = obj.object as? NSSearchField,
            let mainViewController = self.contentViewController as? MainViewController {
            mainViewController.onSearch(searchText: searchField.stringValue) { items in
                self.fetchedItems = items
                if let scrubber = self.touchBarScrubber.view as? NSScrubber {
                    scrubber.reloadData()
                }
            }
        }
    }
}

extension MainWindowController: NSScrubberDataSource {
    
    func numberOfItems(for scrubber: NSScrubber) -> Int {
        return self.fetchedItems?.count ?? 0
    }
    
    func scrubber(_ scrubber: NSScrubber, viewForItemAt index: Int) -> NSScrubberItemView {
        if let itemView = scrubber.makeItem(withIdentifier: kDictScrubberItemIdentifier, owner: nil) as? NSScrubberTextItemView,
            let item = self.fetchedItems?[index] {
            
            itemView.textField.stringValue = item.word ?? ""
            return itemView
        }
        return NSScrubberItemView(frame: NSRect.zero)
    }
}

extension MainWindowController: NSScrubberDelegate {
 
    func scrubber(_ scrubber: NSScrubber, didSelectItemAt selectedIndex: Int) {
        if let mainViewController = self.contentViewController as? MainViewController,
            let item = self.fetchedItems?[selectedIndex] {
            mainViewController.onSelectItem(item: item)
        }
    }
}
