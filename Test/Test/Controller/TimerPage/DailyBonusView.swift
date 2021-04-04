//
//  DailyBonusView.swift
//  Test
//
//  Created by Dante Kim on 4/3/21.
//  Copyright © 2021 Steve Ink. All rights reserved.
//

import UIKit
import TinyConstraints

class DailyBonusView: UIView {
    //MARK: - instance variables
    var mainView = UIView()
    var navigationBar = UINavigationBar()
    var isPad = false

    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        overrideUserInterfaceStyle = .light
        if UIDevice().userInterfaceIdiom == .pad {
            isPad = true
        }
    }
    
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
    
    //MARK: - helper functions
    @objc func tappedBox() {
        print("tappedBox")
    }
    @objc func tappedOutside() {
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
    
    func setUpView() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedOutside)))
        self.addSubview(mainView)
        mainView.width(self.frame.width * (isIpod ? 0.90 : 0.80))
        mainView.height(self.frame.height * (UIDevice.current.hasNotch ? 0.65 : (isIpod ? 0.75 : 0.70) ))
        mainView.centerX(to: self)
        mainView.topToSuperview(offset: -self.frame.height * (UIDevice.current.hasNotch ? 0.25 : isIpod ? 0.40 :0.30))

        mainView.backgroundColor = darkPurple
        mainView.layer.borderWidth = 3
        mainView.layer.borderColor = superLightLavender.cgColor
        mainView.layer.cornerRadius = 25
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 0.5
        mainView.layer.shadowOffset = .zero
        mainView.layer.shadowRadius = 5
        let tappedMain = UITapGestureRecognizer(target: self, action: #selector(tappedBox))
        tappedMain.cancelsTouchesInView = false
        mainView.addGestureRecognizer(tappedMain)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { [self] in
            self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.mainView.transform = CGAffineTransform(translationX: 0, y: (isPad ? 625 : 325))
                }) { (_) in
        }
        
        let dailyLabel = createLabel(text: "DAILY BONUS")
        let streakLabel = createLabel(text: "STREAKS")
        
        mainView.addSubview(dailyLabel)
        mainView.addSubview(streakLabel)
        
        dailyLabel.centerX(to: self)
        dailyLabel.top(to: mainView, offset: 20)
        
        let dailyBox = createSmallBox()
        let videoBox = createSmallBox()
        let streakBox = createSmallBox()
        
        mainView.addSubview(dailyBox)
        dailyBox.topToBottom(of: dailyLabel, offset: 20)
        dailyBox.centerX(to: mainView)
        dailyBox.width(self.frame.width * 0.65)
        dailyBox.height(self.frame.height * 0.065)
        dailyBox.layer.cornerRadius = 15
        
        mainView.addSubview(videoBox)
        videoBox.topToBottom(of: dailyBox, offset: 20)
        videoBox.centerX(to: mainView)
        videoBox.width(self.frame.width * 0.65)
        videoBox.height(self.frame.height * 0.065)
        videoBox.layer.cornerRadius = 15
        
        mainView.addSubview(streakLabel)
        streakLabel.centerX(to: self)
        streakLabel.topToBottom(of: videoBox, offset: 40)
        
        mainView.addSubview(streakBox)
        streakBox.topToBottom(of: streakLabel, offset: 10)
        streakBox.centerX(to: mainView)
        streakBox.width(self.frame.width * (isIpod ? 0.75 : 0.65))
        streakBox.height(self.frame.height * 0.65 * 0.40)
        streakBox.layer.cornerRadius = 15
        
        let flameView = UIImageView(image: UIImage(named: "flame")?.resized(to: CGSize(width: self.frame.width * 0.17, height: self.frame.height * 0.08)))
        streakBox.addSubview(flameView)
        flameView.leading(to: streakBox, offset: 20)
        flameView.top(to: streakBox, offset: self.frame.height * 0.65 * 0.40 * 0.20)
        
        let flameLabel = createLabel(text: "14\nDays")
        streakBox.addSubview(flameLabel)
        flameLabel.topToBottom(of: flameView, offset: 5)
        flameLabel.numberOfLines = 2
        flameLabel.textAlignment = .center
        flameLabel.font = UIFont(name: "Menlo", size: 22)
        flameLabel.leading(to: streakBox, offset: isPad ? 75 : 25)
        
        //MARK: - Streak Boxes
        let sevenLabel = createLabel(text: "7 Days")
        sevenLabel.font = UIFont(name: "Menlo", size: 20)
        streakBox.addSubview(sevenLabel)
        sevenLabel.textAlignment = .center
        sevenLabel.top(to: streakBox, offset: self.frame.height * 0.65 * 0.40 * 0.125)
        sevenLabel.leadingToTrailing(of: flameView, offset: self.frame.width * 0.65 * 0.15)
        
        let sevenDayContainer = UIView()
        streakBox.addSubview(sevenDayContainer)
        sevenDayContainer.trailing(to: streakBox, offset: -25)
        sevenDayContainer.topToBottom(of: sevenLabel, offset: 5)
        sevenDayContainer.leadingToTrailing(of: flameView, offset: 10)
        sevenDayContainer.height(self.frame.height * 0.045)
        
        let sevenDay = UIProgressView()
        sevenDay.progress = 0
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

        sevenDay.addSubview(coinView)
        sevenDay.progress = 0.5
        coinView.centerY(to: sevenDay)
        coinView.leading(to: sevenDay, offset: 10)
        
        let sevenDayCoin = UILabel()
        sevenDayCoin.font = UIFont(name: "Menlo-Bold", size: 18)
        sevenDay.addSubview(sevenDayCoin)
        sevenDayCoin.text = "10"
        sevenDayCoin.leadingToTrailing(of: coinView, offset: 5)
        sevenDayCoin.centerY(to: sevenDay)
        
        sevenDay.addSubview(expView)
        expView.centerY(to: sevenDay)
        expView.leadingToTrailing(of: sevenDayCoin, offset: 5)
        
        let sevenDayExp = UILabel()
        sevenDayExp.font = UIFont(name: "Menlo-Bold", size: 18)
        sevenDay.addSubview(sevenDayExp)
        sevenDayExp.text = "3"
        sevenDayExp.leadingToTrailing(of: expView, offset: 5)
        sevenDayExp.centerY(to: sevenDay)
        
        let thirtyLabel = createLabel(text: "30 Days")
        thirtyLabel.font = UIFont(name: "Menlo", size: 20)
        streakBox.addSubview(thirtyLabel)
        thirtyLabel.textAlignment = .center
        thirtyLabel.topToBottom(of: sevenDay, offset: 15)
        thirtyLabel.leadingToTrailing(of: flameView, offset: self.frame.width * 0.65 * 0.15)
        
        let thirtyDayContainer = UIView()
        streakBox.addSubview(thirtyDayContainer)
        thirtyDayContainer.trailing(to: streakBox, offset: -15)
        thirtyDayContainer.topToBottom(of: thirtyLabel, offset: 5)
        thirtyDayContainer.leadingToTrailing(of: flameView, offset: 10)
        thirtyDayContainer.height(self.frame.height * 0.045)
        
        let thirtyDay = UIProgressView()
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
}
