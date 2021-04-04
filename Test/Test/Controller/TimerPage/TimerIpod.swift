//
//  TimerIpod.swift
//  Test
//
//  Created by Dante Kim on 2/5/21.
//  Copyright © 2021 Steve Ink. All rights reserved.
//

import UIKit

extension TimerController {
    func createIpodLayer() {
        var center = view.center
        center.y = view.center.y - 25
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = lightLavender.cgColor
        trackLayer.lineWidth = 10
        
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
    final func createIpodStartUI() {
        configureIpodUI()
    }
    
    func configureIpodUI() {
        coinsImg = UIImageView(image: UIImage(named: "coins")!)
        coinsImg!.frame.size.width = 25
        coinsImg!.frame.size.height = 30
        coinsImg?.center.x =  view.center.x + 60
        coinsImg?.center.y = 20
        
        coinsL.frame.size.width = 100
        coinsL.frame.size.height = 25
        coinsL.layer.cornerRadius = 25
        coinsL.textColor = .white
        coinsL.backgroundColor = darkPurple
        coinsL.center.x =  view.center.x + 100
        coinsL.center.y = 20
        coinsL.textAlignment = .center
        coinsL.font = UIFont(name: "Menlo-Bold", size: 20)
        
        plusIcon.frame.size.width = 30
        plusIcon.frame.size.height = 30
        plusIcon.center.x =  view.center.x + 145
        plusIcon.center.y = 20
        let plusTapped = UITapGestureRecognizer(target: self, action: #selector(tappedPlus))
        plusIcon.addGestureRecognizer(plusTapped)
        plusIcon.isUserInteractionEnabled = true
        
        timeL.font = .boldSystemFont(ofSize: 20)
        timeL.font = UIFont(name: "Menlo-Bold", size: 45)
        timeL.textAlignment = .center
        timeL.textColor = .white
        timeL.frame.size.width = 240
        timeL.frame.size.height = 75
        timeL.center.x = view.center.x
        timeL.center.y = view.center.y + 130
        timeL.lineBreakMode = .byClipping
        view.addSubview(timeL)
        view.addSubview(timerButton)
        createIpodSlider()
        createTimerButton()
        createTimerButtonLbl()
        let breakTapped = UITapGestureRecognizer(target: self, action: #selector(self.breakPressed))
        self.breakButton.addGestureRecognizer(breakTapped)
        
        view.insertSubview(chestImageView!, at: 10)
        chestImageView?.image =  UIImage(named: chest)!
        chestImageView?.centerXToSuperview()
        chestImageView?.centerYToSuperview(offset: -25)
        chestImageView?.width(125)
        chestImageView?.height(125)
        createQuoteLabel()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        timerButton.addGestureRecognizer(tap)
        
        createXImageView()
        createTagImageView()
        
        view.backgroundColor = backgroundColor
        createBarItem()
        navigationController?.navigationBar.addSubview(coinsL)
        navigationController?.navigationBar.addSubview(coinsImg!)
         navigationController?.navigationBar.addSubview(plusIcon)
    }
}
