//
//  CoreDataManager.swift
//  engmyan
//
//  Created by Soe Minn Minn on 10/8/18.
//  Copyright © 2018 S16. All rights reserved.
//

import Foundation
import Cocoa
import CoreData

extension NSViewController {
    
    var managedObjectContext: NSManagedObjectContext? {
        get {
            return CoreDataManager.shared.managedObjectContext
        }
    }
    
}

class CoreDataManager: NSObject {

    private var _viewContext: NSManagedObjectContext?
    
    open class var shared: CoreDataManager {
        struct Static {
            static let instance: CoreDataManager = CoreDataManager()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        
        guard let modelURL = Bundle.main.url(forResource: "UserDataModel", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        
        self._viewContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        self._viewContext?.persistentStoreCoordinator = psc
        
        guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("Unable to resolve document directory")
        }
        let storeURL = docURL.appendingPathComponent("UserDataModel.sqlite")
        
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
    }
    
    var managedObjectContext: NSManagedObjectContext? {
        get {
            return self._viewContext
        }
    }
    
    public func fetchedResults(forEntityName name: String, filter: NSPredicate? = nil, sortBy: [NSSortDescriptor]? = nil) -> NSFetchedResultsController<NSFetchRequestResult>? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: name, in: self.managedObjectContext!)
        
        if let predicate = filter {
            fetchRequest.predicate = predicate
        }
        
        if let sortDescriptors = sortBy {
            fetchRequest.sortDescriptors = sortDescriptors
        } else {
            fetchRequest.sortDescriptors = []
        }
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: name)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        return fetchedResultsController
    }
    
    public func saveAll<T: NSManagedObject>(_ items: [T]) {
        let entityName: String = NSStringFromClass(T.self)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try self.managedObjectContext?.execute(deleteRequest)
            if items.count > 0 {
                try self.managedObjectContext?.save()
            }
        } catch {
            print(error.localizedDescription)
            self.managedObjectContext?.rollback()
        }
    }
    
    public func deleteAll(forEntityName name: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        var result = false
        
        do {
            try self.managedObjectContext?.execute(deleteRequest)
            result = true
        } catch {
            print(error.localizedDescription)
            self.managedObjectContext?.rollback()
        }
        
        return result
    }
}
