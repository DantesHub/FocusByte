//
//  ViewController.swift
//  Test
//
//  Created by Laima Cernius-Ink on 3/24/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//
import UIKit
import HGCircularSlider
import FirebaseDatabase
import Firebase
import RealmSwift
import FLAnimatedImage
import AudioToolbox


var exp = 0
var coins = 0
var counter = 0
var breakPlaying = false
var totalTime = 0
var isPro = true
var timeData = [String]()
var isPlaying = false
class TimerController: UIViewController {
    //MARK: - Properties
    var results: Results<User>!
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    var time = 600
    let timeL = UILabel()
    var motivationalQuote = ""
    var circularSlider = CircularSlider()
    let coinsL = AnimatedLabel()
    var imageView: UIImageView? = {
        let iv = UIImageView()
        iv.sizeToFit()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    var howMuchTime: Int = 0
    var mins = 0
    var secs = 0
    var breakL = UILabel()
    var breakTime = [String.SubSequence]()
    var coinsReceived: Int! = 0
    var expReceived: Int! = 0
    var coinsImg: UIImageView?
    var shadowView = UIView()
    var timerButton = UIView()
    var breakButton = UIView()
    var breakShadow = UIView()
    var breakButtonLbl = UILabel()
    let timerButtonLbl = UILabel()
    var timer = Timer()
    var enteredForeground = false
    var breakTimer = Timer()
    let db = Firestore.firestore()
    var durationString = ""
    var currentValueLabel: UILabel!
    var ref: DatabaseReference!
    var delegate: ContainerControllerDelegate!
    var tagImageView = UIImageView()
    var xImageView = UIImageView()
    var quoteLabel = UILabel()
    var diffMins = 0
    var diffSecs = 0
    
    
    //MARK: -Init
    override func viewDidLoad() {
        super.viewDidLoad()
        createObservers()
        configureUI()
        configureNavigationBar(color: backgroundColor, isTrans: true)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        results = uiRealm.objects(User.self)
        for result  in results {
            if result.isLoggedIn == true {
                coins = result.coins
                exp = result.exp
                coinsL.text = String(coins)
            }
        }
        coinsL.countFromZero(to: Float(coins), duration: .brisk)
    }
    
    deinit {
        self.timer.invalidate()
        self.breakTimer.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - helper functions
    func configureUI() {
        UIApplication.shared.isIdleTimerDisabled = true
        coinsImg = UIImageView(image: UIImage(named: "coins")!)
        coinsImg!.frame.size.width = 25
        coinsImg!.frame.size.height = 30
        coinsImg?.center.x =  view.center.x + 120
        coinsImg?.center.y = 30
        
        coinsL.frame.size.width = 75
        coinsL.frame.size.height = 75
        coinsL.textColor = .white
        coinsL.center.x =  view.center.x + 180
        coinsL.center.y = 30
        coinsL.font = UIFont(name: "Menlo-Bold", size: 20)
        
        quoteLabel.numberOfLines = 0
        quoteLabel.text = "Whatever you do, do it well. \n– Walt Disney"
        quoteLabel.textAlignment = .center
        quoteLabel.textColor = .white
        quoteLabel.font = UIFont(name: "Menlo-Bold", size: 15)
        quoteLabel.sizeToFit()
        quoteLabel.center.x = view.center.x
        quoteLabel.center.y = view.center.y - 250
        view.addSubview(quoteLabel)
        
        timeL.font = .boldSystemFont(ofSize: 20)
        timeL.font = UIFont(name: "Menlo-Bold", size: 65)
        timeL.textAlignment = .center
        timeL.textColor = .white
        timeL.frame.size.width = 240
        timeL.frame.size.height = 75
        timeL.center.x = view.center.x
        timeL.center.y = view.center.y + 160
        timeL.lineBreakMode = .byClipping
        view.addSubview(timeL)
        
        timerButton.frame.size.width = 170
        timerButton.frame.size.height = 75
        timerButton.center.x = view.center.x
        timerButton.backgroundColor = darkPurple
        timerButton.center.y = timeL.center.y + 100
        timerButton.layer.cornerRadius = 25
        timerButtonLbl.font = UIFont(name: "Menlo-Bold", size: 20)
        
        if !isPlaying {
            timerButtonLbl.text = "Start"
        }
        view.addSubview(timerButton)
        
        shadowView = UIView(frame: CGRect(x: view.center.x - 85 , y: timerButton.center.y-30 , width: 170, height: 75))
        shadowView.backgroundColor = .clear
        shadowView.layer.cornerRadius = 25
        shadowView.dropShadow(superview: timerButton)
        view.addSubview(shadowView)
        view.insertSubview(timerButton, aboveSubview: shadowView)
        timerButtonLbl.sizeToFit()
        timerButtonLbl.textColor = .white
        timerButtonLbl.center.x = timerButton.center.x
        timerButtonLbl.center.y = timerButton.center.y
        view.addSubview(timerButtonLbl)
        
        breakShadow = UIView(frame: CGRect(x: view.center.x + 35 , y: timerButton.center.y-30 , width: 130, height: 75))
        breakShadow.backgroundColor = .clear
        breakShadow.layer.cornerRadius = 25
        breakShadow.dropShadow(superview: breakButton)
        
        let breakTapped = UITapGestureRecognizer(target: self, action: #selector(self.breakPressed))
        self.breakButton.addGestureRecognizer(breakTapped)
        
        imageView?.image =  UIImage(named: "chest")!
        imageView?.sizeToFit()
        imageView?.center.x = view.center.x
        imageView?.center.y = view.center.y - 50
        view.insertSubview(imageView!, at: 10)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        timerButton.addGestureRecognizer(tap)
        
        tagImageView.frame.size.width = 70
        tagImageView.frame.size.height = 70
        tagImageView.center.x = view.center.x - 140
        tagImageView.center.y = view.center.y + 260
        tagImageView.isUserInteractionEnabled = true
        tagImageView.layer.cornerRadius = 10
        tagImageView.image = #imageLiteral(resourceName: "tagIcon")
        tagImageView.backgroundColor = superLightLavender
        tagImageView.layer.cornerRadius = 25
        tagImageView.contentMode = .scaleAspectFit
        tagImageView.layer.shadowColor = UIColor.black.cgColor
        tagImageView.layer.shadowOffset = CGSize(width: 5, height: 5)
        tagImageView.layer.shadowRadius = 25
        tagImageView.layer.shadowOpacity = 0.5
        view.addSubview(tagImageView)
        
        xImageView.frame.size.width = 70
        xImageView.frame.size.height = 70
        xImageView.center.x = view.center.x + 140
        xImageView.center.y = view.center.y + 260
        xImageView.isUserInteractionEnabled = true
        xImageView.layer.cornerRadius = 10
        let largeConfiguration = UIImage.SymbolConfiguration(weight: .bold)
        let img = UIImage(systemName: "xmark", withConfiguration: largeConfiguration)?.withTintColor(.white, renderingMode:.alwaysOriginal)
        xImageView.image = img
        let tappedX = UITapGestureRecognizer(target: self, action: #selector(xTapped))
        xImageView.addGestureRecognizer(tappedX)
        xImageView.contentMode = .center
        xImageView.backgroundColor = darkRed
        xImageView.layer.cornerRadius = 25
        xImageView.layer.shadowColor = UIColor.black.cgColor
        xImageView.layer.shadowOffset = CGSize(width: 5, height: 5)
        xImageView.layer.shadowRadius = 25
        xImageView.layer.shadowOpacity = 0.5
        view.addSubview(xImageView)
        
        view.backgroundColor = backgroundColor
        navigationItem.title = "Home"
        navigationItem.leftBarButtonItem =  UIBarButtonItem(image: resizedMenuImage?.withTintColor(.white), style: .plain, target: self, action: #selector(handleMenuToggle))
        navigationController?.navigationBar.addSubview(coinsL)
        navigationController?.navigationBar.addSubview(coinsImg!)
        
        createCircularSlider()
        
    }
    
    func displayalert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction((UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
            alert.dismiss(animated: true, completion: nil)
            
        })))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Handlers
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if !self.view.subviews.contains(quoteLabel) && self.view.subviews.contains(breakL) {
            print("add quote label")
            view.addSubview(quoteLabel)
        }
        if let colon = self.timeL.text?.firstIndex(of: ":") {
            durationString = String((self.timeL.text?[..<colon])!)
        }
        if timerButtonLbl.text == "Timer" {
            createStartUI()
            return
        }
        if isPlaying {
            giveUpAlert()
        } else if durationString != "0"{
            isPlaying = true
            timerButtonLbl.text = "Give Up"
            timerButtonLbl.sizeToFit()
            timerButtonLbl.center.x = view.center.x
            timerButton.backgroundColor = darkRed
            imageView?.loadGif(name: "mapGif")
            view.addSubview(timerButtonLbl)
            // create my track layer
            createShapeLayer()
            createBasicAnimation()
            countDownTimer()
            breakTimer.invalidate()
            breakL.removeFromSuperview()
            circularSlider.removeFromSuperview()
            xImageView.removeFromSuperview()
            tagImageView.removeFromSuperview()
        }
    }
    func createStartUI() {
        view.addSubview(xImageView)
        view.addSubview(tagImageView)
        timerButtonLbl.text = "Start"
        timerButton.backgroundColor = darkPurple
        timerButtonLbl.sizeToFit()
        imageView?.image = UIImage(named: "chest")
        timerButtonLbl.center.x = view.center.x
        view.addSubview(timerButtonLbl)
        timeL.font = UIFont(name: "Menlo-Bold", size: 65)
        breakButton.removeFromSuperview()
        breakButtonLbl.removeFromSuperview()
        breakShadow.removeFromSuperview()
        timerButton.center.x = view.center.x
        shadowView.center.x = view.center.x
        timerButtonLbl.center.x = view.center.x
        createCircularSlider()
    }
    
    
    func createShapeLayer() {
        var center = view.center
        center.y = view.center.y - 50
        let circularPath = UIBezierPath(arcCenter: center, radius: 130, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = darkPurple.cgColor
        trackLayer.lineWidth = 15
        
        trackLayer.fillColor = superLightLavender.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.insertSublayer(trackLayer, at: 0)
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = brightPurple.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
    }
    
    @objc func breakPressed() {
        print("pressed")
        let alert = LWAlert.init(customData: [["1", "2", "3", "4", "5","6","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28",
                                               "29","30"], ["minutes", "seconds"]])
        alert.customPickerBlock = { str in
            self.breakTime = str.split(separator: "-")
            self.startBreakTimer()
        }
        alert.show()
    }
    
    
    @objc func xTapped() {
        circularSlider.removeFromSuperview()
        createShapeLayer()
        twoButtonSetup()
    }
    
    func giveUpAlert() {
        let alert = UIAlertController(title: "Are you sure you want to give up?", message:"The search for treasure will stop", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            DispatchQueue.main.async {
                self.timer.invalidate()
            }
            self.timeL.text = "Let's Go \nAgain!"
            isPlaying = false
            self.twoButtonSetup() //Add break button and timer button
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            return
        }))
        self.present(alert, animated: true)
    }
    func createBasicAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.fillMode = CAMediaTimingFillMode.backwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "basic")
        let defaults = UserDefaults.standard
        defaults.set("playing", forKey: "status")
        
        if let colon = self.timeL.text?.firstIndex(of: ":") {
            durationString = String((self.timeL.text?[..<colon])!)
        }
        counter = 15
        howMuchTime = ((Int(durationString) ?? 10) * 60)
        basicAnimation.duration = CFTimeInterval(counter + (counter/4))
        self.shapeLayer.add(basicAnimation, forKey: "basic")
    }
    
    func pauseLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }

    func resumeLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    func twoButtonSetup() {
        self.timerButtonLbl.removeFromSuperview()
        self.shapeLayer.removeFromSuperlayer()
        self.tagImageView.removeFromSuperview()
        self.breakButton.frame.size.width = 130
        self.breakButton.frame.size.height = 75
        self.breakButton.center.x = self.view.center.x + 110
        self.breakButton.backgroundColor = darkRed
        self.breakButton.center.y = self.timeL.center.y + 100
        self.breakButton.layer.cornerRadius = 25
        self.breakButtonLbl.font = UIFont(name: "Menlo-Bold", size: 20)
        self.breakButtonLbl.textColor = .white
        
        self.breakButton.isUserInteractionEnabled = true
        self.view.addSubview(self.breakButton)
        self.view.addSubview(self.breakShadow)
        self.view.insertSubview(self.breakButton, aboveSubview: self.breakShadow)
        
        self.breakButtonLbl.text = "Break"
        self.breakButtonLbl.sizeToFit()
        self.breakButtonLbl.center.x = self.breakButton.center.x
        self.breakButtonLbl.center.y = self.breakButton.center.y
        self.view.addSubview(self.breakButtonLbl)
        
        
        self.timerButton.center.x = self.view.center.x - 70
        self.timerButton.backgroundColor = darkPurple
        
        self.timeL.numberOfLines = 2
        self.timeL.text = "Let's Go \nAgain!"
        self.timeL.font = UIFont(name: "Menlo-Bold", size: 30)
        self.timerButtonLbl.text = "Timer"
        self.timerButtonLbl.sizeToFit()
        self.timerButtonLbl.center.x = self.timerButton.center.x
        
        self.shadowView.center.x = self.view.center.x - 70
        self.imageView?.image = UIImage(named: "chest")
        self.view.addSubview(self.timerButtonLbl)
    }
    
    //MARK: - timer functions
    func countDownTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(incrementCount), userInfo: nil, repeats: true)
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
                            
                            let dashIndex = lastDate.firstIndex(of: "-")
                            let dashIndexOffset = lastDate.index(dashIndex!, offsetBy: 1)
                            
                            fbDate = String(lastDate[..<equalIndex!])
                           
                            //date already exists
                            if dateFormatterGet.string(from: Date()) == fbDate {
                                totalTimeForDay = String(lastDate[equalIndexOffset..<dashIndex!])
                                let totalTimeInt = Int(totalTimeForDay)! + (self.howMuchTime/60)
                                totalSessionsForDay = String(Int(lastDate[dashIndexOffset...])! + 1)
                                totalTimeForDay = String(totalTimeInt)
                                timeData[timeData.count - 1] = fbDate + "=" + totalTimeForDay + "-" + totalSessionsForDay
                            } else {
                                //first session for that day
                                fbDate = dateFormatterGet.string(from: Date())
                                totalTimeForDay = String(self.howMuchTime/60)
                                timeData.append(fbDate + "=" + totalTimeForDay + "-1")
                            }
                          
                        } else {
                            //very first session of account
                            fbDate = dateFormatterGet.string(from: Date())
                            totalTimeForDay = String(self.howMuchTime/60)
                            timeData.append(fbDate + "=" + totalTimeForDay + "-1")
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
                    } else {
                        print("Document does not exist")
                    }
                }
            }
        return
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
    
    func saveToRealm() {
        results = uiRealm.objects(User.self)
        for result  in results {
            if result.isLoggedIn == true {
                do {
                    try uiRealm.write {
                        result.setValue(Int(coinsL.text!)!, forKey: "coins")
                        result.setValue(exp, forKey: "exp")
                        result.setValue(timeData, forKey: "timeArray")
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func updateCoinLabel(numCoins: Int) -> Int? {
        let prevNumOfCoins = numCoins
        var numOfCoins = numCoins
        let prevExp = exp
        switch howMuchTime {
        case 599...1499:
            numOfCoins += 5
            exp += 1
        case 1500...2999:
            numOfCoins += 10
            exp += 3
        case 3000...4499:
            numOfCoins += 20
            exp += 6
        case 4500...5999:
            numOfCoins += 30
            exp += 9
        case 6000...7201:
            numOfCoins += 40
            exp += 12
        default:
            numOfCoins += 7
            exp += 1
        }
        //experience algo
        let  level = ((pow(Double(exp), 1.0/3.0)))
        if (level - floor(level) == 0) { // 0.000001 can be changed depending on the level of precision you need
            displayalert(title: "You Leveled Up!", message: "Congratulations you have leveled up!\n You are now level \(Int(level))")
        }
        expReceived = exp - prevExp
        coinsReceived = numOfCoins - prevNumOfCoins
        return numOfCoins
    }
    
}

