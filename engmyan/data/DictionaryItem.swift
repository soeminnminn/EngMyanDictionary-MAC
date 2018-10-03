//
//  DictionaryItem.swift
//  engmyan
//
//  Created by New Wave Technology on 10/1/18.
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
    public var filename : String?
    public var picture : Bool = false
    public var sound : Bool = false
    
    override init() {
        super.init()
    }
    
    convenience init(row: Statement.Element) {
        self.init()
        
        self.id = row[0] as? Int64
        self.word = row[1] as? String
        self.stripWord = row[2] as? String
        
        if row.count > 3 {
            self.title = row[3] as? String
            self.definition = row[4] as? String
            self.keywords = row[5] as? String
            self.synonym = row[6] as? String
            self.filename = row[7] as? String
            self.picture = (row[8] as? Int8) == 1
            self.sound = (row[9] as? Int8) == 1
        }
    }
}
