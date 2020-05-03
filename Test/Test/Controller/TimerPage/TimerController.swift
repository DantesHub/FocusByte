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
import LWAlert

var exp = 0
var coins = 0

var isPlaying = false
class TimerController: UIViewController {
    //MARK: - Properties
    var results: Results<User>!
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    var time = 600
    let timeL = UILabel()
    var circularSlider = CircularSlider()
    var motivationalQuote = ""
    let coinsL = AnimatedLabel()
    var imageView: UIImageView? = {
        let iv = UIImageView()
        iv.sizeToFit()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
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
    let db = Firestore.firestore()
    var durationString = ""
    var counter = 0
    var currentValueLabel: UILabel!
    var ref: DatabaseReference!
    var delegate: ContainerControllerDelegate!
    
    
    //MARK: -Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar(color: backgroundColor, isTrans: true)
        createCircularSlider()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
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
    
    //MARK: - helper functions
    func configureUI() {
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
        
        timerButton.frame.size.width = 180
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
        
        
        shadowView = UIView(frame: CGRect(x: view.center.x - 100 , y: timerButton.center.y-30 , width: 180, height: 75))
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
        
        self.breakButton.isUserInteractionEnabled = true
        let breakTapped = UIGestureRecognizer(target: self, action: #selector(self.breakPressed(_:)))
        self.breakButton.addGestureRecognizer(breakTapped)
        
        breakShadow = UIView(frame: CGRect(x: view.center.x + 35 , y: timerButton.center.y-30 , width: 130, height: 75))
            breakShadow.backgroundColor = .clear
            breakShadow.layer.cornerRadius = 25
        breakShadow.dropShadow(superview: breakButton)
        
        imageView?.image =  UIImage(named: "chest")!
        imageView?.sizeToFit()
        imageView?.center.x = view.center.x
        imageView?.center.y = view.center.y - 50
        view.insertSubview(imageView!, at: 10)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        timerButton.addGestureRecognizer(tap)
        
        view.backgroundColor = backgroundColor
        navigationItem.title = "Home"
        navigationItem.leftBarButtonItem =  UIBarButtonItem(image: resizedMenuImage?.withTintColor(.white), style: .plain, target: self, action: #selector(handleMenuToggle))
        navigationController?.navigationBar.addSubview(coinsL)
        navigationController?.navigationBar.addSubview(coinsImg!)
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
        if let colon = self.timeL.text?.firstIndex(of: ":") {
            durationString = String((self.timeL.text?[..<colon])!)
        }
        if timerButtonLbl.text == "Go Again"{
            timerButtonLbl.text = "Start"
            timerButton.backgroundColor = darkPurple
            timerButtonLbl.sizeToFit()
            imageView?.image = UIImage(named: "chest")
            timerButtonLbl.center.x = view.center.x
            view.addSubview(timerButtonLbl)
            timeL.font = UIFont(name: "Menlo-Bold", size: 65)
            createCircularSlider()
            return
        } else if timerButtonLbl.text == "Try Again" {
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
            return
        }
        if isPlaying {
            giveUpAlert()
        } else if durationString != "0"{
            isPlaying = true
            timerButtonLbl.text = "Give Up"
            timerButton.backgroundColor = darkRed
            timerButtonLbl.sizeToFit()
            timerButtonLbl.center.x = view.center.x
            imageView?.image = #imageLiteral(resourceName: "map")
            view.addSubview(timerButtonLbl)
            var center = view.center
            center.y = view.center.y - 50
            // create my track layer
            
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
            counter = ((Int(durationString) ?? 10) * 60)
            basicAnimation.duration = CFTimeInterval((Int(durationString) ?? 10) * 60)
            self.shapeLayer.add(basicAnimation, forKey: "basic")
            countDownTimer()
            circularSlider.removeFromSuperview()
        }
    }
    
    //MARK: - timer functions
    func countDownTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(incrementCount), userInfo: nil, repeats: true)
    }
    
    @objc func incrementCount() {
        counter -= 1
        if counter == 0 {
            isPlaying = false
            let numCoins = Int((self.coinsL.text!))!
            let coins = self.updateCoinLabel(numCoins: numCoins)
            self.coinsL.text = String(coins!)
            if let _ = Auth.auth().currentUser?.email {
                let email = Auth.auth().currentUser?.email
                self.db.collection(K.userPreferenes).document(email!).setData([
                    "coins": coins!,
                    "exp": exp
                ], merge: true) { (error) in
                    if let e = error {
                        print("There was a issue saving data to firestore \(e) ")
                    } else {
                        self.saveToRealm()
                        print("Succesfully saved")
                    }
                }
            }
            self.timerButton.backgroundColor = lightPurple
            self.timerButtonLbl.text = "Go Again"
            self.timerButtonLbl.sizeToFit()
            self.timerButtonLbl.center.x = self.view.center.x
            self.view.addSubview(self.timerButtonLbl)
            timer.invalidate()
            self.imageView?.image = #imageLiteral(resourceName: "openedChest")
            self.timeL.text = "Great job! You found \(self.coinsReceived!) coins and gained \(self.expReceived!) exp"
            self.timeL.font = UIFont(name: "Menlo-Bold", size: 20)
            self.timeL.numberOfLines = 3
            self.view.addSubview(self.timeL)
            self.shapeLayer.removeFromSuperlayer()
            isPlaying = false
            return
        }
        
        let minutes = String(counter/60)
        var seconds = String(counter%60)
        if Int(seconds)! < 10 {
            seconds = "0" + seconds
        }
        timeL.text = "\(minutes):\(seconds)"
    }
    
    @objc func breakPressed(_ sender: UITapGestureRecognizer? = nil) {
        print("pressed")
           let alert = LWAlert.init(customData: [["1", "2", "3", "4", "5","6","8","9","10"], ["minutes", "seconds", "hours"]])
            alert.customPickerBlock = { str in
                       print(str)
            }
        alert.show()
    }
    
    func giveUpAlert() {
        let alert = UIAlertController(title: "Are you sure you want to give up?", message:"The search for treasure will stop", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            DispatchQueue.main.async {
                self.timer.invalidate()
            }
            isPlaying = false
           
            self.breakButton.frame.size.width = 130
            self.breakButton.frame.size.height = 75
            self.breakButton.center.x = self.view.center.x + 110
            self.breakButton.backgroundColor = darkRed
            self.breakButton.center.y = self.timeL.center.y + 100
            self.breakButton.layer.cornerRadius = 25
            self.breakButtonLbl.font = UIFont(name: "Menlo-Bold", size: 20)
            self.breakButtonLbl.textColor = .white
            self.view.addSubview(self.breakButton)
            self.view.addSubview(self.breakShadow)
            self.view.insertSubview(self.breakButton, aboveSubview: self.breakShadow)
            self.timeL.numberOfLines = 2
            self.timeL.text = "Let's Go \nAgain!"
            self.timeL.font = UIFont(name: "Menlo-Bold", size: 30)
            self.timerButton.center.x = self.view.center.x - 70
            self.shadowView.center.x = self.view.center.x - 70
            self.timerButtonLbl.text = "Try Again"
            self.imageView?.image = UIImage(named: "chest")
            self.timerButton.backgroundColor = darkPurple
            self.breakButtonLbl.text = "Break"
            self.timerButtonLbl.sizeToFit()
            self.breakButtonLbl.sizeToFit()
            self.timerButtonLbl.center.x = self.view.center.x - 70
            self.breakButtonLbl.center.x = self.breakButton.center.x
            self.breakButtonLbl.center.y = self.breakButton.center.y
            
           
        
            self.view.addSubview(self.breakButtonLbl)
            self.view.addSubview(self.timerButtonLbl)
            self.shapeLayer.removeFromSuperlayer()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
               return
        }))
        self.present(alert, animated: true)
    }
    
    func saveToRealm() {
        results = uiRealm.objects(User.self)
        for result  in results {
            if result.isLoggedIn == true {
                do {
                    try uiRealm.write {
                        result.setValue(Int(coinsL.text!)!, forKey: "coins")
                        result.setValue(exp, forKey: "exp")
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
        
        switch counter {
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
            numOfCoins += 2
            exp += 1
        }
        let  level = ((pow(Double(exp), 1.0/3.0)))
        if (level - floor(level) == 0) { // 0.000001 can be changed depending on the level of precision you need
            displayalert(title: "You Leveled Up!", message: "Congratulations you have leveled up!\n You are now level \(Int(level))")
        }
        expReceived = exp - prevExp
        coinsReceived = numOfCoins - prevNumOfCoins
        return numOfCoins
    }
    
}




