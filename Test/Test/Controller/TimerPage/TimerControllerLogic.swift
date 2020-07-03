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
import TinyConstraints
import StoreKit
var requestedReview = false
extension TimerController {
    //MARK: - Helper Functions
    func createObservers() {
        print("create observers")
        NotificationCenter.default.addObserver(self, selector: #selector(pauseWhenBackground(noti:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(noti:)), name:
            UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkIfLocked(noti:)), name: UIApplication.protectedDataWillBecomeUnavailableNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkIfNotLocked(noti:)), name: UIApplication.protectedDataDidBecomeAvailableNotification, object: nil)
    }
    
    @objc func checkIfLocked(noti: Notification) {
        print("locked")
         if !breakPlaying {
        locked = true
         killDate = Date().addingTimeInterval(10000000)
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
        //cancel all notifcations and create finish notif
        if isPlaying {
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
    @objc func checkIfNotLocked(noti: Notification) {
        print("unlocked")
//        if onHome == false && isPlaying == true && counter > 6 && deepFocusMode == true{
//            let center = UNUserNotificationCenter.current()
//            let content = UNMutableNotificationContent()
//            content.title = "Come back!"
//            content.body = "If you don't come back the treasure will be lost!"
//            // Step 3: Create the notification trigger
//            killDate = Date().addingTimeInterval(11)
//            let date = Date().addingTimeInterval(7)
//            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//            // Step 4: Create the request
//            let uuidString = UUID().uuidString
//            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
//            // Step 5: Register the request
//            center.add(request) { (error) in }
//        }
    }
    
    //MARK: - timer functions
    func countDownTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(incrementCount), userInfo: nil, repeats: true)
    }
    
    @objc func killChest() {
        isPlaying = false
        self.timer.invalidate()
        self.twoButtonSetup()
        self.imageView?.image = UIImage(named: "sinkingShip")
        self.timeL.text = "We Lost The Chest :("
        isPlaying = false
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
        breakL.center.y = view.center.y - 250
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
        if counter < 0 {
            self.timer.invalidate()
        }
    }
    
    //MARK: - Read & Write to firebase
    func focusTimerComplete() {
        isPlaying = false
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        self.timer.invalidate()
        if enteredForeground {
            self.timeL.text = "You found..."
            self.timeL.font = UIFont(name: "Menlo-Bold", size: 20)
        }
        var numCoins = 0

        //read data from firebase
        if UserDefaults.standard.bool(forKey: "isPro") == true {
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
                        if timeData.count != 0 {
                            self.lastDate = (timeData[timeData.count - 1])
                        }
                    }
                    if let itemArray = document["inventoryArray"] {
                        inventoryArray = itemArray as! [String]
                    }
   
                    //Check if last entry is equal to today
                    //if last entry is, then we just need to add time to it
                    //if not we have to create a new date
                    
                    coins = self.updateCoinLabel(numCoins: numCoins)!
                    self.coinsL.text = String(coins)
                    if timeData.count == 13 || timeData.count == 23 || timeData.count == 53 {
                        if requestedReview == false {
                            SKStoreReviewController.requestReview()
                            requestedReview = true
                        }
                    }
                    self.addDateToDb()
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
                                print("Succesfully saved")
                                self.timeL.removeFromSuperview()
                                self.twoButtonSetup()
                                self.imageView?.image = UIImage(named: "\(self.chest)-open")
                                self.timeL.text = "Look at all \nthis Loot!"
                                self.view.addSubview(self.timeL)
                                enteredForeground = false
                                self.saveToRealm()
                            }
                        }
                    }
                } else {
                    print("Document does not exist")
        
                }
            }
        }
        }
        if UserDefaults.standard.bool(forKey: "isPro") == false {
            coins = self.updateCoinLabel(numCoins: coins)!
            self.coinsL.text = String(coins)
            self.timeL.removeFromSuperview()
            self.twoButtonSetup()
            self.imageView?.image = UIImage(named: "\(self.chest)-open")
            self.timeL.text = "Look at all \nthis Loot!"
            self.view.addSubview(self.timeL)
            enteredForeground = false
            if timeData.count != 0 {
                if timeData.count == 2 || timeData.count == 10 || timeData.count == 25 {
                    if requestedReview == false {
                        SKStoreReviewController.requestReview()
                        requestedReview = true
                    }
                }
                lastDate = (timeData[timeData.count - 1])
            } else {
                lastDate = ""
            }
            addDateToDb()
            self.saveToRealm()
        }
      
        return
    }
    
    private final func addDateToDb() {
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
    }
    
//    //MARK: - Alert Func
    func createAlert(leveled: Bool = false, evolved:Int = 0) {
        let appearance = SCLAlertView.SCLAppearance(
            kWindowWidth: 300,
            kWindowHeight:evolved == 15 || evolved == 34 ? 400 : 300,
            kButtonHeight: 50,
            kTitleFont: UIFont(name: "Menlo-Bold", size: 25)!,
            kTextFont: UIFont(name: "Menlo", size: 15)!,
            showCloseButton: false,
            showCircularIcon: false,
            hideWhenBackgroundViewIsTapped: true,
            titleColor: brightPurple
        )
        let alertView = SCLAlertView(appearance: appearance)
        let subview = UIView(frame: CGRect(x:0,y:0,width:300,height: evolved == 15 || evolved == 34 ? 300 : 200))
        if evolved != 15 && evolved != 34 {
            let expDesc = UILabel()
                  expDesc.translatesAutoresizingMaskIntoConstraints = false
                  let coinDesc = UILabel()
                  let plusOne = UIImageView()
                  plusOne.translatesAutoresizingMaskIntoConstraints = false
                  coinDesc.translatesAutoresizingMaskIntoConstraints = false
                  expDesc.font = UIFont(name: "Menlo", size: 25)
                  expDesc.text = "\(expReceived!) exp"
                  expDesc.sizeToFit()
                  coinDesc.font = UIFont(name: "Menlo", size: 25)
                  coinDesc.text = "\(coinsReceived!) coins"
                  coinDesc.sizeToFit()

                  subview.addSubview(expImageView)
                  if leveled {
                            subview.addSubview(plusOne)
                            plusOne.contentMode = .scaleAspectFill
                            plusOne.image = UIImage(named: "plusOne")
                            plusOne.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 60).isActive = true
                      plusOne.width(subview.frame.width * 0.50)
                            plusOne.topAnchor.constraint(equalTo: subview.topAnchor, constant: 0).isActive = true
                        }
                  expImageView.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 30).isActive = true
                  expImageView.topAnchor.constraint(equalTo: subview.topAnchor, constant: leveled ? 60 : 30).isActive = true
                  subview.addSubview(coinImageView)
                  coinImageView.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 40).isActive = true
                  coinImageView.topAnchor.constraint(equalTo: expImageView.bottomAnchor, constant: 30).isActive = true
                  subview.addSubview(expDesc)
                  expDesc.leadingAnchor.constraint(equalTo: expImageView.trailingAnchor, constant: 20).isActive = true
                  expDesc.topAnchor.constraint(equalTo: subview.topAnchor, constant: leveled ? 70 : 40).isActive = true
                  subview.addSubview(coinDesc)
                  coinDesc.leadingAnchor.constraint(equalTo: coinImageView.trailingAnchor, constant: 26).isActive = true
                  coinDesc.topAnchor.constraint(equalTo: expImageView.bottomAnchor, constant: 30).isActive = true
        } else {
            let evolvedImageView = UIImageView()
            evolvedImageView.translatesAutoresizingMaskIntoConstraints = false
            if evolved == 34 && gender == "male" {
                evolvedImageView.image = UIImage(named: "defaultMan")
                evolvedImageView.height(300)
            } else if evolved == 34 && gender == "female" {
                evolvedImageView.image = UIImage(named: "defaultWoman")
            } else if evolved == 15 && gender == "female"{
                evolvedImageView.image = UIImage(named: "defaultGirl")
            } else {
                evolvedImageView.image = UIImage(named: "defaultBoy")
            }
            subview.addSubview(evolvedImageView)
            evolvedImageView.centerY(to: subview)
            evolvedImageView.centerX(to: subview)
            alertView.addButton("Share", backgroundColor: darkPurple, textColor: .white, showTimeout: .none) {
                let imgToShare = evolvedImageView.image
                let myURL = URL(string: "https:/focusbyte.io")
                let objectToshare = [imgToShare!, myURL!] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectToshare, applicationActivities: nil)
                activityVC.excludedActivityTypes = [UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.postToTwitter, UIActivity.ActivityType.message, UIActivity.ActivityType.saveToCameraRoll]
                activityVC.popoverPresentationController?.sourceView = self.view
                self.present(activityVC, animated: true, completion: nil)
                return
            }
        }


        alertView.customSubview = subview
        alertView.addButton("OK", backgroundColor: brightPurple, textColor: .white, showTimeout: .none) {
            return
        }
        alertView.showCustom(evolved == 15 || evolved == 34 ? "You EVOLVED!" : leveled ? "Look who's growing!":"You Got...", subTitle: "", color: .white, icon: UIImage())
    }
    
    
    //MARK: - pause & enter funcs
    @objc func pauseWhenBackground(noti: Notification) {
        print("pause")
        enteredForeground = false
        if isPlaying {
            self.timer.invalidate()
            let shared = UserDefaults.standard
            shared.set(Date(), forKey: "savedTime")
//            pauseLayer(layer: trackLayer)
        } else if breakPlaying {
            self.breakTimer.invalidate()
            let shared = UserDefaults.standard
            shared.set(Date(), forKey: "savedBreakTime")
        }

    }
    
    
    @objc func willEnterForeground(noti: Notification) {
        print("entered foreground")
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
                self.refresh(mins: diffMins, secs: diffSecs)
            }
            
        } else if breakPlaying {
            let center = UNUserNotificationCenter.current()
            center.removeAllDeliveredNotifications() // To remove all delivered notifications
            center.removeAllPendingNotificationRequests()
            if let savedDate = UserDefaults.standard.object(forKey: "savedBreakTime") as? Date {
                (self.diffMins, self.diffSecs) = TimerController.getTimeDifference(startDate: savedDate)
                self.refresh(mins: diffMins, secs: diffSecs)
            }
        }
    }
    
    func refresh (mins: Int, secs: Int) {
        print("refresh difference \(mins) \(secs)")
        self.mins -= mins
        self.secs -= secs
        counter = (self.mins * 60) + self.secs
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
//            resumeLayer(layer: trackLayer)
            self.timeL.text = "\(String(self.mins)):\(secsString)"
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.incrementCount), userInfo: nil, repeats: true)
        //break time
        } else if breakPlaying {
            if counter <= 0 {
                breakL.text = "Break time is up!"
                breakPlaying = false
                self.breakTimer.invalidate()
                return
            }
            if mins <= 0 && secs <= 0{
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
        return (components.minute!, components.second!)
    }
    
    //MARK: - realm
    func saveToRealm() {
        results = uiRealm.objects(User.self)
        for result  in results {
            if result.isLoggedIn == true {
                do {
                    try uiRealm.write {
                        result.setValue(coins, forKey: "coins")
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
