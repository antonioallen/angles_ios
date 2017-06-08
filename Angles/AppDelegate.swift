//
//  AppDelegate.swift
//  Angles
//
//  Created by Antonio Allen on 6/7/17.
//  Copyright © 2017 Antonio Allen. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ESTBeaconManagerDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var beaconManager = ESTBeaconManager()
    static var instance:AppDelegate?
    let beaconNotificationsManager = BeaconNotificationsManager()
    
    //Beacons
    var beacons:[Beacon] = [
        //Replace with your beacons here
        Beacon(_UUID: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", _major: 50390, _minor: 3173, _title: "Home", _description: "Welcome Home", _beaconType: BEACON_TYPE_HOME),
        
        Beacon(_UUID: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", _major: 46061, _minor: 2086, _title: "Work", _description: "Work Hard. Play Hard.", _beaconType: BEACON_TYPE_WORK),
        
        Beacon(_UUID: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", _major: 27631, _minor: 3004, _title: "Car", _description: "Vroom. Vroom.", _beaconType: BEACON_TYPE_CAR)
    ]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        AppDelegate.instance = self
        ESTConfig.setupAppID("angles-fk5", andAppToken: "cc199bbc29724ae209642862955c85ff")
        beaconManager.delegate = self
        
        self.beaconNotificationsManager.enableNotifications(
            for: BeaconID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major: 50390, minor: 3173),
            enterMessage: "Welcome Home. Please take a look at your tasks",
            exitMessage: "Heading Out? Make sure that you've got everything"
        )
        
        self.beaconNotificationsManager.enableNotifications(
            for: BeaconID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major: 46061, minor: 2086),
            enterMessage: "Ready for another day at work? Check your tasks remaining",
            exitMessage: "Phew, I'm sure your glad to head out!"
        )
        
        self.beaconNotificationsManager.enableNotifications(
            for: BeaconID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major: 27631, minor: 3004),
            enterMessage: "Ready for a drive? Check your task while I warm up",
            exitMessage: "Be safe!"
        )
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    //MARK: - Beacon
    func getBeaconManager() -> ESTBeaconManager {
        return beaconManager
    }
    
    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
        print("Beacon In Range")
        
        let uuid = region.proximityUUID.uuidString
        let major = region.major?.intValue ?? -1
        let minor = region.minor?.intValue ?? -1
        
        if major != -1 && minor != -1{
            print("Finding Match...")
            print("UUID: \(uuid)")
            print("Major: \(major)")
            print("Minor: \(minor)")
            self.findPopPod(uuid: uuid, major: major, minor: minor, podState: .entered)
        }
    }
    
    func beaconManager(_ manager: Any, didExitRegion region: CLBeaconRegion) {
        print("Beacon Out Of Range")
        
        let uuid = region.proximityUUID.uuidString
        let major = region.major?.intValue ?? -1
        let minor = region.minor?.intValue ?? -1
        
        if major != -1 && minor != -1{
            print("Finding Pod...")
            print("UUID: \(uuid)")
            print("Major: \(major)")
            print("Minor: \(minor)")
            self.findPopPod(uuid: uuid, major: major, minor: minor, podState: .exited)
        }
    }
    
    func findPopPod(uuid:String, major:Int, minor:Int, podState:PodState) {
        if podState == .entered{
            for (index, beacon) in self.beacons.enumerated(){
                if beacon.UUID == uuid && beacon.major == major && beacon.minor == minor{
                    print("Beacon Found: \(beacon.title)")
                    RootLocationTaskViewController.instance?.selectTab(tabIndex: index+1)
                }
            }
        }
    }
    

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Angles")
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

enum PodState {
    case entered, exited
}


