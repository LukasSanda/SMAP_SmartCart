//
//  DatabaseService.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 02/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import CoreData

// MARK: - Protocol
internal protocol DatabaseService {
    var viewContext: NSManagedObjectContext { get }
    func save()
    func removeAll(_ completion: @escaping (Result<Void, Error>) -> Void)
    func removeObject(_ object: NSManagedObject, _ completion: @escaping (Result<Void, Error>) -> Void)
}

// MARK: - Protocol Implementation
internal class DatabaseServiceImpl: DatabaseService {
    
    // MARK: - Properties
    
    internal var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ItemModel")

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                logger.logError(
                    inFunction: "persistentContainer",
                    message: error.localizedDescription)
            }
        })
        return container
    }()
    
    // MARK: - Initialization
    
    internal init() { }
    
    // MARK: - Protocol
    
    internal func save() {
        self.saveContext()
    }
    
    func removeAll(_ completion: @escaping (Result<Void, Error>) -> Void) {
        self.removeAllData { result in
            completion(result)
        }
    }
    
    func removeObject(_ object: NSManagedObject, _ completion: @escaping (Result<Void, Error>) -> Void) {
        self.remove(object) { result in
            completion(result)
        }
    }
}

// MARK: - Implementation of Methods
private extension DatabaseServiceImpl {
    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch let error {
                logger.logError(
                    inFunction: "saveContext",
                    message: "Problem with saving Core Data. \(error)")
            }
        }
    }
    
    func removeAllData(_ completion: @escaping (Result<Void, Error>) -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try viewContext.execute(deleteRequest)
            
            if viewContext.deletedObjects.count > 0 {
                try viewContext.save()
            }
            
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func remove(_ object: NSManagedObject, _ completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            viewContext.delete(object)
            try viewContext.save()
            completion(.success(()))
            
        } catch let error {
            completion(.failure(error))
        }
    }
}
