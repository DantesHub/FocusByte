//
//  DailyBonusView.swift
//  Test
//
//  Created by Dante Kim on 4/3/21.
//  Copyright © 2021 Steve Ink. All rights reserved.
//

import UIKit
import TinyConstraints
import Firebase
import AppsFlyerLib
import GoogleMobileAds
var loot = 0
var tappedVideoBool = false
class DailyBonusView: UIView{
    //MARK: - instance variables
    var mainView = UIView()
    var navigationBar = UINavigationBar()
    var isPad = false
    var rootController: TimerController?
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    let coinView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "coins")?.resized(to: CGSize(width: 17, height: 22))
        return iv
    }()
    let coinView30: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "coins")?.resized(to: CGSize(width: 17, height: 22))
        return iv
    }()
    let dailyCoin: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "coins")?.resized(to: CGSize(width: 17, height: 22))
        return iv
    }()
    
    let videoCoin: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "coins")?.resized(to: CGSize(width: 17, height: 22))
        return iv
    }()
    
    let dailyExp: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "exp")?.resized(to: CGSize(width: 25, height: 25))
        return iv
    }()
    
    let dailyCooldown: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Menlo-Bold", size: 20)
        label.textColor = .white
        return label
    }()
    
    let videoCooldown: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Menlo-Bold", size: 20)
        label.textColor = .white
        return label
    }()
    
    let videoExp: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "exp")?.resized(to: CGSize(width: 25, height: 25))
        return iv
    }()
    
    let playVideo: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "video-button")?.resized(to: CGSize(width: 45, height: 35))
        return iv
    }()
    
    let expView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "exp")?.resized(to: CGSize(width: 25, height: 25))
        return iv
    }()
    
    let expView30: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "exp")?.resized(to: CGSize(width: 25, height: 25))
        return iv
    }()
    let dailyBoxLabel = UILabel()
    let dailyButton = UIButton()
    let videoCoinLabel = UILabel()
    let videoExpLabel = UILabel()
    let dailyExpLabel = UILabel()
    let dailyDouble = UILabel()
    var dailyBox = UIView()
    var videoBox = UIView()
    //App advice variables
    var adviceBox = UIView()
    let adviceCoin: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "coins")?.resized(to: CGSize(width: 19, height: 24))
        return iv
    }()
    let adviceLogo: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "appadvice")?.resized(to: CGSize(width: 28, height: 28))
        return iv
    }()
    let adviceCoinLabel = UILabel()
    let adviceLabel = UILabel()
    
    var streakBox = UIView()
    let db = Firestore.firestore()
    var streakNumber = 1
    var dailyBonus = ""
    var dailyVideo = ""
    var sevenDayProgress = 0.0
    var thirtyDayProgress = 0.0
    var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        return formatter
    }()
    var cooldown = false
    var vidCooldown = false
    
    let sevenDayContainer = UIView()
    let thirtyDayContainer = UIView()
    var sevenLabel = UILabel()
    var thirtyLabel = UILabel()
    var flameView = UIImageView()
    let sevenDay = UIProgressView()
    let thirtyDay = UIProgressView()
    let thirtyClaim = UILabel()
    let sevenClaim = UILabel()
    var rewardedAd: GADRewardedAd?
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    var watchedVideo = false
    var claimedAdvice = false
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        overrideUserInterfaceStyle = .light
        if UIDevice().userInterfaceIdiom == .pad {
            isPad = true
        }
        claimedAdvice = UserDefaults.standard.bool(forKey: "appadvice")
        let results = uiRealm.objects(User.self)
        for result  in results {
            if result.isLoggedIn == true {
                if let plus = result.streak?.index(of: "+") {
                    streakNumber = Int(result.streak![..<plus])!
                } else {
                    streakNumber = 1
                }

                dailyBonus = result.dailyBonus ?? ""
                dailyVideo = result.dailyVideo ?? ""
                
                if result.sevenDay > 0 {
                    let leftOver = streakNumber - (result.sevenDay * 7)
                    sevenDayProgress = Double(leftOver)/7.0
                } else {
                    sevenDayProgress = Double(streakNumber)/7.0
                }
                                  


                if result.thirtyDay > 0 {
                    let leftOver = streakNumber - (result.thirtyDay * 30)
                    thirtyDayProgress = Double(leftOver)/30.0
                } else {
                    thirtyDayProgress = Double(streakNumber)/30.0
                }

            }
        }
    }

    //MARK: - helper functions
    @objc func tappedOutside() {
        rootController!.getRealmData()
        rootController!.createBarItem()
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { [self] in
            mainView.transform = CGAffineTransform(translationX: 0, y: (isPad ? 2000 : 1200))
         
        }) { [self] (_) in
            navigationBar.alpha = 1
            navigationBar.isUserInteractionEnabled = true
            removeFromSuperview()}
    }
    
    func createSmallBox() -> UIView {
        let view = UIView()
        view.layer.borderWidth = 5
        view.layer.borderColor = superLightLavender.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        view.backgroundColor = darkPurple
        return view
    }
    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.text = text
        label.font = UIFont(name: "Menlo-Bold", size: 26)
        return label
    }
    @objc func tappedDaily() {
        if !cooldown {
            if dailyBox.subviews.contains(dailyExp) {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                AppsFlyerLib.shared().logEvent("daily_bonus", withValues: [AFEventParamContent: "true"])
                dailyExp.removeFromSuperview()
                dailyExpLabel.removeFromSuperview()
                dailyCoin.removeFromSuperview()
                dailyBoxLabel.removeFromSuperview()
                dailyButton.removeFromSuperview()
                
                saveData()
            }
        }
        
    }
    
    @objc func tappedVideo() {
        if !vidCooldown {
            if videoBox.subviews.contains(videoExp) {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                if rewardedAd?.isReady == true {
                    tappedVideoBool = true
                    rootController!.circularSlider.removeFromSuperview()
                    rewardedAd?.present(fromRootViewController: rootController!, delegate:self)
                    tappedOutside()
                    totalBonuses -= 1
                    rootController!.createBarItem()
                    print(totalBonuses, "totalBonuses")
                 }
                videoExp.removeFromSuperview()
                videoExpLabel.removeFromSuperview()
                videoCoin.removeFromSuperview()
                videoCoinLabel.removeFromSuperview()
                dailyDouble.removeFromSuperview()
                playVideo.removeFromSuperview()
            }
        }
     
    }
    final func createVideoCooldown() {
        videoBox.addSubview(videoCooldown)
        videoCooldown.center(in: videoBox)
    }
    private final func createDailyCooldown() {
        dailyBox.addSubview(dailyCooldown)
        dailyCooldown.center(in: dailyBox)
    }
    private final func createVideoTimer() {
        vidCooldown = true
        var interval = TimeInterval()
        if dailyVideo == "" {
            interval = 43200
        } else {
            interval =  formatter.date(from: dailyVideo)! - Date()
        }
        
        createVideoCooldown()
        videoCooldown.text = interval.stringFromTimeInterval()
        DispatchQueue.main.async {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
                interval -= 1
                videoCooldown.text = interval.stringFromTimeInterval()
                if interval <= 0 {
                    timer.invalidate()
                    vidCooldown = false
                    videoCooldown.removeFromSuperview()
                    createVideoBox()
                }
            }
        }
    }
    private final func createDailyTimer() {
        cooldown = true
        var interval = TimeInterval()
        if dailyBonus == "" {
            interval = 86400
        } else {
            interval =  formatter.date(from: dailyBonus)! - Date()
        }
        createDailyCooldown()
        dailyCooldown.text = interval.stringFromTimeInterval()
        DispatchQueue.main.async {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
                interval -= 1
                dailyCooldown.text = interval.stringFromTimeInterval()
                if interval <= 0 {
                    timer.invalidate()
                    cooldown = false
                    dailyCooldown.removeFromSuperview()
                    createDailyBox()
                }
            }
        }
    }
    
    
    private final func saveToRealm(video: Bool = false, streak: Bool = false, advice: Bool = false) {
        let results = uiRealm.objects(User.self)
        for result  in results {
            if result.isLoggedIn == true {
                print(result.email, "chuga")
                do {
                    try uiRealm.write {
                        print("saving to realm")
                        result.setValue(coins, forKey: "coins")
                        result.setValue(exp, forKey: "exp")
                        if !streak && !advice {
                            if video {
                                result.dailyVideo = formatter.string(from: Calendar.current.date(byAdding: .hour, value: 12, to: Date())!)
                                dailyVideo = result.dailyVideo!
                                createVideoCooldown()
                                createVideoTimer()
                            } else {
                                result.dailyBonus = formatter.string(from: Calendar.current.date(byAdding: .hour, value: 24, to: Date())!)
                                dailyBonus = result.dailyBonus!
                                createDailyCooldown()
                                createDailyTimer()
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
        if advice {
            tappedOutside()
        }
    }
     final func saveData(video: Bool = false, streak: Bool = false, advice: Bool = false) {
        var numCoins = 0
        if !UserDefaults.standard.bool(forKey: "noLogin") && UserDefaults.standard.bool(forKey: "isPro") {
        if let _ = Auth.auth().currentUser?.email {
            let email = Auth.auth().currentUser?.email
            let docRef = self.db.collection(K.FStore.collectionName).document(email!)
            //Read Data from firebase, for syncing
            docRef.getDocument { [self] (snapshot, error) in
                if let document = snapshot, document.exists {
                    if let c = document["coins"] {
                        numCoins = c  as! Int
                    }
                    if let xp = document["exp"] {
                        exp = xp as! Int
                    }
                 
                    if let itemArray = document["inventoryArray"] {
                        inventoryArray = itemArray as! [String]
                    }
                    
                    if !streak {
                        if advice {
                            howMuchTime = 8000
                        } else {
                            howMuchTime = 1300
                        }
                    }
                    loot = numCoins
                    rootController!.updateCoins()
                    //Check if last entry is equal to today
                    //if last entry is, then we just need to add time to it
                    saveToRealm(video: video, streak: streak,  advice: advice)
                    //update data in firebase
                    if let _ = Auth.auth().currentUser?.email {
                        let email = Auth.auth().currentUser?.email
                        self.db.collection(K    .userPreferenes).document(email!).setData([
                            "coins": coins,
                            "exp": exp,
                        ], merge: true) { [self] (error) in
                            if let e = error {
                                print("There was a issue saving data to firestore \(e) ")
                            } else {
                                print("Succesfully saved")
                            }
                        }
                    }
                } else {
                    print("Document does not exist")
        
                }
            }
        }
        } else {
            if !streak {
                if advice {
                    howMuchTime = 8000
                } else {
                    howMuchTime = 1300
                }
            }
            
            loot = coins
            rootController!.updateCoins()
            saveToRealm(video: video, streak: streak, advice: advice)
        }
    }
    final func createVideoBox() {
        videoBox.addSubview(videoCoin)
        videoCoin.leading(to: videoBox, offset: 15)
        videoCoin.centerY(to: videoBox)
        
        videoBox.addSubview(videoCoinLabel)
        videoCoinLabel.centerY(to: videoBox)
        videoCoinLabel.leadingToTrailing(of: videoCoin, offset: 5)
        videoCoinLabel.textColor = .white
        videoCoinLabel.text = "5"
        videoCoinLabel.font = UIFont(name: "Menlo-Bold", size: 18)

        videoBox.addSubview(videoExp)
        videoExp.centerY(to: videoBox)
        videoExp.leadingToTrailing(of: videoCoinLabel, offset: 5)
        
        videoExp.addSubview(videoExpLabel)
        videoExpLabel.centerY(to: videoExp)
        videoExpLabel.leadingToTrailing(of: videoExp, offset: 5)
        videoExpLabel.textColor = .white
        videoExpLabel.text = "3"
        videoExpLabel.font = UIFont(name: "Menlo-Bold", size: 18)
        
        videoBox.addSubview(playVideo)
        playVideo.centerY(to: videoBox)
        playVideo.leadingToTrailing(of: videoExpLabel, offset: 15)
        
        if !isIpod {
            videoBox.addSubview(dailyDouble)
            dailyDouble.centerY(to: videoBox)
            dailyDouble.trailing(to: videoBox, offset: -15)
            dailyDouble.textColor = .white
            dailyDouble.text = "DAILY\nDOUBLE"
            dailyDouble.numberOfLines = 2
            dailyDouble.font = UIFont(name: "Menlo-Bold", size: 14)
        }
    }
    
    private final func createDailyBox() {
        dailyBox.addSubview(dailyCoin)
        dailyCoin.leading(to: dailyBox, offset: 15)
        dailyCoin.centerY(to: dailyBox)
        
        dailyBox.addSubview(dailyBoxLabel)
        dailyBoxLabel.centerY(to: dailyBox)
        dailyBoxLabel.leadingToTrailing(of: dailyCoin, offset: 5)
        dailyBoxLabel.textColor = .white
        dailyBoxLabel.text = "5"
        dailyBoxLabel.font = UIFont(name: "Menlo-Bold", size: 18)

        dailyBox.addSubview(dailyExp)
        dailyExp.centerY(to: dailyBox)
        dailyExp.leadingToTrailing(of: dailyBoxLabel, offset: 5)
        
        dailyBox.addSubview(dailyExpLabel)
        dailyExpLabel.centerY(to: dailyBox)
        dailyExpLabel.leadingToTrailing(of: dailyExp, offset: 5)
        dailyExpLabel.textColor = .white
        dailyExpLabel.text = "3"
        dailyExpLabel.font = UIFont(name: "Menlo-Bold", size: 18)
        
        
        dailyButton.layer.cornerRadius = 15
        dailyButton.backgroundColor = superLightLavender
        
        dailyButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        dailyBox.addSubview(dailyButton)
        dailyButton.centerY(to: dailyBox)
        dailyButton.trailing(to: dailyBox, offset: -20)
        dailyButton.leadingToTrailing(of: dailyExpLabel, offset: 20)
        dailyButton.width(self.frame.width * 0.65 * 0.35)
        dailyButton.setTitle("CLAIM", for: .normal)
        dailyButton.setTitleColor(brightPurple, for: .normal)
        dailyButton.titleLabel?.font = UIFont(name: "Menlo-Bold", size: 16)
        dailyButton.titleLabel?.adjustsFontSizeToFitWidth = true
        dailyButton.layer.shadowColor = UIColor.black.cgColor
        dailyButton.layer.shadowOpacity = 0.6
        dailyButton.layer.shadowOffset = .zero
        dailyButton.layer.shadowRadius = 5
        dailyButton.addTarget(self, action: #selector(tappedDaily), for: .touchUpInside)
//        dailyButton.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    
    
    func setUpView() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedOutside)))
        self.addSubview(mainView)
        
        mainView.width(self.frame.width * (isIpod ? 0.90 : 0.80))
        mainView.height(self.frame.height * (UIDevice.current.hasNotch ? 0.65 : (isIpod ? 0.75 : 0.70) ) * (claimedAdvice ? 1 : 1.1))
        mainView.centerX(to: self)
        mainView.topToSuperview(offset: -self.frame.height * (UIDevice.current.hasNotch ? 0.25 : isIpod ? 0.40 :0.30))
        
        let mainTap = UITapGestureRecognizer(target: self, action: nil)
        mainView.addGestureRecognizer(mainTap)

        mainView.backgroundColor = darkPurple
        mainView.layer.borderWidth = 3
        mainView.layer.borderColor = superLightLavender.cgColor
        mainView.layer.cornerRadius = 25
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 0.5
        mainView.layer.shadowOffset = .zero
        mainView.layer.shadowRadius = 5
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { [self] in
            self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.mainView.transform = CGAffineTransform(translationX: 0, y: (isPad ? 450 : UIDevice.current.hasNotch ? 350 : 300))
                }) { (_) in
        }
        
        let dailyLabel = createLabel(text: "DAILY BONUS")
        let streakLabel = createLabel(text: "STREAKS")
        
        mainView.addSubview(dailyLabel)
        mainView.addSubview(streakLabel)
        
        dailyLabel.centerX(to: self)
        dailyLabel.top(to: mainView, offset: 20)
        
        dailyBox = createSmallBox()
        videoBox = createSmallBox()
        streakBox = createSmallBox()
        
        mainView.addSubview(dailyBox)
        dailyBox.topToBottom(of: dailyLabel, offset: 20)
        dailyBox.centerX(to: mainView)
        dailyBox.width(self.frame.width * 0.65)
        dailyBox.height(self.frame.height * 0.065)
        dailyBox.layer.cornerRadius = 15
        dailyBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedDaily)))
      
        if dailyBonus == "" { //first time getting daily bonus
            createDailyBox()
        } else if (Date() - formatter.date(from: dailyBonus)! >= 0) {
            //past 24 hours
            createDailyBox()
        } else { //cooldown, show timer
            createDailyTimer()
        }
        
        mainView.addSubview(videoBox)
        videoBox.topToBottom(of: dailyBox, offset: 20)
        videoBox.centerX(to: mainView)
        videoBox.width(self.frame.width * 0.65)
        videoBox.height(self.frame.height * 0.065)
        videoBox.layer.cornerRadius = 15
        videoBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedVideo)))
        
        if dailyVideo == "" { //first time
            loadVideoAd()
        } else if (Date() - formatter.date(from: dailyVideo)! >= 0) {
            loadVideoAd()
        } else {
            createVideoTimer()
        }
        
        if !claimedAdvice { createAdviceBox() }
        
                
        mainView.addSubview(streakLabel)
        streakLabel.centerX(to: self)
        streakLabel.topToBottom(of: claimedAdvice ? videoBox : adviceBox, offset: 40)
        
        mainView.addSubview(streakBox)
        streakBox.topToBottom(of: streakLabel, offset: 10)
        streakBox.centerX(to: mainView)
        streakBox.width(self.frame.width * (isIpod ? 0.75 : 0.65))
        streakBox.height(self.frame.height * 0.65 * 0.40)
        streakBox.layer.cornerRadius = 15
        
         flameView = UIImageView(image: UIImage(named: "flame")?.resized(to: CGSize(width: self.frame.width * 0.17, height: self.frame.height * 0.08)))
        streakBox.addSubview(flameView)
        flameView.leading(to: streakBox, offset: 20)
        flameView.top(to: streakBox, offset: self.frame.height * 0.65 * 0.40 * 0.20)
        
        let flameLabel = createLabel(text: "\(streakNumber)\n" + (streakNumber == 1 ? "Day" : "Days"))
        streakBox.addSubview(flameLabel)
        flameLabel.topToBottom(of: flameView, offset: 5)
        flameLabel.numberOfLines = 2
        flameLabel.textAlignment = .center
        flameLabel.font = UIFont(name: "Menlo", size: 22)
        flameLabel.leading(to: streakBox, offset: isPad ? 75 : UIDevice.current.hasNotch ? 30 : 28)
        
        //MARK: - Streak Boxes
        sevenLabel = createLabel(text: "7 Days")
        sevenLabel.font = UIFont(name: "Menlo", size: 20)
        streakBox.addSubview(sevenLabel)
        sevenLabel.textAlignment = .center
        sevenLabel.top(to: streakBox, offset: self.frame.height * 0.65 * 0.40 * 0.125)
        sevenLabel.leadingToTrailing(of: flameView, offset: self.frame.width * 0.65 * 0.15)
        
        streakBox.addSubview(sevenDayContainer)
        sevenDayContainer.trailing(to: streakBox, offset: -25)
        sevenDayContainer.topToBottom(of: sevenLabel, offset: 5)
        sevenDayContainer.leadingToTrailing(of: flameView, offset: 10)
        sevenDayContainer.height(self.frame.height * 0.045)
        
        sevenDay.progressTintColor = barColor
        sevenDay.progressViewStyle = .bar
        sevenDay.backgroundColor = superLightLavender
        
        sevenDayContainer.addSubview(sevenDay)
        sevenDay.trailing(to: streakBox, offset: -15)
        sevenDay.topToBottom(of: sevenLabel, offset: 5)
        sevenDay.leadingToTrailing(of: flameView, offset: 10)
        sevenDay.height(self.frame.height * 0.045)
        sevenDay.layer.cornerRadius = 15
        sevenDayContainer.layer.shadowColor = UIColor.black.cgColor
        sevenDayContainer.layer.shadowOpacity = 0.6
        sevenDayContainer.layer.shadowOffset = .zero
        sevenDayContainer.layer.shadowRadius = 5
        sevenDayContainer.layer.shadowOffset = CGSize(width: 0, height: 5)
        sevenDay.clipsToBounds = true

        if sevenDayProgress >= 1.0 { //claim reward
            sevenDay.progress = 1
            sevenDay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedSeven)))
            sevenClaim.font = UIFont(name: "Menlo-Bold", size: 20)
            sevenClaim.text = "CLAIM!"
            sevenClaim.textColor = .white
            sevenDayContainer.addSubview(sevenClaim)
            sevenClaim.center(in: sevenDayContainer)
        } else {
            createSevenProgress()
        }
        
        thirtyLabel = createLabel(text: "30 Days")
        thirtyLabel.font = UIFont(name: "Menlo", size: 20)
        streakBox.addSubview(thirtyLabel)
        thirtyLabel.textAlignment = .center
        thirtyLabel.topToBottom(of: sevenDay, offset: 15)
        thirtyLabel.leadingToTrailing(of: flameView, offset: self.frame.width * 0.65 * 0.15)
        
        streakBox.addSubview(thirtyDayContainer)
        thirtyDayContainer.trailing(to: streakBox, offset: -15)
        thirtyDayContainer.topToBottom(of: thirtyLabel, offset: 5)
        thirtyDayContainer.leadingToTrailing(of: flameView, offset: 10)
        thirtyDayContainer.height(self.frame.height * 0.045)
        thirtyDay.progress = 0
        thirtyDay.progressTintColor = barColor
        thirtyDay.progressViewStyle = .bar
        thirtyDay.backgroundColor = superLightLavender
        
        thirtyDayContainer.addSubview(thirtyDay)
        thirtyDay.trailing(to: streakBox, offset: -15)
        thirtyDay.topToBottom(of: thirtyLabel, offset: 5)
        thirtyDay.leadingToTrailing(of: flameView, offset: 10)
        thirtyDay.height(self.frame.height * 0.045)
        thirtyDay.layer.cornerRadius = 15
        thirtyDayContainer.layer.shadowColor = UIColor.black.cgColor
        thirtyDayContainer.layer.shadowOpacity = 0.6
        thirtyDayContainer.layer.shadowOffset = .zero
        thirtyDayContainer.layer.shadowRadius = 5
        thirtyDayContainer.layer.shadowOffset = CGSize(width: 0, height: 5)
        thirtyDay.clipsToBounds = true
        
        if thirtyDayProgress >= 1.0 { //claim reward
            thirtyDay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedThirty)))
            thirtyDay.progress = 1
            thirtyClaim.font = UIFont(name: "Menlo-Bold", size: 20)
            thirtyClaim.text = "CLAIM!"
            thirtyClaim.textColor = .white
            thirtyDay.addSubview(thirtyClaim)
            thirtyClaim.center(in: thirtyDay)
        } else {
            createThirtyProgress()
        }
        
    }
    private final func createThirtyProgress() {
        thirtyDay.progress = Float(thirtyDayProgress)
        thirtyDay.addSubview(coinView30)
        coinView30.centerY(to: thirtyDay)
        coinView30.leading(to: thirtyDay, offset: 10)
        
        let thirtyDayCoin = UILabel()
        thirtyDayCoin.font = UIFont(name: "Menlo-Bold", size: 16)
        thirtyDay.addSubview(thirtyDayCoin)
        thirtyDayCoin.text = "250"
        thirtyDayCoin.leadingToTrailing(of: coinView30, offset: 5)
        thirtyDayCoin.centerY(to: thirtyDay)
        thirtyDayCoin.adjustsFontSizeToFitWidth = true

        thirtyDay.addSubview(expView30)
        expView30.centerY(to: thirtyDay)
        expView30.leadingToTrailing(of: thirtyDayCoin, offset: 5)
        
        let thirtyDayExp = UILabel()
        thirtyDayExp.font = UIFont(name: "Menlo-Bold", size: 16)
        thirtyDay.addSubview(thirtyDayExp)
        thirtyDayExp.text = "100"
        thirtyDayExp.leadingToTrailing(of: expView30, offset: 0)
//        thirtyDayExp.trailing(to: thirtyDay, offset: 0)
        thirtyDayExp.centerY(to: thirtyDay)
        thirtyDayExp.adjustsFontSizeToFitWidth = true
    }
    
    private final func createSevenProgress() {
        sevenDay.progress = Float(sevenDayProgress)
        sevenDay.addSubview(coinView)
        coinView.centerY(to: sevenDay)
        coinView.leading(to: sevenDay, offset: 10)
        
        let sevenDayCoin = UILabel()
        sevenDayCoin.font = UIFont(name: "Menlo-Bold", size: 18)
        sevenDay.addSubview(sevenDayCoin)
        sevenDayCoin.text = "40"
        sevenDayCoin.leadingToTrailing(of: coinView, offset: 5)
        sevenDayCoin.centerY(to: sevenDay)
        
        sevenDay.addSubview(expView)
        expView.centerY(to: sevenDay)
        expView.leadingToTrailing(of: sevenDayCoin, offset: 5)
        
        let sevenDayExp = UILabel()
        sevenDayExp.font = UIFont(name: "Menlo-Bold", size: 18)
        sevenDay.addSubview(sevenDayExp)
        sevenDayExp.text = "15"
        sevenDayExp.leadingToTrailing(of: expView, offset: 5)
        sevenDayExp.centerY(to: sevenDay)
    }
    
    @objc func tappedSeven() {
        if sevenDayProgress >= 1.0 {
            AppsFlyerLib.shared().logEvent("seven_bonus", withValues: [AFEventParamContent: "true"])
            howMuchTime = 6000
            saveData(streak: true)
            let results = uiRealm.objects(User.self)
            for result  in results {
                if result.isLoggedIn == true {
                    do {
                        try uiRealm.write {
                            result.sevenDay += 1
                            let leftOver = streakNumber - (result.sevenDay * 7)
                            sevenDayProgress = Double(leftOver)/7.0
                            if sevenDayProgress < 1.0 {
                                sevenClaim.removeFromSuperview()
                                createSevenProgress()
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }

    }
    
    @objc func tappedThirty() {
        if thirtyDayProgress >= 1.0 {
            AppsFlyerLib.shared().logEvent("thirty_bonus", withValues: [AFEventParamContent: "true"])
            howMuchTime = 10000
            saveData(streak: true)
            let results = uiRealm.objects(User.self)
            for result in results {
                if result.isLoggedIn == true {
                    do {
                        try uiRealm.write {
                            result.thirtyDay += 1
                            let leftOver = streakNumber - (result.thirtyDay * 30)
                            thirtyDayProgress = Double(leftOver)/30.0
                            if thirtyDayProgress < 1.0 {
                                thirtyClaim.removeFromSuperview()
                                createThirtyProgress()
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    @objc func tappedAdvice() {
        UserDefaults.standard.setValue(true, forKey: "appadvice")
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        tappedVideoBool = true
        saveData(advice: true)
    }
    
    private final func createAdviceBox() {
        adviceBox = createSmallBox()
        mainView.addSubview(adviceBox)
        adviceBox.topToBottom(of: videoBox, offset: 20)
        adviceBox.centerX(to: mainView)
        adviceBox.width(self.frame.width * 0.65)
        adviceBox.height(self.frame.height * 0.065)
        adviceBox.layer.cornerRadius = 15
        adviceBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedAdvice)))
        
        adviceBox.addSubview(adviceCoin)
        adviceCoin.leading(to: adviceBox, offset: 20)
        adviceCoin.centerY(to: adviceBox)
        
        adviceBox.addSubview(adviceCoinLabel)
        adviceCoinLabel.centerY(to: adviceBox)
        adviceCoinLabel.leadingToTrailing(of: adviceCoin, offset: 5)
        adviceCoinLabel.textColor = .white
        adviceCoinLabel.text = "150"
        adviceCoinLabel.font = UIFont(name: "Menlo-Bold", size: 20)
        
        adviceBox.addSubview(adviceLogo)
        adviceLogo.centerY(to: adviceBox)
        adviceLogo.centerX(to: adviceBox)
        
        adviceBox.addSubview(adviceLabel)
        adviceLabel.centerY(to: adviceBox)
        adviceLabel.trailing(to: adviceBox, offset: -15)
        adviceLabel.textColor = .white
        adviceLabel.text = "App Advice\nBonus!"
        adviceLabel.textAlignment = .center
        adviceLabel.numberOfLines = 2
        adviceLabel.font = UIFont(name: "Menlo-Bold", size: 14)
    }

}
