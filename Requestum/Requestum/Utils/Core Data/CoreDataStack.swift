//
//  CoreDataStack.swift
//  Requestum
//
//  Created by Cong Viet Ho on 7/31/19.
//  Copyright © 2019 Viety Software. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStack {
    let modelName = "Requestum"
    
    static let shared = CoreDataStack()
    private init() {}
    
    // MARK: - Persistent Container
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error. \nReinstall the app.")
            }
        }
        return container
    }()
    
    // MARK: - Managed Object Contexts
    private(set) lazy var mainManagedObjectContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    private(set) lazy var backgroundManagedObjectContext: NSManagedObjectContext = {
        let backgroundManagedObjectContext = persistentContainer.newBackgroundContext()
        backgroundManagedObjectContext.automaticallyMergesChangesFromParent = true
        return backgroundManagedObjectContext
    }()
    
    //MARK: - Save Context
    func saveContext() {
        CoreDataStack.shared.backgroundManagedObjectContext.performAndWait {
            do {
                if CoreDataStack.shared.backgroundManagedObjectContext.hasChanges {
                    try CoreDataStack.shared.backgroundManagedObjectContext.save()
                }
            } catch {
                print("Unable to Save Changes of Background Managed Object Context")
                print("\(error), \(error.localizedDescription)")
            }
        }
        
        CoreDataStack.shared.mainManagedObjectContext.perform {
            do {
                if CoreDataStack.shared.mainManagedObjectContext.hasChanges {
                    try CoreDataStack.shared.mainManagedObjectContext.save()
                }
            } catch {
                print("Unable to Save Changes of Main Managed Object Context")
                print("\(error), \(error.localizedDescription)")
            }
        }
    }
    
    
}

