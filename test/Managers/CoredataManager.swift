//
//  CoredataManager.swift
//  test
//
//  Created by Admin on 05/12/2021.
//

import Foundation
import CoreData

class CoredataManager {
    private init() {}
    
    static private var shareInstance: CoredataManager?
    static var shared: CoredataManager {
        if shareInstance == nil { shareInstance = CoredataManager() }
        return shareInstance!
    }

    lazy var persistentContainer: NSPersistentContainer? = {
        let container: NSPersistentContainer? = NSPersistentContainer(name: "test")
        container?.loadPersistentStores(completionHandler: { (storeDescription, error) in })
        return container
    }()
    
    func configure() {
        persistentContainer?.viewContext.undoManager?.disableUndoRegistration()
    }

    func saveContext() -> Bool {
        if let persistentContainer = persistentContainer {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                    return true
                } catch {
                    return false
                }
            }
        }
        return true
    }
}
