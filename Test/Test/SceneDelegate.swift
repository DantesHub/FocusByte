//
//  SceneDelegate.swift
//  Test
//
//  Created by Laima Cernius-Ink on 3/24/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

var isActive = false
var dateResignActive : Date?
var dateAppDidBack : Date?
var sceneTimer = Timer()
var killDate = Date()
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let winScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: winScene)
        let nc =  UINavigationController(rootViewController: WelcomeViewController())
        IQKeyboardManager.shared.enable = true
        self.window?.overrideUserInterfaceStyle = .light
        window?.rootViewController = nc
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        print("scene did disconnect")
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
//        let defaults = UserDefaults.standard
//        let status = defaults.string(forKey: "status")
        isActive = true
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        isActive = false
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        sceneTimer.invalidate()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        //allow brightnesss of screen to equal 0 if phone locks
        do {
            sleep(1)
        }
        killDate = Date().addingTimeInterval(10000000)
         if isPlaying && UIScreen.main.brightness != 0 && counter > 6 && deepFocusMode == true{
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "Come back!"
            content.body = "If you don't come back the treasure will be lost!"
            // Step 3: Create the notification trigger
            killDate = Date().addingTimeInterval(9)
            let date = Date().addingTimeInterval(6)
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            // Step 4: Create the request
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            // Step 5: Register the request
            center.add(request) { (error) in }

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
        //if screen == 0, should always display
        if (isPlaying) && (UIScreen.main.brightness == 0){
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "Focus Session Complete!"
            content.body = "We found something you'll like!"
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
    }
    
}



