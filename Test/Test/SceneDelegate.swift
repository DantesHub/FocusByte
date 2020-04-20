//
//  SceneDelegate.swift
//  Test
//
//  Created by Laima Cernius-Ink on 3/24/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let winScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: winScene)
        let nc = UINavigationController(rootViewController:   WelcomeViewController())
      
        window?.rootViewController = nc
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
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
        print(status)
        
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        DispatchQueue.global(qos: .background).async {
                      DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) {
                     let defaults = UserDefaults.standard
                     defaults.set("exited", forKey: "status")
                  }
                 }
        let center = UNUserNotificationCenter.current()
                 let content = UNMutableNotificationContent()
                      content.title = "Come back!"
                      content.body = "If you don't come back the treasure will be lost!"
                      
                      // Step 3: Create the notification trigger
                      let date = Date().addingTimeInterval(10)
                      
                      let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                      
                      let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                      
                      // Step 4: Create the request
                      
                      let uuidString = UUID().uuidString
                      
                      let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                      
                      // Step 5: Register the request
                      center.add(request) { (error) in
                          // Check the error parameter and handle any errors
                      }
                  

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
     
           
                // do something in background
           
           
            
        }
        
        
        
        
    }
    }




