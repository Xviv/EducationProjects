//
//  AppDelegate.swift
//  DoveChatApp
//
//  Created by Dan on 10.04.2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import UserNotifications
import OneSignal


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var user: User?
    let player = Player()
    
    var window: UIWindow?
    
    static let NOTIFICATION_URL = "https://gcm-http.googleapis.com/gcm/send"
    static var DEVICEID = String()
    
    static let SERVERKEY = "AAAACYLeuC0:APA91bFpGob2IOI4EFWbQJWpNfYzbtb2JF1euJB-aQM2LrbFguRTbtUHHY-BZU-9UjuQWsAyYKdUaaOW9xrM9PzxkzDVARVm2pRqUNX9L5u2LZe1e-nR7Svzsa1abDftjDeAu0j8V6QS"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        window = UIWindow(frame:UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: "hasRunBefore") == false {
            print("The app is launching for the first time. Setting UserDefaults...")
            
            do {
                try Auth.auth().signOut()
            } catch {
                
            }
            
            // Update the flag indicator
            userDefaults.set(true, forKey: "hasRunBefore")
            userDefaults.synchronize() // This forces the app to update userDefaults
            
            // Run code here for the first launch
            
        } else {
            print("The app has been launched before. Loading UserDefaults...")
            // Run code here for every other launch but the first
        }
        
        if Auth.auth().currentUser?.uid == nil {
//            window?.rootViewController = UINavigationController(rootViewController: IntroductionGuideController())
            window?.rootViewController = IntroductionGuideController()
        } else {
            window?.rootViewController = CustomTabBarController()
        }
        
        
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().delegate = self
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted,err) in })
            application.registerForRemoteNotifications()
        } else {
            let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notificationSettings)
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        return true
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        guard  let newToken = InstanceID.instanceID().token() else {return}
        AppDelegate.DEVICEID = newToken
        connectToFCM()
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let notification =  response.notification.request.content.body
        
        print(notification)
        
        completionHandler()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        guard let token = InstanceID.instanceID().token() else {return}
        
        AppDelegate.DEVICEID = token
        print("Вот токен!\(token)")
        connectToFCM()
        
    }
    
    func connectToFCM()
    {
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        if Auth.auth().currentUser?.uid != nil {
            
            let userId = Auth.auth().currentUser?.uid
            
            let ref = Database.database().reference().child("users").child(userId!).child("status")
            ref.setValue("false") // NO
        }
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {

        player.stop()
       
        if Auth.auth().currentUser?.uid != nil {
        
            let userId = Auth.auth().currentUser?.uid
            
            let ref = Database.database().reference().child("users").child(userId!).child("status")
            ref.setValue("true") // NO
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        if #available(iOS 10.0, *) {
            self.saveContext()
        } else {
            // Fallback on earlier versions
        }
    }
    
    // MARK: - Core Data stack
    
    @available(iOS 10.0, *)
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MessengerApp")
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
