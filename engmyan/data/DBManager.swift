//
//  DBManager.swift
//  engmyan
//
//  Created by Soe Minn Minn on 10/2/18.
//  Copyright © 2018 S16. All rights reserved.
//

import Foundation
import SQLite

class DBManager: NSObject {
    
    var databaseUrl: URL?
    var database: Connection!
    
    open class var shared: DBManager {
        struct Static {
            static let instance: DBManager = DBManager()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        
        guard let storeURL = Bundle.main.url(forResource: "EMDictionary", withExtension: "db") else {
            fatalError("Error loading database from bundle")
        }
        self.databaseUrl = storeURL
    }
    
    func openDatabase() -> Bool {
        if database == nil {
            do {
                self.database = try Connection(self.databaseUrl?.absoluteString ?? "", readonly: true)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        if self.database != nil {
            return true
        }
        return false
    }
    
    func querySuggestWord() -> [DictionaryItem]! {
        var rows : [DictionaryItem]! = [DictionaryItem]()
        
        if self.openDatabase() {
            let query = "SELECT `_id`, `word`, `stripword` FROM `dictionary` ORDER BY `stripword` ASC LIMIT 20"
            do {
                for row in try self.database.prepare(query) {
                    let item = DictionaryItem(row: row)
                    rows.append(item)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        return rows
    }
    
    func queryWord(constraint : String) -> [DictionaryItem]! {
        var rows : [DictionaryItem]! = [DictionaryItem]()
        var searchword : String = ""
        
        if openDatabase(){
            searchword = searchword.replacingOccurrences(of: "'", with: "''").replacingOccurrences(of: "_", with: "")
            if (constraint.contains("?")) || (constraint.contains("*")) {
                searchword = constraint.replacingOccurrences(of: "?", with: "_")
                searchword = constraint.replacingOccurrences(of: "*", with: "%")
            } else {
                searchword = constraint + "%"
            }
            
            let query = "SELECT `_id`, `word`, `stripword` FROM `dictionary` WHERE `word` LIKE '\(searchword)' ORDER BY `stripword` ASC"
            
            do {
                for row in try self.database.prepare(query) {
                    let item = DictionaryItem(row: row)
                    rows.append(item)
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return rows
    }
    
    func queryDefinition(id: Int64) -> DictionaryItem? {
        var item : DictionaryItem? = nil
        
        if id == 0 {
            return item
        }
        
        if openDatabase() {
            let query = "SELECT `_id`, `word`, `stripword`, `title`, `definition`, `keywords`, `synonym`, `picture` " +
            "FROM `dictionary` WHERE `_id` IS '\(id)';"
            
            do {
                for row in try self.database.prepare(query) {
                    item = DictionaryItem(row: row)
                    break
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
        return item
    }
    
}
