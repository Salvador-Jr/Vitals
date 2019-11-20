//
//  DataStack.swift
//  Vitals
//
//  Created by Mariecor Maranoc on 11/19/19.
//  Copyright © 2019 009252542SalvadorRodriguez. All rights reserved.
//

import CoreData



class DataStack {
    
    
    
    static let persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Running")
        
        container.loadPersistentStores { (_, error) in
            
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
                
            }
            
        }
        
        return container
        
    }()
    
    
    
    static var context: NSManagedObjectContext { return persistentContainer.viewContext }
    
    
    
    class func saveContext () {
        
        let context = persistentContainer.viewContext
        
        
        
        guard context.hasChanges else {
            
            return
            
        }
        
        
        
        do {
            
            try context.save()
            
        } catch {
            
            let nserror = error as NSError
            
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            
        }
        
    }
    
}
