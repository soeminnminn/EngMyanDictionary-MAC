//
//  DictionaryItem.swift
//  engmyan
//
//  Created by Soe Minn Minn on 10/1/18.
//  Copyright © 2018 S16. All rights reserved.
//

import Foundation
import SQLite

class DictionaryItem: NSObject {
    public var id : Int64?
    public var word : String?
    public var stripWord : String?
    public var title : String?
    public var definition : String?
    public var keywords : String?
    public var synonym : String?
    public var picture : String?
    
    override init() {
        super.init()
    }
    
    convenience init(row: Statement.Element) {
        self.init()
        
        self.id = row[0]?.int64Value
        self.word = row[1]?.stringValue
        self.stripWord = row[2]?.stringValue
        
        if row.count > 3 {
            self.title = row[3]?.stringValue
            self.definition = row[4]?.stringValue
            self.keywords = row[5]?.stringValue
            self.synonym = row[6]?.stringValue
            self.picture = row[7]?.stringValue
        }
    }
}
