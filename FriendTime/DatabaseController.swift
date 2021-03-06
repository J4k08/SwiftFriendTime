//
//  DatabaseController.swift
//  FriendTime
//
//  Created by Jakob Haglöf on 2017-03-10.
//  Copyright © 2017 Jakob Haglöf. All rights reserved.
//

import Foundation
import CoreData

class DatabaseController {
    
    
    private init(){
        
    }
    
    class func getContext() -> NSManagedObjectContext {
        return DatabaseController.persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    
    static var persistentContainer: NSPersistentContainer = {
        
        
        let container = NSPersistentContainer(name: "FriendTime")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    class func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    class func getAllFriends () -> [Friend]{
        
        var arrayOfFriends : [Friend] = []
        
        let fetchRequest : NSFetchRequest<Friend> = Friend.fetchRequest()
        
        do{
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            
            if(searchResults.count > 0){
                
                for friend in searchResults {
                    
                    print(friend.firstName!)
                    arrayOfFriends.append(friend)
                }
                
            }else {
                print("No friends in Datacore")
            }
        }
        catch {
            print("DatabaseController: Error with request \(error)")
        }
        
        return arrayOfFriends
    }
    
    class func getSpecificFriend(firstName : String, surName : String) -> Friend? {
        
        let fetchRequest : NSFetchRequest<Friend> = Friend.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "firstName == '\(firstName)' && surName == '\(surName)'")
        
        do {
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            
            if(searchResults.count == 1) {
                
                return searchResults[0]
                
            } else {
                print("No friends found")
            }
        }
        catch {
            print("errror!!!")
        }
        
        return nil
    }
    
    class func removeFriend(firstName : String, surName : String) {
        
        
        let fetchRequest : NSFetchRequest<Friend> = Friend.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "firstName == '\(firstName)' && surName == '\(surName)'")
        do{
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            
            if(searchResults.count == 1) {
                
                print(searchResults[0])
                
                DatabaseController.getContext().delete(searchResults[0])
                DatabaseController.saveContext()
                
            } else {
                print("No Friend-Object found")
            }
            
        }catch {
            print("Error with request \(error)")
        }
        
    }
    
    class func updateTime(friend : Friend) {
        
        let currentTime = Date()
        
        friend.timeSinceMeet = currentTime.timeIntervalSinceReferenceDate
        DatabaseController.saveContext()
    }
    
    class func getAllMeetings(friend : Friend) -> [Meeting] {
        
        var arrayOfMeetings : [Meeting] = []
        
        for item in friend.relationship! {
            
            arrayOfMeetings.append(item as! Meeting)
            
            print(item)
        }
        
        return arrayOfMeetings
        
    }
}
