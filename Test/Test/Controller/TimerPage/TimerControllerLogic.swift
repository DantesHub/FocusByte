//
//  TimerControllerLogic.swift
//  Test
//
//  Created by Dante Kim on 5/21/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import RealmSwift
import FLAnimatedImage
import AudioToolbox
import SCLAlertView


extension TimerController {
    //MARK: - Helper Functions
    func createObservers() {
         NotificationCenter.default.addObserver(self, selector: #selector(pauseWhenBackground(noti:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(noti:)), name: UIApplication.willEnterForegroundNotification, object: nil)
     }
    
    //MARK: - timer functions
    func countDownTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(incrementCount), userInfo: nil, repeats: true)
    }
    
    @objc func killChest() {
        isPlaying = false
        self.timer.invalidate()
        self.twoButtonSetup()
        self.imageView?.image = #imageLiteral(resourceName: "boyToddler")
        self.timeL.text = "We Lost The Chest :("
        timer.invalidate()
        return
    }
    
    func startBreakTimer() {
        self.breakTimer.invalidate()
        breakPlaying = true
        createStartUI()
        view.addSubview(breakL)
        breakL.font = UIFont(name: "Menlo", size: 25)
        breakL.textAlignment = .center
        breakL.textColor = .white
        breakL.frame.size.width = 200
        breakL.frame.size.height = 100
        breakL.numberOfLines = 2
        breakL.center.x = view.center.x
        breakL.center.y = view.center.y - 260
        breakL.lineBreakMode = .byClipping
        breakL.text = "Starting..."
        quoteLabel.removeFromSuperview()
        var factor = 0
        switch (String(breakTime[1])) {
        case "minutes":
            factor = 60
        case "seconds":
            factor = 1
        default:
            factor = 360
        }
        counter = Int(String(breakTime[0]))! * factor
        self.breakTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(incrementBreakCount), userInfo: nil, repeats: true)
    }
    @objc func incrementBreakCount() {
        counter -= 1
        if counter == 0 {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            breakL.text = "Break time is up!"
            self.breakTimer.invalidate()
            breakPlaying = false
            return
        }
        self.mins = counter/60
        self.secs = counter%60
        let minutes = String(counter/60)
        var seconds = String(counter%60)
        if Int(seconds)! < 10 {
            seconds = "0" + seconds
        }
        breakL.text = "Break Time\n\(minutes):\(seconds)"
        
    }
    
    @objc func incrementCount() {
        counter -= 1
        if counter == 0 {
            focusTimerComplete()
            return
        }
        self.mins = counter/60
        self.secs = counter%60
        let minutes = String(self.mins)
        var seconds = String(self.secs)
        if Int(seconds)! < 10 {
            seconds = "0" + seconds
        }
        timeL.text = "\(minutes):\(seconds)"
    }
    
    //MARK: - Read & Write to firebase
    func focusTimerComplete() {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        self.timer.invalidate()
        print("entered foreground \(enteredForeground)")
        if enteredForeground {
            self.timeL.text = "You found..."
            self.timeL.font = UIFont(name: "Menlo-Bold", size: 20)
        }
        var numCoins = 0
        var lastDate = ""
        var totalTimeForDay = ""
        var fbDate = ""
        var totalSessionsForDay = ""
        //read data from firebase
        if let _ = Auth.auth().currentUser?.email {
            let email = Auth.auth().currentUser?.email
            let docRef = self.db.collection(K.FStore.collectionName).document(email!)
            //Read Data from firebase, for syncing
            docRef.getDocument { (snapshot, error) in
                if let document = snapshot, document.exists {
                    if let c = document["coins"] {
                        numCoins = c  as! Int
                    }
                    if let xp = document["exp"] {
                        exp = xp as! Int
                    }
                    if let time = document["TimeData"] {
                        timeData = time as! [String]
                        lastDate = (timeData[timeData.count - 1])
                    }
   
                    coins = self.updateCoinLabel(numCoins: numCoins)!
                    self.coinsL.text = String(coins)
                    //Check if last entry is equal to today
                    //if last entry is, then we just need to add time to it
                    //if not we have to create a new date
                    let dateFormatterGet = DateFormatter()
                    dateFormatterGet.dateFormat = "MMM d,yyyy E"
                    if lastDate != "" {
                        let equalIndex = lastDate.firstIndex(of: "=")
                        let equalIndexOffset = lastDate.index(equalIndex!, offsetBy: 1)
                        let plusIndex = lastDate.firstIndex(of: "+")
                        let dashIndex = lastDate.firstIndex(of: "-")
                        let dashIndexOffset = lastDate.index(dashIndex!, offsetBy: 1)
                        var idx = 0
                        var finalProduct = ""
                        fbDate = String(lastDate[..<equalIndex!])
                        
                        //date already exists
                        if dateFormatterGet.string(from: Date()) == fbDate {
                            totalTimeForDay = String(lastDate[equalIndexOffset..<dashIndex!])
                            let totalTimeInt = Int(totalTimeForDay)! + (self.howMuchTime/60)
                            totalSessionsForDay = String(Int(lastDate[dashIndexOffset..<plusIndex!])! + 1)
                            //Removing tag, adding time and putting it back into place
                            var tags = String(lastDate[plusIndex!...])
                            if let range: Range<String.Index> = tags.range(of: tagSelected) {
                                idx = tags.distance(from: tags.startIndex, to: range.upperBound) + 1
                                let indx = tags.index(tags.startIndex, offsetBy: idx)
                                let nonChoppedTags = String(tags[..<indx])
                                var choppedTags = String(tags[indx...])
                                let endIndex = String.Index(encodedOffset: choppedTags.count)
                                let pIndex = choppedTags.firstIndex(of: "+") ?? endIndex
                                let timeForTag  = String(choppedTags[..<pIndex])
                                var timeForTagInt = Int(timeForTag)!
                                let timeForTagLenIndex = String.Index(encodedOffset: timeForTag.count)
                                choppedTags.removeSubrange((choppedTags.startIndex..<timeForTagLenIndex))
                                timeForTagInt += self.howMuchTime/60
                                choppedTags.insert(contentsOf: "\(timeForTagInt)", at: choppedTags.startIndex)
                                finalProduct = nonChoppedTags + choppedTags
                            } else {
                                //first time using tag
                                tags.append(contentsOf: "+\(tagSelected)/\(self.howMuchTime/60)")
                                finalProduct = tags
                            }
                            
                            totalTimeForDay = String(totalTimeInt)
                            timeData[timeData.count - 1] = fbDate + "=" + totalTimeForDay + "-" + totalSessionsForDay + finalProduct
                        } else {
                            //first session for that day
                            fbDate = dateFormatterGet.string(from: Date())
                            totalTimeForDay = String(self.howMuchTime/60)
                            timeData.append(fbDate + "=" + totalTimeForDay + "-1" + "+\(tagSelected)/\(self.howMuchTime/60)")
                        }
                    } else {
                        //very first session of account
                        fbDate = dateFormatterGet.string(from: Date())
                        totalTimeForDay = String(self.howMuchTime/60)
                        timeData.append(fbDate + "=" + totalTimeForDay + "-1" + "+\(tagSelected)/\(self.howMuchTime/60)")
                    }
                    //update data in firebase
                    if let _ = Auth.auth().currentUser?.email {
                        let email = Auth.auth().currentUser?.email
                        self.db.collection(K.userPreferenes).document(email!).setData([
                            "coins": coins,
                            "exp": exp,
                            "TimeData": timeData
                        ], merge: true) { (error) in
                            if let e = error {
                                print("There was a issue saving data to firestore \(e) ")
                            } else {
                                self.saveToRealm()
                                print("Succesfully saved")
                            }
                        }
                    }
                    self.timeL.removeFromSuperview()
                    self.twoButtonSetup()
                    self.imageView?.image = #imageLiteral(resourceName: "chest-open")
                    self.timeL.text = "Great job! You found \(self.coinsReceived!) coins and gained \(self.expReceived!) exp"
                    self.timeL.font = UIFont(name: "Menlo-Bold", size: 20)
                    self.timeL.numberOfLines = 3
                    self.view.addSubview(self.timeL)
                    isPlaying = false
                    self.enteredForeground = false
                    self.createAlert()
                } else {
                    print("Document does not exist")
                }
            }
        }
        return
    }
    
    //MARK: - Alert Func
    func createAlert() {
        let appearance = SCLAlertView.SCLAppearance(
            kWindowWidth: 300,
            kWindowHeight: 300,
            kButtonHeight: 35,
            kTitleFont: UIFont(name: "Menlo", size: 18)!,
            kTextFont: UIFont(name: "Menlo", size: 15)!,
            showCloseButton: true,
            showCircularIcon: false,
            hideWhenBackgroundViewIsTapped: true
        )
        let alertView = SCLAlertView(appearance: appearance)
        let subview = UIView(frame: CGRect(x:0,y:0,width:300,height:100))
        alertView.customSubview = subview
        alertView.showCustom("You Got...", subTitle: "", color: .white, icon: UIImage())
    }
    
    
    //MARK: - pause & enter funcs
    @objc func pauseWhenBackground(noti: Notification) {
        enteredForeground = false
        if isPlaying {
            self.timer.invalidate()
            let shared = UserDefaults.standard
            shared.set(Date(), forKey: "savedTime")
            pauseLayer(layer: trackLayer)
        } else if breakPlaying {
            self.breakTimer.invalidate()
            let shared = UserDefaults.standard
            shared.set(Date(), forKey: "savedBreakTime")
        }
        
    }
    
    
    @objc func willEnterForeground(noti: Notification) {
        enteredForeground = true
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
        if isPlaying {
            if Date() >= killDate {
                killChest()
                return
            }
            
            if let savedDate = UserDefaults.standard.object(forKey: "savedTime") as? Date{
                (self.diffMins, self.diffSecs) = TimerController.getTimeDifference(startDate: savedDate)
                print(" willenterforeground, Min: \(diffMins), Sec: \(diffSecs)")
                self.refresh(mins: diffMins, secs: diffSecs)
            }
            
        } else if breakPlaying {
            let center = UNUserNotificationCenter.current()
            center.removeAllDeliveredNotifications() // To remove all delivered notifications
            center.removeAllPendingNotificationRequests()
            if let savedDate = UserDefaults.standard.object(forKey: "savedBreakTime") as? Date {
                (self.diffMins, self.diffSecs) = TimerController.getTimeDifference(startDate: savedDate)
                print(" willenterforeground, Min: \(diffMins), Sec: \(diffSecs)")
                self.refresh(mins: diffMins, secs: diffSecs)
            }
        }
    }
    
    func refresh (mins: Int, secs: Int) {
        self.mins -= mins
        self.secs -= secs
        counter = self.mins * 60 + self.secs
        self.mins = counter/60
        self.secs = counter%60
        var secsString = ""
        if (self.secs) < 10 {
            secsString = "0" + String(self.secs)
        } else {
            secsString = String(self.secs)
        }
        if isPlaying {
            if counter <= 0 {
                focusTimerComplete()
                return
            }
            self.timeL.text = "\(String(self.mins)):\(secsString)"
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.incrementCount), userInfo: nil, repeats: true)
        } else if breakPlaying {
            if counter <= 0 {
                breakL.text = "Break time is up!"
                breakPlaying = false
                self.breakTimer.invalidate()
                return
            }
            self.breakL.text = "Break Time\n\(String(self.mins)):\(secsString)"
            self.breakTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.incrementBreakCount), userInfo: nil, repeats: true)
        }
        
    }
    
    static func getTimeDifference(startDate: Date) -> (Int, Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute, .second], from: startDate, to: Date())
        print(components)
        return (components.minute!, components.second!)
    }
    
    //MARK: - realm
    func saveToRealm() {
        results = uiRealm.objects(User.self)
        for result  in results {
            if result.isLoggedIn == true {
                do {
                    try uiRealm.write {
                        result.setValue(Int(coinsL.text!)!, forKey: "coins")
                        result.setValue(exp, forKey: "exp")
                        result.setValue(deepFocusMode, forKey: "deepFocusMode")
                        result.setValue(timeData, forKey: "timeArray")
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}
