//
//  ViewController.swift
//
//TODO add appsflyer event for lifetime
import UIKit
import HGCircularSlider
import FirebaseDatabase
import Firebase
import RealmSwift
import FLAnimatedImage
import AudioToolbox
import TinyConstraints
import Foundation
import TinyConstraints
import Purchases
import SCLAlertView
import WidgetKit
import AppsFlyerLib
import GoogleMobileAds

var enteredForeground = false
var deepFocusMode = true
var locked = false
var exp = 0
var coins = 0
var counter = 0
var breakPlaying = false
var totalTime = 0
var isPro = true
var timeData = [String]()
var isPlaying = false
var tagColor = "gray"
var level = 1
var chestBought = false
var expDate = ""
var randomNum = 0
var upgradedToPro = false
var tagSelected = ("unset")
var howMuchTime: Int = 0
var rewardedAd: GADRewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-5091808253991399/3095897395")
var focusCompleteNotif = false
var totalBonuses = 0
class TimerController: UIViewController, TagUpdater {
    //MARK: - Properties
    var lastDate = ""
    var totalTimeForDay = ""
    var fbDate = ""
    var totalSessionsForDay = ""
    var results: Results<User>!
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    let timeL = UILabel()
    var motivationalQuote = ""
    var tagAndColor = (name: "unset", color: "gray")
    var circularSlider = CircularSlider()
    let coinsL = AnimatedLabel()
    var chestImageView: UIImageView? = {
        let iv = UIImageView()
        iv.sizeToFit()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    let tagTitle = UILabel()
    lazy var dfmSwitch: UISwitch = {
        let dswitch = UISwitch()
        dswitch.onTintColor = brightPurple
        if deepFocusMode {
            dswitch.setOn(true, animated: false)
        }
        return dswitch
    }()
    lazy var expImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "exp")
        iv.sizeToFit()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var coinImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "coins")
        iv.sizeToFit()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    var mins = 0
    var secs = 0
    var breakL = UILabel()
    var breakTime = [String.SubSequence]()
    var coinsReceived: Int! = 0
    var expReceived: Int! = 0
    var coinsImg: UIImageView?
    var timerButton = UIView()
    var breakButton = UIView()
    var breakButtonLbl = UILabel()
    let timerButtonLbl = UILabel()
    var timer = Timer()
    var levelLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Menlo-Bold", size: 15)
        label.textColor = darkPurple
        return label
    }()
    var deepFocusLabel: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "focusIcon")
        iv.height(50)
        iv.width(50)
        return iv
    }()
    var deepFocusView = UIView()
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
    var tagTableView = TagTableView()
    var searchBar = UISearchBar()
    var chest = "chest"
    var onHome = false
    var  plusIcon: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "plusIcon")

        return iv
    }()
    var streakNumber = 1
    //widget variables
    var monthArray = [String]()
    var weekArray = [String]()
    let dateHelper = DateHelper()
    var begWeekNum = 0
    var endWeekNum = 0
    var todayNum = 0
    var todayDayOfWeek = ""
    var nextMonth = ""
    var isOpen = false
    let userDefaults = UserDefaults(suiteName: "group.co.byteteam.focusbyte")
    let defaults = UserDefaults.standard
    var fromWidget = false
    //MARK: -Init
    override func viewDidLoad() {
        super.viewDidLoad()
        //ask for review
        loadVideoAds()
        let date1 = Date()
        let today1 = Date()
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: today1)
        print((nextDate! - date1), "skinny")
        NotificationCenter.default.addObserver(self, selector: #selector(openedFromWidget), name: Notification.Name("openedFromWidget"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goToStats), name: Notification.Name("goToStats"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changePet), name: Notification.Name("changePet"), object: nil)
        checkIfPro()
        onHome = true
        if boughtChest == true {
            let alertView = SCLAlertView()
            alertView.showSuccess("Succesfully upgraded chest!", subTitle: "")
            boughtChest = false
        }
        if upgradedToPro {
            let alertView = SCLAlertView()
            alertView.iconTintColor = brightPurple
            alertView.showCustom("Succesfully Upgraded To Pro! Thank You!", subTitle: "", color: brightPurple, icon: .checkmark)
            upgradedToPro = false
        }
        
        if !tappedVideoBool {
            getRealmData()
        } else {
            tappedVideoBool = false
        }
        let today = Date()
      
        for item in inventoryArray {
            if item.contains("Gold Chest") {
                let plusIndex = item.firstIndex(of: "+")
                let date = String(item[..<plusIndex!]).toDate()
                if today < date! {
                    self.chest = "goldChest"
                    expDate = (date?.toString())!
                    chestBought = true
                }
            } else if item.contains("Epic Chest") {
                let plusIndex = item.firstIndex(of: "+")
                let date = String(item[..<plusIndex!]).toDate()
                if today < date! {
                    self.chest = "epicChest"
                    expDate = (date?.toString())!
                    chestBought = true
                }
            } else if item.contains("Diamond Chest") {
                let plusIndex = item.firstIndex(of: "+")
                let date = String(item[..<plusIndex!]).toDate()
                if today < date! {
                    self.chest = "diamondChest"
                    expDate = (date?.toString())!
                    chestBought = true
                }
            }
        }
    }
    
    @objc func openedFromWidget() {
        if timerButtonLbl.text == "Timer" {
            !isIpod ? createStartUI() : createIpodStartUI()
        }
        fromWidget = true
        handleTap()
    }
    @objc func goToStats() {
        if UserDefaults.standard.bool(forKey: "isPro") == true {
            let controller = ContainerController(center: StatisticsController())
            controller.modalPresentationStyle = .fullScreen
            presentInFullScreen(UINavigationController(rootViewController: controller), animated: true)
        }   else {
            let controller = SubscriptionController()
            controller.modalPresentationStyle = .fullScreen
            controller.idx = 1
            presentInFullScreen(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        }
    }
    @objc func changePet() {
        pets = true
        menuLabel = "Pets"
        let controller = ContainerController(center: InventoryController(whichTab: "pets"))
         controller.modalPresentationStyle = .fullScreen

         var topVC = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.rootViewController
         while((topVC!.presentedViewController) != nil){
              topVC = topVC!.presentedViewController
         }
         topVC!.present(controller,animated: true,completion: nil)
           NotificationCenter.default.post(name: Notification.Name(rawValue: petsKey), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {

        createObservers()
//        createGestureRecognizers()
        level = Int(floor(sqrt(Double(exp))))
        if isIpod {
            configureIpodUI()
        } else {
           configureUI()
        }
        configureNavigationBar(color: backgroundColor, isTrans: true)
        if !UserDefaults.standard.bool(forKey: "mindGarden") {
            let mindGardenView = MindGardenView(frame: UIScreen.main.bounds)
            view.addSubview(mindGardenView)
            mindGardenView.rootController = self
            mindGardenView.setUpView()
            mindGardenView.navigationBar = navigationController!.navigationBar
            navigationController?.navigationBar.alpha = 0.3
            navigationController?.navigationBar.isUserInteractionEnabled = false
        }
    }
//    private final func createGestureRecognizers() {
//        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
//           view.addGestureRecognizer(rightSwipe)
//
//           let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
//           leftSwipe.direction = .left
//
//           view.addGestureRecognizer(leftSwipe)
//    }
//    @objc func swipedRight() {
//        if !isPlaying {
//            if isOpen == false {
//                handleMenuToggle()
//            }
//        }
//  
//    }
//
//
//
//    @objc func swipedLeft() {
//        if !isPlaying {
//            if isOpen == true {
//                 handleMenuToggle()
//             }
//        }
//    }
    final func getRealmData() {
            totalBonuses = 0
        results = uiRealm.objects(User.self)
        for result  in results {
            if result.isLoggedIn == true {
                coins = result.coins
                exp = result.exp
                let formatter = DateFormatter()
                formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
                var lastStreakDate = ""
                if let plus = result.streak?.index(of: "+") {
                    streakNumber = Int(result.streak![..<plus])!
                    let plusOffset = result.streak!.index(plus, offsetBy: 1)
                    lastStreakDate = String(result.streak![plusOffset...])
                    if (Date() - formatter.date(from: lastStreakDate)! >= 86400 && Date() - formatter.date(from: lastStreakDate)! <= 172800) {
                        // update streak number and date
                        if let oneId = UserDefaults.standard.value(forKey: "oneDayNotif") as? String {
                            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [oneId])
                            NotificationHelper.addOneDay()
                        }
                        if let threeId = UserDefaults.standard.value(forKey: "threeDayNotif") as? String {
                            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [threeId])
                            NotificationHelper.addThreeDay()
                        }
                        if let proId = UserDefaults.standard.value(forKey: "proNotif") as? String {
                            if UserDefaults.standard.bool(forKey: "isPro") {
                                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [proId])
                            }
                        }
                        streakNumber += 1
                        lastStreakDate = formatter.string(from: Date())
                    } else if  Date() - formatter.date(from: lastStreakDate)! > 172800 { //broke streak
                        streakNumber = 1
                        lastStreakDate = formatter.string(from: Date())
                        try! uiRealm.write {
                            result.sevenDay = 0
                            result.thirtyDay = 0
                        }
                    } else {} // no need  to update streak
                    if result.dailyBonus != "" && result.dailyBonus != nil {
                        if (Date() - formatter.date(from: result.dailyBonus!)! >= 0) {
                            totalBonuses += 1
                        }
                    } else {
                        totalBonuses += 1
                    }

                    if result.dailyVideo != "" && result.dailyVideo != nil {
                        if (Date() - formatter.date(from: result.dailyVideo!)! >= 0) {
                            totalBonuses += 1
                        }
                    } else {
                        totalBonuses += 1
                    }
                  
                    var sevenDayProgress:Double = 0.0
                    var thirtyDayProgress:Double = 0.0
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
                    if sevenDayProgress >= 1.0 { totalBonuses += 1}
                    if thirtyDayProgress >= 1.0 { totalBonuses += 1}

                } else { //first streak ever
                    lastStreakDate = formatter.string(from: Date())
                    streakNumber = 1
                }
                try! uiRealm.write {
                    result.streak = String(streakNumber) + "+" + lastStreakDate
                }
                
                for tag in result.tagDictionary {
                    if tag.selected == true {
                        tagAndColor = (tag.name, tag.color)
                        tagSelected = tag.name
                    }
                }
                self.overrideUserInterfaceStyle = .light
                gender = result.gender!
                inventoryArray = result.inventoryArray.map{ $0 }
                coinsL.text = String(coins)
                deepFocusMode = result.deepFocusMode
                timeData = result.timeArray.map{$0}
                if #available(iOS 14.0, *) {
                    userDefaults?.setValue(coins, forKey: "coins")
                    userDefaults?.setValue(Int((pow(Double(exp), 1.0/2.0))), forKey: "level")
                    userDefaults?.setValue(result.pet ?? "gray cat", forKey: "pet")
                    if UserDefaults.standard.bool(forKey: "isPro") {
                        userDefaults?.setValue(getWidgetData(timeData: timeData), forKey: "timeData")
                    } else {
                        userDefaults?.setValue(true, forKey: "noData")

                    }
                    userDefaults?.setValue(tagAndColor.name, forKey: "tagName")
                    userDefaults?.setValue(tagAndColor.color, forKey: "tagColor")
                    userDefaults?.setValue(UserDefaults.standard.integer(forKey: "defaultTime"), forKey: "defaultTime")
                    WidgetCenter.shared.reloadTimelines(ofKind: "co.byteteam.focusbyte.focuswidget")
                }
            }
        }
        coinsL.countFromZero(to: Float(coins), duration: .brisk)
    }
    override func viewWillDisappear(_ animated: Bool) {
        onHome = false
        counter = 0
        tappedVideoBool = false
        self.timer.invalidate()
        self.timer = Timer()
        self.breakTimer.invalidate()
        self.breakTimer = Timer()
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.protectedDataWillBecomeUnavailableNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.protectedDataDidBecomeAvailableNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:  Notification.Name("goToStats"), object: nil)
        NotificationCenter.default.removeObserver(self, name:  Notification.Name("openedFromWidget"), object: nil)
        NotificationCenter.default.removeObserver(self, name:  Notification.Name("changePet"), object: nil)
    }
    
    
    //MARK: - helper functions
    func updateTagView() {
        getRealmData()
        tagTitle.removeFromSuperview()
        tagImageView.removeFromSuperview()
        createTagImageView()
        if #available(iOS 14.0, *) {
            userDefaults?.setValue(tagAndColor.name, forKey: "tagName")
            userDefaults?.setValue(tagAndColor.color, forKey: "tagColor")
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    func checkIfPro() {
        Purchases.shared.purchaserInfo { [self] (purchaserInfo, error) in
                if purchaserInfo?.entitlements.all["isPro"]?.isActive == true {
                    UserDefaults.standard.setValue(true, forKey: "isPro")
                } else {
                    if !UserDefaults.standard.bool(forKey: "trippleTapped") {
                        UserDefaults.standard.setValue(false, forKey: "isPro")
                        if !UserDefaults.standard.bool(forKey: "noLogin") {
                            if let email = Auth.auth().currentUser?.email {
                                var isPro = false
                                let docRef = db.collection(K.FStore.collectionName).document(email)
                                docRef.getDocument { (snapshot, error) in
                                    if let document = snapshot, document.exists {
                                        _ = document.data().map(String.init(describing:)) ?? "nil"
                                        if let isP = document["isPro"] {
                                            isPro = isP as! Bool
                                        }
                                    }
                                    if isPro {
                                        UserDefaults.standard.setValue(true, forKey: "isPro")
                                    }
                                }
                                Firestore.firestore().collection(K.userPreferenes).document(email).updateData([
                                    "isPremium": false,
                                ]) { (error) in
                                    if let e = error {
                                        print("There was a issue saving data to firestore \(e) ")
                                    } else {
                                        print("Succesfully saved new items")
                                    }
                                }
                            }

                        }
                    }
                }
        }
    }
    func configureUI() {
        self.navigationController?.navigationItem.hidesBackButton = true
        coinsImg = UIImageView(image: UIImage(named: "coins")!)
        coinsImg!.frame.size.width = 25
        coinsImg!.frame.size.height = 30
        coinsImg?.center.x =  view.center.x + 80
        coinsImg?.center.y = 20
        
        coinsL.frame.size.width = 100
        coinsL.frame.size.height = 25
        coinsL.layer.cornerRadius = 25
        coinsL.textColor = .white
        coinsL.backgroundColor = darkPurple
        coinsL.center.x =  view.center.x + 120
        coinsL.center.y = 20
        coinsL.textAlignment = .center
        coinsL.font = UIFont(name: "Menlo-Bold", size: 20)
        
        plusIcon.frame.size.width = 30
        plusIcon.frame.size.height = 30
        plusIcon.center.x =  view.center.x + 165
        plusIcon.center.y = 20
        let plusTapped = UITapGestureRecognizer(target: self, action: #selector(tappedPlus))
        plusIcon.addGestureRecognizer(plusTapped)
        plusIcon.isUserInteractionEnabled = true
        
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
        view.addSubview(timerButton)
        
        createTimerButton()
        createTimerButtonLbl()
        let breakTapped = UITapGestureRecognizer(target: self, action: #selector(self.breakPressed))
        self.breakButton.addGestureRecognizer(breakTapped)
        
        chestImageView?.image =  UIImage(named: chest)!
        chestImageView?.sizeToFit()
        chestImageView?.center.x = view.center.x
        chestImageView?.center.y = view.center.y - 50
        view.insertSubview(chestImageView!, at: 10)
        
        createQuoteLabel()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        timerButton.addGestureRecognizer(tap)
        
        createXImageView()
        createTagImageView()
        
        view.backgroundColor = backgroundColor
//        navigationItem.title =  "Home"

        createBarItem()
        navigationController?.navigationBar.addSubview(coinsL)
        navigationController?.navigationBar.addSubview(coinsImg!)
         navigationController?.navigationBar.addSubview(plusIcon)
        
        createCircularSlider()
        var launched = defaults.integer(forKey: "launchNumber")
        if launched == 2 {
            SKStoreReviewController.requestReview()
            AppsFlyerLib.shared().logEvent("launched_review", withValues: [AFEventParamContent: "true"])
            launched += 1
            defaults.setValue(launched, forKey: "launchNumber")
        }
    }
    private func createLevelLabel() {
        view.addSubview(levelLabel)
        levelLabel.centerX(to: view)
        levelLabel.bottomAnchor.constraint(equalTo: chestImageView!.topAnchor, constant: -40).isActive = true
        levelLabel.text = "LVL:\(level)"
    }
     func createQuoteLabel() {
        createLevelLabel()
        if UserDefaults.standard.bool(forKey: "quotes") == true {
            view.addSubview(quoteLabel)
            quoteLabel.numberOfLines = 0
            quoteLabel.adjustsFontSizeToFitWidth = true
            quoteLabel.translatesAutoresizingMaskIntoConstraints = false
            quoteLabel.width(view.frame.width * 0.95)
            quoteLabel.height(view.frame.height * 0.10)
            let num = UserDefaults.standard.bool(forKey: "isPro") ? quotesPro.count : quotes.count
            let randQuoteNum = Int.random(in: 0..<num)
            quoteLabel.text = num > 15 ? quotesPro[randQuoteNum] : quotes[randQuoteNum]
            quoteLabel.textAlignment = .center
            quoteLabel.textColor = .white
            quoteLabel.font = UIFont(name: "Menlo-Bold", size: 15)
            quoteLabel.centerX(to: view)
            quoteLabel.bottomAnchor.constraint(equalTo: chestImageView!.topAnchor, constant: -80).isActive = true
        }
    }
    @objc func tappedGift() {
        if !isPlaying {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            let dailyBonusView = DailyBonusView(frame: UIScreen.main.bounds)
            view.addSubview(dailyBonusView)
            dailyBonusView.rootController = self
            dailyBonusView.setUpView()
            dailyBonusView.navigationBar = navigationController!.navigationBar
            navigationController?.navigationBar.alpha = 0.3
            navigationController?.navigationBar.isUserInteractionEnabled = false
        }
    }
    
    @objc func tappedFlame() {
        if !isPlaying {
            print("bing")
        }
    }

     func createBarItem() {
        var giftImg = UIImage()
        if totalBonuses == 0 {
            giftImg = (UIImage(named: "gift-box")?.resized(to: CGSize(width: 35, height: 35)).withRenderingMode(.alwaysOriginal))!
        } else {
            giftImg = UIImage().textToImage(drawText: "\(totalBonuses)", inImage: UIImage(named: "gift-box")!.resized(to: CGSize(width: 35, height: 35)), atPoint: CGPoint(x: 20, y: 20)).withRenderingMode(.alwaysOriginal)
        }
        let giftBox = UIBarButtonItem(image: giftImg, style: .plain, target: self, action: #selector(tappedGift))
        giftBox.tintColor = .none
        giftBox.imageInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
        
        let flameImage = UIImage().textToImage(drawText: "\(streakNumber)", inImage: UIImage(named: "flame")!.resized(to: CGSize(width: 40, height: 40)), atPoint: CGPoint(x: 20, y: 25)).withRenderingMode(.alwaysOriginal)
        let flame = UIBarButtonItem(image: flameImage, style: .plain, target: self, action: #selector(tappedGift))
        
        flame.tintColor = .none
        flame.imageInsets = UIEdgeInsets(top: 0, left: -125, bottom: 0, right: 0)
                                      
        navigationItem.leftBarButtonItems = [UIBarButtonItem(image: resizedMenuImage?.withTintColor(.white), style: .plain, target: self, action: #selector(handleMenuToggle)), giftBox, (!isIpod ? flame : UIBarButtonItem())]
    }
    
    func displayalert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction((UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            alert.dismiss(animated: true, completion: nil)
            
        })))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func tappedTag() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        if UserDefaults.standard.bool(forKey: "isPro") == true {
            tagTableView = TagTableView(frame: view.bounds)
            tagTableView.tagDelegate = self
            view.addSubview(tagTableView)
            navigationController?.navigationBar.alpha = 0.3
            navigationController?.navigationBar.isUserInteractionEnabled = false
            tagTableView.navigationBar = navigationController!.navigationBar
        }   else {
            let controller = SubscriptionController()
            controller.modalPresentationStyle = .fullScreen
            controller.idx = 2
            presentInFullScreen(UINavigationController(rootViewController: controller), animated: true, completion: {
                self.circularSlider.removeFromSuperview()
            })
        }
    }
    //MARK: - Helper UI Funcs
     final func createTimerButtonLbl() {
        timerButtonLbl.translatesAutoresizingMaskIntoConstraints = false
        if !isPlaying {
            timerButtonLbl.text = "Start"
        } else {
            timerButtonLbl.text = "Give Up"
        }
    
        timerButtonLbl.sizeToFit()
        timerButtonLbl.textColor = .white
        timerButton.addSubview(timerButtonLbl)
        timerButtonLbl.center(in: timerButton)
        timerButtonLbl.font = UIFont(name: "Menlo-Bold", size: 20)
    }
    
     final func createTimerButton() {
        timerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timerButton)
        timerButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        timerButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        timerButton.centerX(to: view)
        timerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80 + CGFloat(iphone8Padding)).isActive = true
        timerButton.backgroundColor = darkPurple
        timerButton.layer.cornerRadius = 25
        timerButton.applyDesign(color: darkPurple)
    }
    
     final func createXImageView() {
        xImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(xImageView)
        xImageView.height(70)
        xImageView.width(70)
        xImageView.leadingAnchor.constraint(equalTo: timerButton.trailingAnchor, constant: 20).isActive = true
        xImageView.centerYAnchor.constraint(equalTo: timerButton.centerYAnchor).isActive = true
        xImageView.isUserInteractionEnabled = true
        xImageView.layer.cornerRadius = 10
        let largeConfiguration = UIImage.SymbolConfiguration(weight: .bold)
        let img = UIImage(systemName: "xmark", withConfiguration: largeConfiguration)?.withTintColor(.white, renderingMode:.alwaysOriginal)
        xImageView.image = img
        let tappedX = UITapGestureRecognizer(target: self, action: #selector(xTapped))
        xImageView.addGestureRecognizer(tappedX)
        xImageView.contentMode = .center
        xImageView.backgroundColor = darkRed
        xImageView.applyDesign(color: darkRed)
    }
    
     final func createTagImageView() {
        tagImageView.translatesAutoresizingMaskIntoConstraints = false
        tagImageView.height(70)
        tagImageView.width(70)
        view.addSubview(tagImageView)
        tagImageView.trailingAnchor.constraint(equalTo: timerButton.leadingAnchor, constant: -20).isActive = true
        tagImageView.centerYAnchor.constraint(equalTo: timerButton.centerYAnchor).isActive = true
        tagImageView.isUserInteractionEnabled = true
        tagImageView.layer.cornerRadius = 10
        tagImageView.contentMode = .scaleAspectFit
        tagImageView.image = #imageLiteral(resourceName: "tagIcon").withTintColor(K.getColor(color: tagAndColor.color))
        tagImageView.backgroundColor = superLightLavender
        tagImageView.layer.cornerRadius = 25
        tagImageView.applyDesign(color: superLightLavender)
        let tagTapped = UITapGestureRecognizer(target: self, action: #selector(tappedTag))
        tagImageView.addGestureRecognizer(tagTapped)
        
        tagTitle.font = UIFont(name: "Menlo", size: 13)
        tagImageView.addSubview(tagTitle)
        tagTitle.text = tagAndColor.name
        tagTitle.lineBreakMode = .byTruncatingTail
        tagTitle.textAlignment = .center
        tagTitle.width(50)
        tagTitle.height(10)
        tagTitle.bottom(to: tagImageView, offset: -5)
        tagTitle.centerX(to: tagImageView)
    }
    
    final func createStartUI() {
        createLevelLabel()
        timerButton.removeFromSuperview()
        createTimerButton()
        createXImageView()
        createTagImageView()
        createTimerButtonLbl()
        timerButtonLbl.text = "Start"
        chestImageView?.image = UIImage(named: chest)
        timeL.font = UIFont(name: "Menlo-Bold", size: 65)
        breakButton.removeFromSuperview()
        breakButtonLbl.removeFromSuperview()
        deepFocusLabel.removeFromSuperview()
        deepFocusView.removeFromSuperview()
        createCircularSlider()
    }
    
 
    
    
    //MARK: - Handlers
    @objc func handleMenuToggle() {
        if !isPlaying {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            isOpen = !isOpen
            delegate?.handleMenuToggle(forMenuOption: nil)
        }
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let _ = error {}
        }
        UIApplication.shared.registerForRemoteNotifications()
        if let colon = self.timeL.text?.firstIndex(of: ":") {
            durationString = String((self.timeL.text?[..<colon])!)
        }
        if timerButtonLbl.text == "Timer" {
            !isIpod ? createStartUI() : createIpodStartUI()
            return
        }
        if !self.view.subviews.contains(quoteLabel) && self.view.subviews.contains(breakL) {
            createQuoteLabel()
        }
        
        if isPlaying && timerButtonLbl.text == "Give Up" {
            giveUpAlert()
        } else if durationString != "0"{
            print(durationString, "durationString")
            isPlaying = true
            counter = ((Int(durationString) ?? 10) * 60)
            print("counter", counter)
            howMuchTime = ((Int(durationString) ?? 10) * 60)
            self.mins = counter/60
            self.secs = counter%60
            timerButtonLbl.text = "Give Up"
            createTimerButtonLbl()
            levelLabel.removeFromSuperview()
            timerButton.backgroundColor = darkRed
            chestImageView?.loadGif(name: "mapGif")
            // create my track layer
            if !isIpod {
                createShapeLayer()
            } else {
                createIpodLayer()
            }
            countDownTimer()
            breakTimer.invalidate()
            breakL.removeFromSuperview()
            circularSlider.removeFromSuperview()
            xImageView.removeFromSuperview()
            tagImageView.removeFromSuperview()
        }
    }
    
    
    func createShapeLayer() {
        var center = view.center
        center.y = view.center.y - 50
        let circularPath = UIBezierPath(arcCenter: center, radius: 130, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = lightLavender.cgColor
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
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        let alert = LWAlert.init(customData: [["1", "2", "3", "4", "5","6","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28",
                                               "29","30"], ["minutes", "seconds"]])
        alert.customPickerBlock = { str in
            self.breakTime = str.split(separator: "-")
            self.startBreakTimer()
        }
        alert.show()
    }
    
    
    @objc func xTapped() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        circularSlider.removeFromSuperview()
        if !isIpod {
            createShapeLayer()
        } else {
            createIpodLayer()
        }
       twoButtonSetup()
    }
    
    
    func giveUpAlert() {
        let alert = UIAlertController(title: "Are you sure you want to give up?", message:"The search for treasure will stop", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] (action) in
            counter = 0
            DispatchQueue.main.async {
                self.timer.invalidate()
            }
            self.timeL.text = "Let's Go \nAgain!"
            isPlaying = false
           twoButtonSetup()
//Add break button and timer button
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            return
        }))
        navigationController?.present(alert, animated: true)
    }
//    func createBasicAnimation() {
//        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
//        basicAnimation.toValue = 1
//        basicAnimation.fillMode = CAMediaTimingFillMode.backwards
//        basicAnimation.isRemovedOnCompletion = false
//
//        shapeLayer.add(basicAnimation, forKey: "basic")
//        let defaults = UserDefaults.standard
//        defaults.set("playing", forKey: "status")
//
//        basicAnimation.duration = CFTimeInterval(counter + (counter/4))
//        self.shapeLayer.add(basicAnimation, forKey: "basic")
//    }
//
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
        self.levelLabel.removeFromSuperview()
        self.timerButtonLbl.removeFromSuperview()
        self.shapeLayer.removeFromSuperlayer()
        self.tagImageView.removeFromSuperview()
        self.timerButton.removeFromSuperview()
        self.xImageView.removeFromSuperview()
        self.breakButton.applyDesign(color: darkRed)
        
        self.timeL.numberOfLines = 2
        self.timeL.text = "Let's Go \nAgain!"
        self.timeL.font = UIFont(name: "Menlo-Bold", size: 30)
        
        self.chestImageView?.image = UIImage(named: chest)
        
        self.timerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timerButton)
        self.timerButton.backgroundColor = darkPurple
        self.timerButton.applyDesign(color: darkPurple)
        timerButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        timerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 110).isActive = true
        timerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80 + CGFloat(iphone8Padding)).isActive = true
        
        let tappedDF = UITapGestureRecognizer(target: self, action: #selector(dfTapped))
        deepFocusView.addGestureRecognizer(tappedDF)
        deepFocusView.translatesAutoresizingMaskIntoConstraints = false
        deepFocusView.backgroundColor = superLightLavender
        view.addSubview(deepFocusView)
        deepFocusView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        deepFocusView.centerYAnchor.constraint(equalTo: timerButton.centerYAnchor).isActive = true
        deepFocusView.heightAnchor.constraint(equalToConstant: 65).isActive = true
        deepFocusView.widthAnchor.constraint(equalToConstant: 65).isActive = true
        deepFocusView.layer.cornerRadius = 25
        deepFocusView.applyDesign(color: superLightLavender)
        
        
        self.deepFocusLabel.sizeToFit()
        deepFocusView.addSubview(deepFocusLabel)
        deepFocusLabel.center(in: deepFocusView)
        
        createTimerButtonLbl()
        timerButtonLbl.text = "Timer"
        
        self.view.addSubview(self.breakButton)
        breakButton.translatesAutoresizingMaskIntoConstraints = false
        breakButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        breakButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        breakButton.centerYAnchor.constraint(equalTo: timerButton.centerYAnchor).isActive = true
        breakButton.leadingAnchor.constraint(equalTo: timerButton.trailingAnchor, constant: 20).isActive = true
        self.breakButton.backgroundColor = darkRed
        self.breakButton.layer.cornerRadius = 25
        self.breakButton.isUserInteractionEnabled = true
        
        self.breakButtonLbl.translatesAutoresizingMaskIntoConstraints = false
        self.breakButtonLbl.font = UIFont(name: "Menlo-Bold", size: 20)
        self.breakButtonLbl.textColor = .white
        self.breakButtonLbl.text = "Break"
        self.breakButtonLbl.sizeToFit()
        self.breakButton.addSubview(self.breakButtonLbl)
        breakButtonLbl.center(in: breakButton)
    }
    @objc func tappedPlus() {
        if !isPlaying {
            coinsL.removeFromSuperview()
            coinsImg?.removeFromSuperview()
            plusIcon.removeFromSuperview()
            quoteLabel.removeFromSuperview()
            levelLabel.removeFromSuperview()
            chestImageView?.removeFromSuperview()
            circularSlider.removeFromSuperview()
            self.navigationController?.pushViewController(UpgradeChestController(), animated: true)
        }
    }
    
    @objc func dfTapped() {
        let appearance = SCLAlertView.SCLAppearance(
            kWindowWidth: 300,
            kWindowHeight: 100,
            kButtonHeight: 35,
            kTitleFont: UIFont(name: "Menlo", size: 18)!,
            kTextFont: UIFont(name: "Menlo", size: 15)!,
            showCloseButton: false,
            showCircularIcon: false,
            hideWhenBackgroundViewIsTapped: true
        )
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        title.text = "Deep Focus Mode"
        title.font = UIFont(name: "Menlo-Bold", size: 18)
        let description = UILabel()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.numberOfLines = 0
        description.text = "Leaving the app  will\ncause your treasure\nsearch to end"
        description.font = UIFont(name: "Menlo", size: 15)
        let alertView = SCLAlertView(appearance: appearance)
        let subview = UIView(frame: CGRect(x:0,y:0,width:300,height:100))
        subview.addSubview(self.dfmSwitch)
        dfmSwitch.translatesAutoresizingMaskIntoConstraints = false
        dfmSwitch.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 10).isActive = true
        dfmSwitch.topAnchor.constraint(equalTo: subview.topAnchor, constant: 30).isActive = true
        dfmSwitch.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
        subview.addSubview(title)
        title.leadingAnchor.constraint(equalTo: dfmSwitch.trailingAnchor, constant: 15).isActive = true
        title.topAnchor.constraint(equalTo: subview.topAnchor, constant: 10).isActive = true
        subview.addSubview(description)
        description.leadingAnchor.constraint(equalTo: dfmSwitch.trailingAnchor, constant: 15).isActive = true
        description.topToBottom(of: title, offset: 5)
        
        
        alertView.customSubview = subview
        alertView.showCustom("Select Mode", subTitle: "", color: .white, icon: UIImage())
    }
    
    @objc func switchToggled(sender:UISwitch!) {
        if (sender.isOn == true){
            deepFocusMode = true
        }
        else{
            deepFocusMode = false
        }
        saveToRealm()
    }
    @objc func updateCoins(){
        updateCoinLabel(numCoins: loot)
    }
  func updateCoinLabel(numCoins: Int) -> Int? {
        let prevNumOfCoins = numCoins
        var numOfCoins = numCoins
        let prevExp = exp
        let  prevLevel = Int((pow(Double(exp), 1.0/2.0)))
        var coinMultiplier = 1
        var expMultiplier = 1
        switch self.chest {
        case "goldChest":
            coinMultiplier = 2
        case "epicChest":
            expMultiplier = 2
        case "diamondChest":
            coinMultiplier = 2
            expMultiplier = 2
        default:
            break
        }
        switch howMuchTime {
        case 599...1499:
            numOfCoins += 5 * coinMultiplier
            exp += 3 * expMultiplier
        case 1500...2999:
            numOfCoins += 10 * coinMultiplier
            exp += 5 * expMultiplier
        case 3000...4499:
            numOfCoins += 20 * coinMultiplier
            exp += 8 * expMultiplier
        case 4500...5999:
            numOfCoins += 30 * coinMultiplier
            exp += 11 * expMultiplier
        case 6000...7201:
            numOfCoins += 40 * coinMultiplier
            exp += 15 * expMultiplier
        case 8000:
            numOfCoins += 150
            exp += 0
        case 10000:
            numOfCoins += 250
            exp += 100
        default:
            numOfCoins += 2 * coinMultiplier
            exp += 1 * expMultiplier
        }
        
        expReceived = exp - prevExp
        coinsReceived = numOfCoins - prevNumOfCoins
        //experience algo
        let  level = Int((pow(Double(exp), 1.0/2.0)))
        if (prevLevel != level) { // 0.000001 can be changed depending on the level of precision you need
            if level == 15 {
                createAlert(evolved: 15)
                AppsFlyerLib.shared().logEvent("Evolved_15", withValues: [AFEventParamContent: "true"])
            } else if level == 34 {
                createAlert(evolved: 34)
                AppsFlyerLib.shared().logEvent("Evolved_34", withValues: [AFEventParamContent: "true"])
            } else {
                AppsFlyerLib.shared().logEvent("Level_Up", withValues: [AFEventParamContent: "true"])
                Analytics.logEvent(AnalyticsEventLevelUp, parameters: ["level_to":level])
                createAlert(leveled: true)
            }
        } else {
            createAlert()
        }
        if #available(iOS 14.0, *) {
            userDefaults?.setValue(level, forKey: "level")
            userDefaults?.setValue(numOfCoins, forKey: "coins")
            WidgetCenter.shared.reloadAllTimelines()
        }
        self.coinsL.text = String(numOfCoins)
        coins = numOfCoins
        return numOfCoins
    }
    
}

