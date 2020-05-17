//
//  SceneDelegate.swift
//  Test
//
//  Created by Laima Cernius-Ink on 3/24/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit
var isActive = false
var dateResignActive : Date?
var dateAppDidBack : Date?
var sceneTimer = Timer()

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let winScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: winScene)
        let nc =  UINavigationController(rootViewController: WelcomeViewController() )
        window?.rootViewController = nc
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        print("scene did disconnect")
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        let defaults = UserDefaults.standard
        let status = defaults.string(forKey: "status")
    
        isActive = true
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        isActive = false
        
    }
    
    

    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        sceneTimer.invalidate()
    }
    @objc func decrementCounter() {
        print("counter")
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("entered backgroundd")
        do {
            sleep(1)
        }
        print("Jump up and down \(UIScreen.main.brightness)")
         if isPlaying && UIScreen.main.brightness != 0 {
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "Come back!"
            content.body = "If you don't come back the treasure will be lost!"
            // Step 3: Create the notification trigger
            let date = Date().addingTimeInterval(7)
            //add 5 seconds to this to notification observer, to kil chest
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            // Step 4: Create the request
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            // Step 5: Register the request
            center.add(request) { (error) in }
                // Check the error parameter and handle any errors
            
         } else if breakPlaying {
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "Break Times Up!"
            content.body = "Lets get back to work!"
            // Step 3: Create the notification trigger
            let date = Date().addingTimeInterval(Double(counter - 1))
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            // Step 4: Create the request
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            // Step 5: Register the request
            center.add(request) { (error) in }
        }
        if (isPlaying) {
            let center = UNUserNotificationCenter.current()
            center.removeAllDeliveredNotifications() // To remove all delivered notifications
            center.removeAllPendingNotificationRequests()
            let content = UNMutableNotificationContent()
            content.title = "Focus Session Complete!"
            content.body = "We found something you'll like!"
            // Step 3: Create the notification trigger
            let date = Date().addingTimeInterval(Double(counter - 1))
            print("locked screen counter \(counter)")
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            // Step 4: Create the request
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            // Step 5: Register the request
            center.add(request) { (error) in }
        }
    }
    
}



