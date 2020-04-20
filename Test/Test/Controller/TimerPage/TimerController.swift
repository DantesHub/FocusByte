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
    var chest: UIImageView?
    var coinsReceived = 0
    var coinsImg: UIImageView?
    var timerButton = UIView()
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
        navigationItem.title = "Home"
        configureNavigationBar(color: backgroundColor, isTrans: true)
        configureUI()
        navigationItem.leftBarButtonItem =  UIBarButtonItem(image: resizedMenuImage?.withTintColor(.white), style: .plain, target: self, action: #selector(handleMenuToggle))
        navigationController?.navigationBar.addSubview(coinsL)
        navigationController?.navigationBar.addSubview(coinsImg!)

        createCircularSlider()
    }
   
    
    override func viewDidAppear(_ animated: Bool) {
           var coins = 0
           results = uiRealm.objects(User.self)
           for result  in results {
               if result.isLoggedIn == true {
                   coins = result.coins
                   coinsL.text = String(coins)
               }
           }
           coinsL.countFromZero(to: Float(coins), duration: .brisk)
    }
    
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
              timeL.center.y = view.center.y + 180
              timeL.lineBreakMode = .byClipping
              view.addSubview(timeL)

              
              timerButton.frame.size.width = 200
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
              
             
              let shadowView = UIView(frame: CGRect(x: view.center.x - 100 , y: timerButton.center.y-30 , width: 200, height: 75))
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

              chest = UIImageView(image: UIImage(named: "chest")!)
              chest?.sizeToFit()
              chest?.center.x = view.center.x + 15
              chest?.center.y = view.center.y - 60
              view.insertSubview(chest!, at: 10)
              
              let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
              timerButton.addGestureRecognizer(tap)
            
           
            view.backgroundColor = backgroundColor
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if timerButtonLbl.text == "Go Again" {
            timerButtonLbl.text = "Start"
            timerButton.backgroundColor = darkPurple
            timerButtonLbl.sizeToFit()
             timerButtonLbl.center.x = view.center.x
            view.addSubview(timerButtonLbl)
            timeL.font = UIFont(name: "Menlo-Bold", size: 65)
            createCircularSlider()
            return
        }
        if isPlaying {
            isPlaying = false
            timerButtonLbl.text = "Start"
            timerButton.backgroundColor = darkPurple
            timerButtonLbl.sizeToFit()
            timerButtonLbl.center.x = view.center.x
            view.addSubview(timerButtonLbl)
            shapeLayer.removeFromSuperlayer()
            createCircularSlider()
        } else {
            isPlaying = true
            timerButtonLbl.text = "Give Up"
            timerButton.backgroundColor = darkRed
            timerButtonLbl.sizeToFit()
            timerButtonLbl.center.x = view.center.x
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
            
            shapeLayer.add(basicAnimation, forKey: "urSoBasic")
            let defaults = UserDefaults.standard
            defaults.set("playing", forKey: "status")
            
            if let colon = self.timeL.text?.firstIndex(of: ":") {
                durationString = String((self.timeL.text?[..<colon])!)
            }
            counter = 10
            print("duration String" + durationString)
            basicAnimation.duration = CFTimeInterval((Int(durationString) ?? 10) * 60)
            print(CFTimeInterval((Int(durationString) ?? 10) * 60))
            self.shapeLayer.add(basicAnimation, forKey: "urSoBasic")
            countDownTimer()
            circularSlider.removeFromSuperview()
        }
    }
    func countDownTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self](timer) in
            guard let strongself = self else { return }
            strongself.counter -= 1
            if strongself.counter == 0 {
                let numCoins = Int((self?.coinsL.text!)!)!
                let coins = self?.updateCoinLabel(numCoins: numCoins)
                self?.coinsL.text = String(coins!)
                if let _ = Auth.auth().currentUser?.email {
                    let email = Auth.auth().currentUser?.email
                    self?.db.collection(K.userPreferenes).document(email!).setData([
                        "coins": coins!
                    ], merge: true) { (error) in
                        if let e = error {
                            print("There was a issue saving data to firestore \(e) ")
                        } else {
                            self?.saveToRealm()
                            print("Succesfully saved")
                        }
                    }
                }
                self?.timerButton.backgroundColor = lightPurple
                self?.timerButtonLbl.text = "Go Again"
                self?.timerButtonLbl.sizeToFit()
                self?.timerButtonLbl.center.x = self!.view.center.x
                self?.view.addSubview(self!.timerButtonLbl)
                timer.invalidate()
                strongself.timeL.text = "Great job! You found 20 coins"
                strongself.timeL.font = UIFont(name: "Menlo-Bold", size: 28)
                strongself.timeL.numberOfLines = 2
                strongself.timeL.sizeToFit()
                self?.view.addSubview(self!.timeL)
                strongself.shapeLayer.removeFromSuperlayer()
               
                
                isPlaying = false
                return
            }
            if isPlaying == false {
                print("invalidated")
                timer.invalidate()
                return
            }
            let minutes = String(strongself.counter/60)
            let seconds = String(strongself.counter%60)
            strongself.timeL.text = "\(minutes):\(seconds)"
        })
    }
    
    func saveToRealm() {
        results = uiRealm.objects(User.self)
        for result  in results {
            if result.isLoggedIn == true {
                do {
                    try uiRealm.write {
                        result.setValue(Int(coinsL.text!)!, forKey: "coins")
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    
    func updateCoinLabel(numCoins: Int) -> Int? {
        let prevNumOfCoins = numCoins
        var numOfCoins = numCoins
        
        switch counter {
        case 599...1499:
            numOfCoins += 5
        case 1500...2999:
            numOfCoins += 10
        case 3000...4499:
             numOfCoins += 20
        case 4500...5999:
             numOfCoins += 30
        case 6000...7201:
             numOfCoins += 40
        default:
            numOfCoins += 2
        }
        coinsReceived = numOfCoins - prevNumOfCoins
        return numOfCoins
    }

}




