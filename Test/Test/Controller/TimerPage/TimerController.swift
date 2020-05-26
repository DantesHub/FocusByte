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
import TinyConstraints
import Foundation
import TinyConstraints
import SCLAlertView

var deepFocusMode = true
var exp = 0
var coins = 0
var counter = 0
var breakPlaying = false
var totalTime = 0
var isPro = true
var timeData = [String]()
var isPlaying = false
var tagSelected = "unset"
var tagColor = "gray"
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
    var howMuchTime: Int = 0
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
    var enteredForeground = false
    var deepFocusLabel = UILabel()
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
    
    //MARK: -Init
    override func viewDidLoad() {
        super.viewDidLoad()
        createObservers()
        configureUI()
        configureNavigationBar(color: backgroundColor, isTrans: true)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        createAlert()
        results = uiRealm.objects(User.self)
        for result  in results {
            if result.isLoggedIn == true {
                coins = result.coins
                exp = result.exp
                coinsL.text = String(coins)
                deepFocusMode = result.deepFocusMode
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
        
        view.addSubview(timerButton)
        createTimerButton()
        createTimerButtonLbl()
        let breakTapped = UITapGestureRecognizer(target: self, action: #selector(self.breakPressed))
        self.breakButton.addGestureRecognizer(breakTapped)
        
        imageView?.image =  UIImage(named: "chest")!
        imageView?.sizeToFit()
        imageView?.center.x = view.center.x
        imageView?.center.y = view.center.y - 50
        view.insertSubview(imageView!, at: 10)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        timerButton.addGestureRecognizer(tap)
        
        createXImageView()
        createTagImageView()
        
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
    
    @objc func tappedTag() {
        
        tagTableView = TagTableView(frame: view.bounds)
    
        view.addSubview(tagTableView)
        
    }
    //MARK: - Helper UI Funcs
        private final func createTimerButtonLbl() {
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
    
    private final func createTimerButton() {
        timerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timerButton)
        timerButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        timerButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        timerButton.centerX(to: view)
        timerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
        timerButton.backgroundColor = darkPurple
        timerButton.layer.cornerRadius = 25
        timerButton.applyDesign(color: darkPurple)
    }
       
       private final func createXImageView() {
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
       
       private final func createTagImageView() {
           tagImageView.translatesAutoresizingMaskIntoConstraints = false
           tagImageView.height(70)
           tagImageView.width(70)
           view.addSubview(tagImageView)
           tagImageView.trailingAnchor.constraint(equalTo: timerButton.leadingAnchor, constant: -20).isActive = true
           tagImageView.centerYAnchor.constraint(equalTo: timerButton.centerYAnchor).isActive = true
           tagImageView.isUserInteractionEnabled = true
           tagImageView.layer.cornerRadius = 10
           tagImageView.image = #imageLiteral(resourceName: "tagIcon")
           tagImageView.backgroundColor = superLightLavender
           tagImageView.layer.cornerRadius = 25
           tagImageView.contentMode = .scaleAspectFit
           tagImageView.applyDesign(color: superLightLavender)
           let tagTapped = UITapGestureRecognizer(target: self, action: #selector(tappedTag))
           tagImageView.addGestureRecognizer(tagTapped)
       }
    
    final func createStartUI() {
        timerButton.removeFromSuperview()
        createTimerButton()
        createXImageView()
        createTagImageView()
        createTimerButtonLbl()
        timerButtonLbl.text = "Start"
        imageView?.image = UIImage(named: "chest")
        timeL.font = UIFont(name: "Menlo-Bold", size: 65)
        breakButton.removeFromSuperview()
        breakButtonLbl.removeFromSuperview()
        deepFocusLabel.removeFromSuperview()
        deepFocusView.removeFromSuperview()
        createCircularSlider()
    }
    
    
    //MARK: - Handlers
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    

    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
    
        if let colon = self.timeL.text?.firstIndex(of: ":") {
            durationString = String((self.timeL.text?[..<colon])!)
        }
        if timerButtonLbl.text == "Timer" {
            createStartUI()
            return
        }
        if !self.view.subviews.contains(quoteLabel) && self.view.subviews.contains(breakL) {
                view.addSubview(quoteLabel)
            }
        
        if isPlaying {
            giveUpAlert()
        } else if durationString != "0"{
            isPlaying = true
            timerButtonLbl.text = "Give Up"
            createTimerButtonLbl()
            timerButton.backgroundColor = darkRed
            imageView?.loadGif(name: "mapGif")
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
        navigationController?.present(alert, animated: true)
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
        self.timerButton.removeFromSuperview()
        self.xImageView.removeFromSuperview()
        self.breakButton.applyDesign(color: darkRed)
   
        self.timeL.numberOfLines = 2
        self.timeL.text = "Let's Go \nAgain!"
        self.timeL.font = UIFont(name: "Menlo-Bold", size: 30)
        
        self.imageView?.image = UIImage(named: "chest")
        
        self.timerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timerButton)
        self.timerButton.backgroundColor = darkPurple
        self.timerButton.applyDesign(color: darkPurple)
        timerButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        timerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 110).isActive = true
        timerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
        
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
        
        self.deepFocusLabel.text = "🧠"
        self.deepFocusLabel.font = UIFont(name: "Menlo", size: 35)
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
        title.text = "🧠 Deep Focus Mode"
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
//        let showTimeout = SCLButton.ShowTimeoutConfiguration(prefix: "(", suffix: " s)")
//        alertView.addButton("Done", backgroundColor: brightPurple, textColor: .white, showTimeout: showTimeout) {
//            return
//        }
        
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

