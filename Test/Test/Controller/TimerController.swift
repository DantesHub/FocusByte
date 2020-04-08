//
//  ViewController.swift
//  Test
//
//  Created by Laima Cernius-Ink on 3/24/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//
import UIKit
import HGCircularSlider
var isPlaying = false

class ViewController: UIViewController {
    let shapeLayer = CAShapeLayer()
    var time = 600
    let timeL = UILabel()
    var circularSlider = CircularSlider()
    var motivationalQuote = ""
    let coinsL = AnimatedLabel()
    var chest: UIImageView?
    var coinsImg: UIImageView?
    var timerButton = UIView()
    let timerButtonLbl = UILabel()
    
    var timer = Timer()
    var durationString = ""
    var counter = 0
    var currentValueLabel: UILabel!

    @IBAction func didTapMenu(_ sender: Any) {
        guard let menuViewController = storyboard?.instantiateViewController(identifier: "MenuController") else { return }
        present(menuViewController, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        createCircularSlider()
        timeL.lineBreakMode = .byClipping 
        
      
        
        coinsL.frame.size.width = 75
        coinsL.frame.size.height = 75
        coinsL.textColor = .white
        coinsL.center.x = view.center.x + 180
        coinsL.font = UIFont(name: "Menlo-Bold", size: 20)
        coinsL.center.y = view.center.y - 370
        view.addSubview(coinsL)
        
        timeL.font = .boldSystemFont(ofSize: 20)
        timeL.font = UIFont(name: "Menlo-Bold", size: 65)
        timeL.textAlignment = .center
        
        timeL.textColor = .white
       timeL.frame.size.width = 240
        timeL.frame.size.height = 75
        timeL.center.x = view.center.x
        timeL.center.y = view.center.y + 200
        view.addSubview(timeL)
        
        
        timerButton.frame.size.width = 200
        timerButton.frame.size.height = 75
        timerButton.center.x = view.center.x
        timerButton.center.y = timeL.center.y + 125
        timerButton.backgroundColor = darkPurple
        timerButton.layer.cornerRadius = 25
        
        view.addSubview(timerButton)
        
        if !isPlaying {
          timerButtonLbl.text = "Start"
        } else {
          timerButtonLbl.text = "Give up "
        }
        let shadowView = UIView(frame: CGRect(x: view.center.x - 100 , y: timeL.center.y + 85 , width: 200, height: 75))
        shadowView.backgroundColor = .clear
        shadowView.layer.cornerRadius = 25
        shadowView.dropShadow(superview: timerButton)
        view.addSubview(shadowView)
        view.insertSubview(timerButton, aboveSubview: shadowView)
        
        timerButtonLbl.textColor = .white
        timerButtonLbl.font = UIFont(name: "Menlo-Bold", size: 20)
        timerButtonLbl.sizeToFit()
        timerButtonLbl.center.x = timerButton.center.x
        timerButtonLbl.center.y = timerButton.center.y
        view.addSubview(timerButtonLbl)
        
        let image: UIImage = UIImage(named: "chest")!
        chest = UIImageView(image: image)
        chest?.sizeToFit()
        
        chest?.center.x = view.center.x + 15
        chest?.center.y = view.center.y - 60
        view.addSubview(chest!)
        
        let image2: UIImage = UIImage(named: "coins")!
        coinsImg = UIImageView(image: image2)
        coinsImg!.frame.size.width = 25
        coinsImg!.frame.size.height = 30
        
        coinsImg?.center.x =  view.center.x + 120
        coinsImg?.center.y = view.center.y - 370
        view.addSubview(coinsImg!)
    
     
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        timerButton.addGestureRecognizer(tap)
    }
    
    func createCircularSlider() {
    
        circularSlider = CircularSlider(frame: CGRect(x: view.center.x - 175, y: view.center.y - 225, width: 350, height: 350))
        circularSlider.layer.cornerRadius = 180
        circularSlider.clipsToBounds = true
        circularSlider.backgroundColor = superLightLavender
              circularSlider.diskColor = superLightLavender
              circularSlider.diskFillColor = .clear
              circularSlider.endThumbTintColor = brightPurple
              circularSlider.tintColor = brightPurple
              circularSlider.lineWidth = 20
        circularSlider.numberOfRounds = 1
                circularSlider.backtrackLineWidth = 20
              circularSlider.endThumbStrokeHighlightedColor = brightPurple
              circularSlider.endThumbStrokeColor = brightPurple
              circularSlider.trackColor = darkPurple
              circularSlider.trackFillColor = brightPurple
             circularSlider.diskColor = .clear
              circularSlider.thumbLineWidth = 5.0
                circularSlider.minimumValue = 10.0
                circularSlider.maximumValue = 120.0
              circularSlider.thumbRadius = 20.0
               
                circularSlider.endPointValue = 10
                updateTexts()
                circularSlider.addTarget(self, action: #selector(updateTexts), for: .valueChanged)
              view.addSubview(circularSlider)
    }
    
    @objc func updateTexts() {
        let value = circularSlider.endPointValue
        if value >= 100.0 {
            timeL.text = String(format: "%.0f" + ":00", value)
            
        } else {
            timeL.text = String(format: "%.0f" + ":00", value)
        }
        
    }
    
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let counter = Int(time) % 60
        return String(format:"%02i:%02i", minutes, counter)
    }
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(100, forKey: "coins")
        let coins =  defaults.integer(forKey: "coins")
        coinsL.countFromZero(to: Float(coins), duration: .brisk)
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if isPlaying {
            isPlaying = false
        }
        if !isPlaying{
            isPlaying = true
            var center = view.center
                 center.y = view.center.y - 50
                 // create my track layer
                 let trackLayer = CAShapeLayer()
                 let circularPath = UIBezierPath(arcCenter: center, radius: 150, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
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
                counter = (Int(durationString)! * 60)
                    print("duration String" + durationString)
                    basicAnimation.duration = CFTimeInterval((Int(durationString) ?? 10) * 60)
                    print(CFTimeInterval((Int(durationString) ?? 10) * 60))
                    self.shapeLayer.add(basicAnimation, forKey: "urSoBasic")
            countDownTimer()
            circularSlider.isHidden = true
        }
        
    }
    func countDownTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self](timer) in
            guard let strongself = self else { return }
            strongself.counter -= 1
            if strongself.counter == 0 {
                strongself.timeL.text = "Great job!"
                timer.invalidate()
            }
            let minutes = String(strongself.counter/60)
            let seconds = String(strongself.counter%60)
            strongself.timeL.text = "\(minutes):\(seconds)"
        })
    }

}

