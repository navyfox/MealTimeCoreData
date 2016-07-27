//
//  CoreDataStack.swift
//  MealTime
//
//  Created by Игорь Михайлович Ракитянский on 27.07.16.
//  Copyright © 2016 Ivan Akulov. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {

    let modelName = "MealTime"

//обозначили адрес где будет храится файл
    private lazy var appDocDir: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DesktopDirectory, inDomains: .UserDomainMask)
        return urls[urls.count - 1]
    }()

//создаем managedObjectContext
    lazy var context: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()

//создаем persistentStoreCoordinator
    private var persistentStoreCoordinator: NSPersistentStoreCoordinator {
        let cordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.appDocDir.URLByAppendingPathComponent(self.modelName)

        do {
            // options True - соединение баз данных, мы можем обьединить модели
            let options = [NSMigratePersistentStoresAutomaticallyOption: true]
            try cordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options)
        } catch {
            print("Can't add persistent store")
        }
        return cordinator
    }

//создаем managedObjectModel
    private lazy var managedObjectModel: NSManagedObjectModel = {
        //берем данные
        let modelUrl = NSBundle.mainBundle().URLForResource(self.modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelUrl)!
    }()

//func позволяет сохранить изменения в context
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
                abort()
            }
        }
    }
}