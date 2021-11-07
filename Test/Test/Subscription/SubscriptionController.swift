//
//  SubscriptionController.swift
//  Todo
//
//  Created by Dante Kim on 1/15/21.
//  Copyright © 2021 Alarm & Calm. All rights reserved.
//

import UIKit
import TinyConstraints
import Purchases
import StoreKit
import Firebase
import AppsFlyerLib

class SubscriptionController: UIViewController {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(idx: Int = 0) {
        super.init(nibName: nil, bundle: nil)
        self.idx = idx
    }
    var topCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero
                                  , collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .lightGray
        return cv
    }()
    var packagesAvailableForPurchase = [Purchases.Package]()
    var topImages = ["cloud", "stats", "tagsfinal", "quotes", "heroCat", "dev"]
    var topTitles = ["Cloud Storage", "Statistics", "Custom Tagging", "New Quotes", "Limited Time!", "Support the Developer"]
    var topDescs = ["Data saved on the cloud so it's never lost, even if you log on to a different device", "Get access valuable insights and how your time is being spent.","Tag your timer sessions with custom tags to see how your time's being spent",  "Unlock 30+ new quotes to help you stay motivated", "Unlock the limited edition Hero Cat only available to pro users!",  "Help support me! Upcoming: sound tracks, chrome extension and new apps!"]
    var stories = ["\"The perfect cure for pandemic laziness\" \n- Dan K.", "\"Getting focusbyte pro was the best decision I made as a student in 2020 \"- Rose", "\"I was skeptical at first but so glad I went pro\"- Brendon N.", "\"Love this app, patiently waiting for spinoff apps\" \n- Matthew G."]
    var pics = ["pic1", "pic2", "pic3", "pic4"]
    var bottomCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        let cv = UICollectionView(frame: .zero
                                  , collectionViewLayout: layout)

        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .white
        return cv
    }()

    var idx = 0
    let yearlyBox = PriceBox()
    let monthlyBox = PriceBox()
    let lifeBox = PriceBox()
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.backgroundColor = .white
        view.frame = self.view.frame
        view.contentSize =  contentViewSize
        view.isUserInteractionEnabled = true
        view.showsVerticalScrollIndicator = false
        view.canCancelContentTouches = false
        view.isMultipleTouchEnabled = true
        return view
    }()
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        view.frame.size = contentViewSize
        return view
    }()
    var continueButton = UIButton()
    var continueDesc = UILabel()
    var header = UIView()
    var onceOnly = false
    let one = RoundView()
    let two = RoundView()
    let three = RoundView()
    var startedTimer = false
    var iphone12 = false
    let four = RoundView()
    let five = RoundView()
    let six = RoundView()
    let successStories = UILabel()
    var dots = [RoundView]()
    let upgradeLabel = UILabel()
    var monthlyPrice: Double = 0
    var yearlyPrice: Double = 0
    var lifePrice: Double = 0
    var yearlyMonthlyPrice: Double = 0
    let locale = Locale.current
    var onboarding = false
    var fromSettings = false
    var fromMenuOption = false
    var isPad = false

    var contentViewSize: CGSize {
        get {
            var height: CGFloat = -145
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1136:
                    height = 120
                    //iphone 540
                case 1334:
                    height = 80
                    //iphone 8 or SE
                case 1920, 2208:
                    height = 80
                    //("iphone 8plus")
                case 2436:
                    height = 25
                    //print("IPHONE X, IPHONE XS, IPHONE 11 PRO")
                case 2688:
                    height = 25
                    //print("IPHONE XS MAX, IPHONE 11 PRO MAX")
                case 2532: //iphone 12, pro
                    iphone12 = true
                    height = 25
                case 2778: //pro max
                    height = 25
                    iphone12 = true
                case 1792:
                     height = 25
                    //print("IPHONE XR, IPHONE 11")
                default:
                    height = 0
                }
            }
            return CGSize(width: self.view.frame.width, height: self.view.frame.height + height)
        }
    }
    //TODO
    // make it fullscreen & add pictures

    //MARK: - init
    override func viewDidLoad() {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            // It's an iPhone
            isPad = false
        case .pad:
            isPad = true

        default:
            break
            // Uh, oh! What could it be?
        }
        Purchases.shared.offerings { [self] (offerings, error) in
            if let offerings = offerings {
                let offer = offerings.current
                let packages = offer?.availablePackages
                guard packages != nil else {
                    return
                }
                for i in 0...packages!.count - 1 {
                    let package = packages![i]
                    self.packagesAvailableForPurchase.append(package)
                    let product = package.product
                    let price = product.price
                    let name = product.productIdentifier
                    print(price, "price", name, product.localizedTitle, "gabby")
                    if name == "co.byteteam.focusbyte.monthly.sub" {
                        monthlyPrice = round(100 * Double(truncating: price))/100
                    } else if name == "co.byteteam.focusbyte.annual.sub" {
                        yearlyPrice = round(100 * Double(truncating: price))/100
                        yearlyMonthlyPrice = (round(100 * (yearlyPrice/12))/100) - 0.01
                    } else if name == "co.byteteam.focusbyte.lifetime" {
                        lifePrice = round(100 * Double(truncating: price))/100
                    }
                }
            }
        }
        configureUI()
    }
    func scroll() {
    }
    override func viewDidLayoutSubviews() {
    }
    //MARK: - helper funcs
    func startTimer() {
        let _ =  Timer.scheduledTimer(timeInterval: 6.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }


    @objc func scrollAutomatically(_ timer1: Timer) {
        if #available(iOS 15, *) {
            for cell in topCollectionView.visibleCells {
                let indexPath: IndexPath? = topCollectionView.indexPath(for: cell)
                if ((indexPath?.row)! < 5){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: 0)
                    topCollectionView.scrollToItem(at: indexPath1!, at: .right, animated: true)
                }  else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: 0)
                    topCollectionView.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }
            }
        } else {
            for cell in topCollectionView.visibleCells {
                let indexPath: IndexPath? = topCollectionView.indexPath(for: cell)
                if ((indexPath?.row)! < 6){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: 0)
                    topCollectionView.scrollToItem(at: indexPath1!, at: .right, animated: true)
                }  else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: 0)
                    topCollectionView.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }
            }
        }

    }
    @objc func imageTappedTriple(sender: UITapGestureRecognizer) {
        UserDefaults.standard.setValue(true, forKey: "trippleTapped")
        AppsFlyerLib.shared().logEvent("triple_tapped", withValues: [AFEventParamContent: "true"])
       userWentPro()
    }
     func configureUI() {
         let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                           action: #selector(imageTappedTriple))
         tapGestureRecognizer.numberOfTapsRequired = 3
         self.scrollView.isUserInteractionEnabled = true
         self.scrollView.addGestureRecognizer(tapGestureRecognizer)
        view.addSubview(scrollView)
        self.scrollView.addSubview(self.containerView)
        view.isUserInteractionEnabled = true
         if #available(iOS 15, *) {
             let appearance = UINavigationBarAppearance()
             appearance.configureWithOpaqueBackground()
             appearance.titleTextAttributes =   [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                 NSAttributedString.Key.font: UIFont(name: "Menlo-Bold", size: 18)!]
             appearance.backgroundColor = .white
             UINavigationBar.appearance().standardAppearance = appearance
             UINavigationBar.appearance().scrollEdgeAppearance = appearance
         } else {
             navigationController?.navigationBar.barTintColor = .white
         }
         navigationController?.navigationBar.isTranslucent = false
         navigationItem.title = "Focusbyte Pro"

        view.backgroundColor = .white
        var btn = UIBarButtonItem()
        if !onboarding {
            btn = UIBarButtonItem(image: UIImage(named: "arrow")?.resize(targetSize: CGSize(width: 25, height: 25)).rotate(radians: -.pi/2)?.withTintColor(.lightGray).withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(tappedBack))
            btn.tintColor = .none
            navigationItem.leftBarButtonItem?.tintColor = .none
        } else {
            btn = UIBarButtonItem(title: "Next Time", style: .plain, target: self, action: #selector(tappedBack))
            btn.tintColor = .gray
            navigationItem.leftBarButtonItem?.tintColor = .gray
        }

        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = btn



        scrollView.addSubview(topCollectionView)
        topCollectionView.register(TopCell.self, forCellWithReuseIdentifier: "topCell")
        bottomCollectionView.register(BottomCell.self, forCellWithReuseIdentifier: "bottomCell")
        topCollectionView.translatesAutoresizingMaskIntoConstraints = false
        topCollectionView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
//        topCollectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width/2, height: view.frame.height * 0.30)
        topCollectionView.width(view.frame.width)
        topCollectionView.height(view.frame.height * 0.30)
        topCollectionView.delegate = self
        topCollectionView.dataSource = self

        dots = [one, two, three, four, five, six]
        for dot in dots {
            scrollView.addSubview(dot)
            dot.width(8)
            dot.height(8)
            dot.backgroundColor = .lightGray
            dot.topToBottom(of: topCollectionView, offset: UIDevice.current.hasNotch ? -25 : -15)
            dot.translatesAutoresizingMaskIntoConstraints = false
        }

        one.trailingToLeading(of: two, offset: -12)
        one.backgroundColor = .black
        two.trailingToLeading(of: three, offset: -12)
        three.trailingToLeading(of: four, offset: -12)
        four.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        five.leadingToTrailing(of: four, offset: 12)
        six.leadingToTrailing(of: five, offset: 12)

//
        successStories.text = "Success Stories"
        successStories.font = UIFont(name: "Menlo-Bold", size: 18)
        scrollView.addSubview(successStories)
        successStories.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        successStories.topToBottom(of: four, offset: 20)
        let currencySymbol = locale.currencySymbol!

        scrollView.addSubview(bottomCollectionView)
        bottomCollectionView.height(isIpod ? (view.frame.height * 0.225) : (view.frame.height * 0.20))
        bottomCollectionView.width(view.frame.width)
        bottomCollectionView.topToBottom(of: successStories, offset: 5)
        bottomCollectionView.backgroundColor = .white
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self
//
////        view.addSubview(upgradeLabel)
////        upgradeLabel.font = UIFont(name: "OpenSans-Bold", size: 20)
////        upgradeLabel.centerX(to: view)
////        upgradeLabel.text = "Upgrade to Premium Offer"
////        upgradeLabel.textColor = .darkGray
////        upgradeLabel.topToBottom(of: topCollectionView, offset: 40)
////        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
////        stackView.isLayoutMarginsRelativeArrangement = true
        scrollView.addSubview(lifeBox)
        lifeBox.height(view.frame.height * 0.075)
        lifeBox.topToBottom(of: bottomCollectionView, offset: 15)
        lifeBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lifeBox.width(view.frame.width * 0.84)
        lifeBox.selected = true
        lifeBox.priceLabel.text = "\(currencySymbol)\(lifePrice)"
        lifeBox.life = true
        lifeBox.width = view.frame.width * 0.84
        lifeBox.title.text = "FOR LIFE"
        lifeBox.height = view.frame.height * 0.08
        lifeBox.configure()
        lifeBox.configureLife()
        let lifeGest = UITapGestureRecognizer(target: self, action: #selector(tappedLife))
        lifeBox.addGestureRecognizer(lifeGest)

        scrollView.addSubview(yearlyBox)
        yearlyBox.width(view.frame.width * 0.84)
        yearlyBox.height(view.frame.height * 0.075)
        yearlyBox.topToBottom(of: lifeBox, offset: 10)
        yearlyBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        yearlyBox.selected = false
        yearlyBox.priceLabel.text = "\(currencySymbol)\(yearlyPrice)"
        yearlyBox.width = view.frame.width * 0.85
        yearlyBox.title.text = "Yearly Subscription"
        yearlyBox.smallLabel.text = "(\(currencySymbol)\(yearlyMonthlyPrice)/mo)"

        yearlyBox.height = view.frame.height * 0.20 * 0.05
        yearlyBox.configure()
        let yearlyGest = UITapGestureRecognizer(target: self, action: #selector(tappedYearly))
        yearlyBox.addGestureRecognizer(yearlyGest)

        scrollView.addSubview(monthlyBox)
        monthlyBox.topToBottom(of: yearlyBox, offset: 10)
        monthlyBox.height(view.frame.height * 0.075)
        monthlyBox.selected = false
        monthlyBox.width(view.frame.width * 0.84)
        monthlyBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        monthlyBox.priceLabel.text = "\(currencySymbol)\(monthlyPrice)"
        monthlyBox.life = false
        monthlyBox.title.text = "Monthly Subscription"
        monthlyBox.smallLabel.text = "(\(currencySymbol)\(monthlyPrice)/mo)"
        monthlyBox.height = view.frame.height * 0.20 *  0.08
        monthlyBox.configure()
        let monthlyGest = UITapGestureRecognizer(target: self, action: #selector(tappedMonthly))
        monthlyBox.addGestureRecognizer(monthlyGest)

        let box = UIView(frame: CGRect(x: 0, y: view.frame.size.height - (self.view.frame.height * (isIpod ? 0.25 : iphone12 ? 0.225 : 0.21)), width: view.frame.width, height: self.view.frame.height * 0.10))
        box.backgroundColor = .white
        view.addSubview(box)
        box.addSubview(continueButton)
        continueButton.center(in: box)

        continueButton.titleLabel?.font = UIFont(name: "Menlo-Bold", size: 20)
        continueButton.height(self.view.frame.height * 0.08)
        continueButton.width(self.view.frame.width * 0.84)
        continueButton.setTitle("CONTINUE", for: .normal)
        continueButton.backgroundColor = brightPurple
        continueButton.layer.cornerRadius = 15
        continueButton.addTarget(self, action: #selector(tappedContinue), for: .touchUpInside)
//

        let privacy = UILabel()
        let terms = UILabel()

        privacy.textColor = .lightGray
        terms.textColor = .lightGray

        privacy.text = "Privacy Policy"
        terms.text = "Terms of Use"
        privacy.font = UIFont(name: "OpenSans", size: 2)
        terms.font = UIFont(name: "OpenSans", size: 2)

        scrollView.addSubview(privacy)
        scrollView.addSubview(terms)
        privacy.translatesAutoresizingMaskIntoConstraints = false
        privacy.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        terms.trailingAnchor.constraint(equalTo: view  .trailingAnchor, constant: -15).isActive = true
        if !isPad {
            privacy.topToBottom(of: monthlyBox, offset: 15)
            terms.topToBottom(of: monthlyBox, offset: 15)
        } else {
            privacy.topToBottom(of: continueButton, offset: 15)
            terms.topToBottom(of: continueButton, offset: 15)
        }


        privacy.isUserInteractionEnabled = true
        terms.isUserInteractionEnabled = true
        let privacyGest = UITapGestureRecognizer(target: self, action: #selector(tappedPrivacy))
        privacy.addGestureRecognizer(privacyGest)
        let termsGest = UITapGestureRecognizer(target: self, action: #selector(tappedTerms))
        terms.addGestureRecognizer(termsGest)
        topCollectionView.scrollToItem(at: IndexPath(item: idx, section: 0), at: .right, animated: false)
    }

    @objc func tappedYearly()  {
        yearlyBox.selected = true
        yearlyBox.configure()
        monthlyBox.selected = false
        monthlyBox.configure()
        lifeBox.selected = false
        lifeBox.configure()
    }
    @objc func tappedMonthly() {
        monthlyBox.selected = true
        monthlyBox.configure()
        yearlyBox.selected = false
        yearlyBox.configure()
        lifeBox.selected = false
        lifeBox.configure()
    }
    @objc func tappedLife() {
        lifeBox.selected = true
        lifeBox.configure()
        yearlyBox.selected = false
        yearlyBox.configure()
        monthlyBox.selected = false
        monthlyBox.configure()
    }

    @objc func tappedPrivacy() {
        if let url = URL(string: "https://focusbyte.flycricket.io/privacy.html") {
            UIApplication.shared.open(url)
        }
    }
    @objc func tappedTerms() {
        if let url = URL(string: "https://focusbyte.io/terms-of-use") {
            UIApplication.shared.open(url)
        }
    }


    @objc func tappedContinue(sender:UIButton) {
        var package = packagesAvailableForPurchase[0]
        if yearlyBox.selected {
             package = packagesAvailableForPurchase.last { (package) -> Bool in
                return package.product.productIdentifier == "co.byteteam.focusbyte.annual.sub"
             }!
        } else if monthlyBox.selected {
             package = packagesAvailableForPurchase.last { (package) -> Bool in
                return package.product.productIdentifier == "co.byteteam.focusbyte.monthly.sub"
             }!
        } else {
            package = packagesAvailableForPurchase.last { (package) -> Bool in
               return package.product.productIdentifier == "co.byteteam.focusbyte.lifetime"
            }!
        }
        Purchases.shared.purchasePackage(package) { [self] (transaction, purchaserInfo, error, userCancelled) in
            if purchaserInfo?.entitlements.all["isPro"]?.isActive == true {
                // Unlock that great "pro" content
                let event = logEvent()
                AppsFlyerLib.shared().logEvent(name: event, values:
                                                [
                                                    AFEventParamRevenue:  yearlyBox.selected ? yearlyPrice : lifeBox.selected ? lifePrice : monthlyPrice,
                                                    AFEventParamCurrency:"\(locale.currencyCode!)"
                                                ])

                AppsFlyerLib.shared().logEvent(name: yearlyBox.selected ? "Yearly_Started_From_All" : lifeBox.selected ? "Lifetime_Started_From_All" : "Monthly_Started_From_All", values:
                                                [
                                                    AFEventParamContent: "true"
                                                ])
               userWentPro()

            } else if userCancelled {
                let event = logEvent(cancelled: true)
                AppsFlyerLib.shared().logEvent(event, withValues: [AFEventParamEventStart: "cancelled", AFEventParamCurrency: "\(locale.currencyCode!)"])
                AppsFlyerLib.shared().logEvent(yearlyBox.selected ? "cancelledPurchase_yearly"  : lifeBox.selected ? "cancelledPurchase_lifetime" : "cancelledPurchase_monthly", withValues: [AFEventParamEventStart: "cancelled", AFEventParamCurrency: "\(locale.currencyCode!)"])
                //send notification 24 hours later
                if lifeBox.selected {
                    let center = UNUserNotificationCenter.current()
                    let content = UNMutableNotificationContent()
                    content.title = "Don't Miss This Opportunity"
                    content.body = "🎉 Focusbyte Pro For Life is Gone in the Next 24 Hours!!! 🎉"
                    // Step 3: Create the notification trigger
                    let date = Date().addingTimeInterval(43200)
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
    }

    private func userWentPro() {
        UserDefaults.standard.setValue(true, forKey: "isPro")
        upgradedToPro = true
        let controller = ContainerController(center: TimerController())
        controller.modalPresentationStyle = .fullScreen
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes =   [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                NSAttributedString.Key.font: UIFont(name: "Menlo-Bold", size: 30)!]
            appearance.backgroundColor = .clear
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        self.presentInFullScreen(UINavigationController(rootViewController: controller), animated: false, completion: {
            UserDefaults.standard.setValue(true, forKey: "isPro")
            let users = uiRealm.objects(User.self)
            for user in users {
                if Auth.auth().currentUser?.email == user.email {
                    inventoryArray.append("Hero Cat")
                    try! uiRealm.write {
                        user.inventoryArray.append("Hero Cat")
                    }
                }
            }
            if let _ = Auth.auth().currentUser?.email {
                   let email = Auth.auth().currentUser?.email
                 Firestore.firestore().collection(K.userPreferenes).document(email!).updateData([
                        "isPro": true,
                        "coins": coins,
                        "inventoryArray": inventoryArray,
                        "exp": exp,
                        "TimeData": timeData
                   ]) { (error) in
                       if let e = error {
                           print("There was a issue saving data to firestore \(e) ")
                       } else {
                           print("Succesfully saved new items")
                       }
                   }
               }

        })
    }

    func logEvent(cancelled: Bool = false) -> String {
        let lst = ["Group", "Statistics", "Tags", "Repeat", "Notes"]
        var event = ""

        event = yearlyBox.selected ? "Yearly_Started_From_" : lifeBox.selected ? "Lifetime_Started_From_" : "Monthly_Started_From_"
        if cancelled {
            event = "Cancelled_" + event
        }
        if onboarding {
            event = event + "Onboarding"
        } else if fromSettings {
            event = event + "Settings"
        } else if fromMenuOption {
            event = event + "fromMenuOption"
        } else {
            event = event + lst[idx]
        }
              return event
    }

    @objc func tappedBack() {
        if onboarding {
            NotificationHelper.addPro()
        }
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes =   [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                NSAttributedString.Key.font: UIFont(name: "Menlo-Bold", size: 30)!]
            appearance.backgroundColor = .clear
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
        let nav = navigationController
        DispatchQueue.main.async { [self] in //make sure all UI updates are on the main thread.
            if self.onboarding {
                AppsFlyerLib.shared().logEvent("next_time_sub_onboarding", withValues: [AFEventParamEventStart: "true", AFEventParamCurrency: "\(locale.currencyCode!)"])
                nav?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
            } else {
                nav?.view.layer.add(CATransition().segueFromLeft(), forKey: nil)

            }
            nav?.pushViewController(ContainerController(center: TimerController()), animated: false)
        }

    }

}
