//
//  DatabaseService.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 02/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import CoreData

internal class DatabaseService {
    
    // MARK: - Properties
    
    internal var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    internal lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ItemModel")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Initialization
    
    internal init() { }
    
    // MARK: - Methods
    
    /// Method for save Core Data.
    internal func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch let error {
                fatalError("ERROR: Problem with saving Core Data. \(error)")
            }
        }
    }
    
    /// Method for remove all data from Core Data.
    internal func removeAllData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Session")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try viewContext.execute(deleteRequest)
            
            if viewContext.deletedObjects.count > 0 {
                try viewContext.save()
            }
        } catch let error {
            fatalError("ERROR: Problem with removing all from Core Data. \(error)")
        }
    }
    
    
    /// Remove specific object from Core Data.
    ///
    /// - Parameter object: removing object
    internal func removeObject(object: NSManagedObject) {
        do {
            viewContext.delete(object)
            try viewContext.save()
        } catch let error {
            fatalError("ERROR: Problem with removing object from Core Data. \(error)")
        }
    }
}


