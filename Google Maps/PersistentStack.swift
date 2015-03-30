//
//  PersistentStack.swift
//  Google Maps
//
//  Created by Teddy Wyly on 2/5/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit
import CoreData

class PersistentStack: NSObject {
    
    let managedObjectContext: NSManagedObjectContext
    
    init(storeURL: NSURL, modelURL: NSURL) {
        managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: NSManagedObjectModel(contentsOfURL: modelURL)!)
        var error: NSError?
        managedObjectContext.persistentStoreCoordinator?.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error: &error)
        if let inValidError = error {
            //Log Error
        }
        managedObjectContext.undoManager = NSUndoManager()
    }
   
}
