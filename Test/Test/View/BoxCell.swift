//
//  BoxCell.swift
//  Test
//
//  Created by Dante Kim on 4/18/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit
import TinyConstraints
import AppsFlyerLib
import GoogleMobileAds
var boxDescFontSize:CGFloat = 21
var commonItemPadding: CGFloat = 70
var youGotFontSize:CGFloat = 35
var itemImageSize: CGFloat = 150
var commonTitlePadding: CGFloat = 80
var chestFont: CGFloat = 30
var titleFont: CGFloat = 35
var commonVideo = false
var boxPadding: CGFloat {
    get {
        var size: CGFloat = 0
        if UIDevice().userInterfaceIdiom == .phone || UIDevice().userInterfaceIdiom == .pad {
            switch UIScreen.main.nativeBounds.height {
            case 1920, 2208:
                size = 5
                boxDescFontSize = 21
                itemImageSize = 100
                boxSize = 150
                youGotFontSize = 30
                commonItemPadding = 20
                commonTitlePadding = 30
                titleFont = 30
                chestFont = 20
            //("iphone 8plus ")
            case 1136:
                size = 5
                boxSize = 100
                itemImageSize = 75
                youGotFontSize = 30
                boxDescFontSize = 16
                titleFont = 30
                commonItemPadding = 20
                commonTitlePadding = 30
                chestFont = 20
                //iphone 5
            case 1334:
                //Iphone 8
                size = 5
                boxSize = 150
                itemImageSize = 100
                youGotFontSize = 30
                boxDescFontSize = 16
                titleFont = 30
                commonItemPadding = 20
                commonTitlePadding = 30
                chestFont = 20
            case 2436:
                size = -5
                titleFont = 30
                youGotFontSize = 28
                boxDescFontSize = 21
                chestFont = 25
            //print("IPHONE X, IPHONE XS, IPHONE 11 PRO")
            case 2532:
                size = -5
                titleFont = 30
                youGotFontSize = 28
                boxDescFontSize = 21
                chestFont = 25
                //iphone 12, 12 pro
            case 2340:
                size = 5
                boxDescFontSize = 21
                itemImageSize = 100
                boxSize = 150
                youGotFontSize = 30
                commonItemPadding = 20
                commonTitlePadding = 30
                titleFont = 30
                chestFont = 20
                //iphone 12 mini
            case 2778:
                size = -30
                boxDescFontSize = 23
                commonItemPadding = 120
                //iphone 12 pro max
            case 2688:
                size = -30
                boxDescFontSize = 23
                commonItemPadding = 120
            //print("IPHONE XS MAX, IPHONE 11 PRO MAX")
            case 1792:
                size = -30
                boxDescFontSize = 23
                commonItemPadding = 100
            //print("IPHONE XR, IPHONE 11")
            default:
                size = -30
                titleFont = 60
                titlePadding = 9
                itemImageSize = 200
                boxDescFontSize = 30
                chestFont = 45
            }
        }
        return size
    }
}

var boxSize: CGFloat = 200

class BoxCell: UICollectionViewCell, GADRewardedAdDelegate {
    var mysterySpinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    //MARK: - properties
    var data: MysteryBox? {
        didSet {
            guard let data = data else { return }
            boxView.image = data.image
            if !isIpod {
                boxView.widthAnchor.constraint(greaterThanOrEqualToConstant: boxSize).isActive = true
                boxView.heightAnchor
                    .constraint(greaterThanOrEqualToConstant: boxSize).isActive = true
            }  else {
                boxView.width(boxSize)
                boxView.height(boxSize)
            }
           

        }
    }
    
    let boxView : UIImageView = {
           let iv = UIImageView()
           iv.translatesAutoresizingMaskIntoConstraints = false
           iv.contentMode = .scaleAspectFit
           iv.clipsToBounds = true

           return iv
       }()
    let desc : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        label.clipsToBounds = true
        label.font = UIFont(name: "Menlo", size: boxDescFontSize)
        return label
    }()
    let coinImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "coins")
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
         label.textColor = .white
        label.textAlignment = .center
         label.translatesAutoresizingMaskIntoConstraints = false
         label.numberOfLines = 0
         label.textColor = .black
         label.clipsToBounds = true
         label.font = UIFont(name: "Menlo-Bold", size: titleFont)
         return label

    }()
    let dollarIconView: UIImageView = {
        let iv = UIImageView ()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "dollarIcon")
        return iv
    }()
    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "Menlo", size: UIDevice().userInterfaceIdiom == .pad ? 40 : 25)
        return label
    }()
    
    let buyButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel!.font = UIFont(name: "Menlo-Bold", size: youGotFontSize)
        button.setTitle("BUY", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel!.textColor = .white
        button.sizeToFit() 
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 10, height: 10)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.5
        return button
    }()
    let videoButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = true
        button.backgroundColor = darkPurple
        button.sizeToFit()
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 10, height: 10)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.5
        return button
    }()
    var rootController: MysteryViewController?
    var finishedVideo = false
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        return formatter
    }()
    var lastVideo: Date?  = Date()
    override init(frame:CGRect) {
        super.init(frame: frame)
        
        getRealmData()
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(boxView)
        contentView.addSubview(desc)
        contentView.addSubview(buyButton)
        contentView.backgroundColor = lightLavender
        contentView.layer.cornerRadius = 25
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 10)
        contentView.layer.shadowRadius = 2
        contentView.layer.shadowOpacity = 0.5
        
        NotificationCenter.default.addObserver(self, selector: #selector(createWatchButton), name: Notification.Name("createWatchButton"), object: nil)
        
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 20).isActive = false
        
        boxView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        boxView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        boxView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true

        
        desc.topAnchor.constraint(equalTo: boxView.bottomAnchor, constant: 20).isActive = true
        desc.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: onUpgrade ? 45:60).isActive = true
        desc.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: onUpgrade ? -45:-60
        ).isActive = true
        
    
        
        buyButton.topAnchor.constraint(equalTo: desc.bottomAnchor, constant: 0).isActive = false
        buyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60).isActive = true
        buyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60).isActive = true
        buyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30).isActive = true
        if onUpgrade {
            buyButton.addSubview(dollarIconView)
            dollarIconView.leadingAnchor.constraint(equalTo: buyButton.leadingAnchor, constant: isIpod ?  5 : 30).isActive = true
            dollarIconView.centerY(to: buyButton)
            dollarIconView.height(max: buyButton.frame.height * 1.50)
            dollarIconView.width(max: buyButton.frame.width * 0.80)
        }
        
        
        if !onUpgrade {
            contentView.addSubview(priceLabel)
            priceLabel.text = "Price: 70"
            priceLabel.bottomAnchor.constraint(equalTo: buyButton.topAnchor, constant: -10).isActive = true
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIDevice().userInterfaceIdiom == .pad ? 200:70).isActive = true
            
            contentView.addSubview(coinImageView)
            coinImageView.width(UIDevice().userInterfaceIdiom == .pad ? 40:25)
            coinImageView.height(UIDevice().userInterfaceIdiom == .pad ? 50:30)
              coinImageView.bottomAnchor.constraint(equalTo: buyButton.topAnchor, constant: -10).isActive = true
            coinImageView.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant:10).isActive = true
        }
    }
    func getRealmData() {
        let results = uiRealm.objects(User.self)
        for result  in results {
            if result.isLoggedIn == true {
                lastVideo = dateFormatter.date(from: result.mysteryVideo ?? "") ?? Date()
            }
        }
    }
    
    func createVideoBox() {
        self.addSubview(videoButton)
        videoButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60).isActive = true
        videoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60).isActive = true
        videoButton.bottomToTop(of: priceLabel, offset: -20)
        videoButton.height(50)
        
        print("phoneix", (Date() - lastVideo!).stringFromTimeInterval())
        if (Date() - lastVideo!) >= 0 {
           createSpinnerOrWatch()
        } else { // show cooldown
            createCooldown()
        }
    }
    func createSpinnerOrWatch() {
        if FocusByte.rewardedAd.isReady == false {
            videoButton.addSubview(mysterySpinner)
            mysterySpinner.center(in: videoButton)
            mysterySpinner.startAnimating()
        }  else {
            createWatchButton()
        }
    }
    func createCooldown() {
        var interval = (lastVideo! - Date())
        videoButton.setTitle(interval.stringFromTimeInterval(), for: .normal)
        DispatchQueue.main.async {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
                interval -= 1
                videoButton.setTitle(interval.stringFromTimeInterval(), for: .normal)
                if interval <= 0 {
                    timer.invalidate()
                    finishedVideo = false
                    videoButton.setTitle("", for: .normal)
                    createSpinnerOrWatch()
                }
            }
        }
        videoButton.setTitleColor(.white, for: .normal)
        videoButton.titleLabel?.textAlignment = .center
        videoButton.titleLabel!.textColor = .white
        videoButton.titleLabel!.font = UIFont(name: "Menlo-Bold", size: youGotFontSize - 10)
    }
    @objc func createWatchButton() {
        if self.subviews.contains(mysterySpinner) {
            mysterySpinner.removeFromSuperview()
        }
        NotificationCenter.default.removeObserver(self, name:  Notification.Name("createWatchButton"), object: nil)
        videoButton.setImage(UIImage(named: "video-button")?.resized(to: CGSize(width: 45, height: 35)), for: .normal)
        videoButton.titleLabel!.font = UIFont(name: "Menlo-Bold", size: youGotFontSize - 10)
        videoButton.addTarget(self, action: #selector(showAd), for: .touchUpInside)
        videoButton.setTitle("WATCH", for: .normal)
        videoButton.setTitleColor(.white, for: .normal)
        videoButton.titleLabel?.textAlignment = .center
        videoButton.titleLabel!.textColor = .white
        videoButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        videoButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        videoButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    @objc func showAd() {
        if FocusByte.rewardedAd.isReady == true {
            FocusByte.rewardedAd.present(fromRootViewController: rootController!, delegate:self)
         }
    }
    
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        finishedVideo = true
    }
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        if finishedVideo {
            name = "Common Box"
            commonVideo = true
            let controller = GifController()
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .crossDissolve
            rootController!.present(controller, animated: true, completion: nil)
            finishedVideo = false
            saveToRealm()
        }
        
        FocusByte.rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-5091808253991399/3095897395")
        FocusByte.rewardedAd.load(GADRequest()) { error in
              if let _ = error {
              } else {
              }
        }
    }
        
        func saveToRealm() {
            let threeHours = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
            let results = uiRealm.objects(User.self)
            for result  in results {
                if result.isLoggedIn == true {
                    try! uiRealm.write {
                        result.mysteryVideo = dateFormatter.string(from: threeHours)
                    }
                }
            }
        }
    
    func removeVideoButton() {
        if self.subviews.contains(videoButton) {
            videoButton.removeFromSuperview()
        }

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
