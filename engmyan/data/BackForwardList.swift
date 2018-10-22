//
//  BackForwardList.swift
//  engmyan
//
//  Created by Soe Minn Minn on 10/3/18.
//  Copyright © 2018 S16. All rights reserved.
//

import Foundation

struct HistoryItem {
    var url: String?
    var id: Int64?
    var item: DictionaryItem?
}

class BackForwardList: NSObject {
    
    open class var shared: BackForwardList {
        struct Static {
            static let instance: BackForwardList = BackForwardList()
        }
        return Static.instance
    }
    
    private var currentIndex: Int = -1
    private var items: [HistoryItem]!
    
    override init() {
        super.init()
        
        self.currentIndex = -1
        self.items = [HistoryItem]()
    }
    
    public func item(at index: Int) -> HistoryItem? {
        if index < 0 || index >= self.count {
            return nil
        }
        return self.items[index]
    }
    
    public func item(at url: String) -> HistoryItem? {
        if url.isEmpty {
            return nil
        }
        for item in self.items {
            if item.url == url {
                return item;
            }
        }
        return nil
    }
    
    public var currentItem: HistoryItem? {
        return self.item(at: self.currentIndex)
    }
    
    public func contains(url: String) -> Bool {
        if let _ = self.item(at: url) {
            return true
        }
        return false
    }
    
    public func add(item: HistoryItem) {
        self.currentIndex += 1;
        let size = self.items.count
        let newPos = self.currentIndex
        if newPos < size {
            for i in (newPos...(size - 1)).reversed() {
                self.items.remove(at: i)
            }
        }
        self.items.append(item)
    }
    
    public func remove(index: Int) {
        if index < 0 || index >= self.count {
            return
        }
        self.items.remove(at: index)
        self.currentIndex -= 1;
    }
    
    public func close() {
        self.items = [HistoryItem]()
        self.currentIndex = -1
    }
    
    public var count: Int {
        return self.items.count
    }
    
    public var canGoBack: Bool {
        return self.count > 1 && self.currentIndex > 0
    }
    
    public var canGoForward: Bool {
        return self.count > 1 && self.currentIndex < (self.count - 1)
    }
    
    public func canGoBackOrForward(steps: Int) -> Bool {
        if self.count > 0 {
            let index = self.currentIndex + steps
            return index > -1 && index < self.count
        }
        return false
    }
    
    public func goBack() -> HistoryItem? {
        if self.canGoBack == false {
            return nil
        }
        self.currentIndex -= 1
        return self.currentItem
    }
    
    public func goForward() -> HistoryItem? {
        if self.canGoForward == false {
            return nil
        }
        self.currentIndex += 1
        return self.currentItem
    }
    
    public func goBackOrForward(steps: Int) -> HistoryItem? {
        if self.canGoBackOrForward(steps: steps) == false {
            return nil
        }
        self.currentIndex += steps
        return self.currentItem
    }
}
