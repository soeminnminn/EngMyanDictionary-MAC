//
//  DictionaryItem.swift
//  engmyan
//
//  Created by New Wave Technology on 10/1/18.
//  Copyright © 2018 S16. All rights reserved.
//

import Foundation
import SQLite
import ZipZap

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
    
    private var pictureData: String?
    
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
            self.filename = row[7]?.stringValue
            self.picture = row[8]?.boolValue ?? false
            self.sound = row[9]?.boolValue ?? false
        }
    }
    
    public var pictureBase64: String? {
        if let base64 = self.getImage() {
            return "data:image/png;base64, \(base64)"
        }
        return nil
    }
    
    private func getImage() -> String? {
        if self.picture == false {
            return nil
        }
        
        if let data = self.pictureData {
            return data
        }
        
        guard let picZipUrl = Bundle.main.url(forResource: "pics", withExtension: "zip") else {
            return nil
        }
        guard let file = self.filename else {
            return nil
        }
        
        do {
            let archive = try ZZArchive(url: picZipUrl)
            for entry in archive.entries {
                if entry.fileName == "pics/\(file).png" {
                    self.pictureData = try entry.newData().base64EncodedString()
                    break
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return self.pictureData
    }
}
