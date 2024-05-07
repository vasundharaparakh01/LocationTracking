/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Singleton controller to manage the main Core Data stack for the application. It vends a persistent store coordinator, the managed object model, and a URL for the persistent store.
 */


import CoreData

class CoreDataStackManager {
    
    // MARK: Properties
    static let sharedManager = CoreDataStackManager()
    
    private init() {} // Prevent clients from creating another instance.
    
    // MARK: - Core Data stack
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "AdTrak")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    @available(iOS 10.0, *)
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension CoreDataStackManager {
    
    func saveCurrentTrackData(with data: TrackID, lat: Double, long: Double, polyline: String) {
        let context             = self.persistentContainer.viewContext
        let entity              = NSEntityDescription.entity(forEntityName: "UserLatLong", in: context)
        let fetchRequest        = NSFetchRequest<NSFetchRequestResult>(entityName: "UserLatLong")
        fetchRequest.predicate  = NSPredicate(format: "trackingid = %@", data.trackingid  ?? "")
        // Execute Fetch Request
        let records = try! context.fetch(fetchRequest)
        let managedObject   = ( records.count != 0) ?  (records[0] as! NSManagedObject) : NSManagedObject(entity: entity!, insertInto: context)
        managedObject.setValue(data.polyline, forKey: "polyline")
        managedObject.setValue(data.trackingid, forKey: "trackingid")
        managedObject.setValue(data.jobId, forKey: "jobId")
        managedObject.setValue(data.lat, forKey: "lat")
        managedObject.setValue(data.long, forKey: "long")
        managedObject.setValue(data.dictionaryRepresentation().jsonString, forKey: "data")
//        print("DATA :--\(data.dictionaryRepresentation().jsonString ?? "")")
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func getCurrentTrackData() -> [TrackID] {
        let fetchRequest        = NSFetchRequest<NSFetchRequestResult>(entityName: "UserLatLong")
        var result              = [TrackID]()
        let context             = self.persistentContainer.viewContext
        do {
            if let fetchResult = try context.fetch(fetchRequest) as? [UserLatLong] {
                for object in fetchResult {
                    let data        = (object as AnyObject).value(forKey: "data") as? String
                    if let dict     = data?.toDictionary(),
                        let trackObj   = TrackID(dictionary: dict) {
                        result.append(trackObj)
                    }
                }
            }
        } catch let error as NSError {
            print(error.description)
        }
        return result
    }
    
    func deleteCurrentTrack(trackingid: String) {
        let context             = self.persistentContainer.viewContext
        let fetchRequest        = NSFetchRequest<NSFetchRequestResult>(entityName: "UserLatLong")
        let predicate           = NSPredicate(format: "trackingid = %@",trackingid)
        fetchRequest.predicate  = predicate
        let deleteRequest       = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }
    
}
