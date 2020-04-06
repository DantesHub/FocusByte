//
//  ViewController.swift
//  Test
//
//  Created by Laima Cernius-Ink on 3/24/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//
import UIKit

class ViewController: UIViewController {
    
    var playing = false
    let shapeLayer = CAShapeLayer()
    var time = 600
    let timeL = UILabel()
    let coinsL = AnimatedLabel()
    var chest: UIImageView?
    var coinsImg: UIImageView?
    var timerButton = UIView()
    let timerButtonLbl = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        UINavigationBar.appearance().barTintColor = lightLavender
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.font: UIFont(name: "Menlo-Bold", size: 24)!
        ]
        self.navigationItem.title = "Home";
        UINavigationBar.appearance().titleTextAttributes = attrs
        let color2 = hexStringToUIColor(hex: "#5351C0")
        
        coinsL.frame.size.width = 75
        coinsL.frame.size.height = 75
        coinsL.center.x = view.center.x + 160
        coinsL.center.y = view.center.y - 220
        view.addSubview(coinsL)
        
        
        
        
        
        timeL.font = .boldSystemFont(ofSize: 20)
        timeL.text = " 10:00"
        timeL.sizeToFit()
        timeL.center.x = view.center.x
        timeL.center.y = view.center.y + 150
        view.addSubview(timeL)
        
        
        timerButton.frame.size.width = 330
        timerButton.frame.size.height = 75
        timerButton.center.x = view.center.x
        timerButton.center.y = timeL.center.y + 175
        timerButton.backgroundColor = darkPurple
        timerButton.layer.cornerRadius = 20
        view.addSubview(timerButton)
        
        timerButtonLbl.text = "Start"
        timerButtonLbl.textColor = .white
        timerButtonLbl.font = .boldSystemFont(ofSize: 20)
        timerButtonLbl.sizeToFit()
        timerButtonLbl.center.x = timerButton.center.x
        timerButtonLbl.center.y = timerButton.center.y
        
        view.addSubview(timerButtonLbl)
        
        var image: UIImage = UIImage(named: "chest")!
        chest = UIImageView(image: image)
        chest!.frame.size.width = 200
        chest!.frame.size.height = 150
        //newsI!.layer.cornerRadius = 20
        
        chest?.center.x = view.center.x + 10
        chest?.center.y = view.center.y - 50
        view.addSubview(chest!)
        
        var image2: UIImage = UIImage(named: "coins")!
        coinsImg = UIImageView(image: image2)
        coinsImg!.frame.size.width = 25
        coinsImg!.frame.size.height = 25
        //newsI!.layer.cornerRadius = 20
        
        coinsImg?.center.x =  view.center.x + 100
        coinsImg?.center.y = view.center.y - 270
        view.addSubview(coinsImg!)
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.playing == true {
                self.time -= 1
            }
            self.timeL.text = "\(self.timeString(time: TimeInterval(self.time)))"
            let defaults = UserDefaults.standard
            let status = defaults.string(forKey: "status")
            if  status == "exited"{
                self.time = 600
            }
        }
        
        
        var center = view.center
        center.y = view.center.y - 50
        // create my track layer
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: center, radius: 150, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = darkPurple.cgColor
        trackLayer.lineWidth = 15
      
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(trackLayer)
        
        //        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = color2.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
        
        
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 600
        basicAnimation.fillMode = CAMediaTimingFillMode.backwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
        let defaults = UserDefaults.standard
        defaults.set("playing", forKey: "status")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        timerButton.addGestureRecognizer(tap)
        
        
        let timer2 = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            let defaults = UserDefaults.standard
            let status = defaults.string(forKey: "status")
            if  status == "exited"{
                basicAnimation.toValue = 0
                basicAnimation.duration = 0
                self.shapeLayer.add(basicAnimation, forKey: "urSoBasic")
                basicAnimation.toValue = 1
                basicAnimation.duration = 600
                self.shapeLayer.add(basicAnimation, forKey: "urSoBasic")
                let defaults = UserDefaults.standard
                defaults.set("playing", forKey: "status")
            }
        }
    }
    
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(100, forKey: "coins")
        var coins =  defaults.integer(forKey: "coins")
        coinsL.countFromZero(to: Float(coins), duration: .brisk)
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if playing{
            playing = false
        }
        if !playing{
            playing = true
        }
    }
}
