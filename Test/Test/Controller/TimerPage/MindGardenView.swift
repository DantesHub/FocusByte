//
//  MindGardenView.swift
//  Test
//
//  Created by Dante Kim on 11/6/21.
//  Copyright © 2021 Dante Kim. All rights reserved.
//

import UIKit

class MindGardenView: UIView {
    var mainView = UIView()
    var navigationBar = UINavigationBar()
    var isPad = false
    var rootController: TimerController?

    override init(frame: CGRect) {
        super.init(frame: frame)
        overrideUserInterfaceStyle = .light

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - helper functions
    @objc func tappedOutside() {
        UserDefaults.standard.setValue(true, forKey: "mindGarden")
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { [self] in
            mainView.transform = CGAffineTransform(translationX: 0, y: (isPad ? 2000 : 1200))

        }) { [self] (_) in
            navigationBar.alpha = 1
            navigationBar.isUserInteractionEnabled = true
            removeFromSuperview()}
    }
    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.text = text
        label.font = UIFont(name: "Menlo-Bold", size: 22)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }

    func setUpView() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedOutside)))
        self.addSubview(mainView)

        mainView.width(self.frame.width * (isIpod ? 0.90 : 0.80))
        mainView.height(self.frame.height * (UIDevice.current.hasNotch ? 0.65 : (isIpod ? 0.75 : 0.70) ))
        mainView.centerX(to: self)
        mainView.topToSuperview(offset: -self.frame.height * (UIDevice.current.hasNotch ? 0.25 : isIpod ? 0.40 :0.30))

        let mainTap = UITapGestureRecognizer(target: self, action: nil)
        mainView.addGestureRecognizer(mainTap)

        mainView.backgroundColor = darkPurple
        mainView.layer.borderWidth = 3
        mainView.layer.borderColor = superLightLavender.cgColor
        mainView.layer.cornerRadius = 25
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 0.5
        mainView.layer.shadowOffset = .zero
        mainView.layer.shadowRadius = 5
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { [self] in
            self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.mainView.transform = CGAffineTransform(translationX: 0, y: (isPad ? 450 : UIDevice.current.hasNotch ? 350 : 300))
                }) { (_) in
        }
        let dailyLabel = createLabel(text: "Our New \nMeditation App!")

        mainView.addSubview(dailyLabel)

        dailyLabel.centerX(to: self)
        dailyLabel.top(to: mainView, offset: 20)

        let mgView = UIImageView(image: UIImage(named: "mindGarden")?
                                    .resized(to: CGSize(width: self.frame.width * 0.7, height: self.frame.height * 0.5)))
        mainView.addSubview(mgView)
        mgView.centerYToSuperview()
        mgView.centerX(to: mainView, offset: 10)

        let btn = UIButton()
        mainView.addSubview(btn)
        btn.titleLabel?.text = "Download Now!"
        btn.titleLabel?.font =  UIFont(name: "Menlo-Bold", size: 20)
        btn.titleLabel?.textColor = .white
        btn.topToBottom(of: mgView, offset: 0)
        btn.bottom(to: mainView, offset: -20)
        btn.setTitle("Download Now!", for: .normal)
        btn.leading(to: mainView, offset: 30)
        btn.trailing(to: mainView, offset: -30)
        btn.layer.cornerRadius = 14
        btn.layer.borderWidth = 5
        btn.layer.borderColor = superLightLavender.cgColor
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.8
        btn.layer.shadowOffset = .zero
        btn.layer.shadowRadius = 10
        btn.backgroundColor = darkPurple
        btn.addTarget(self, action: #selector(tappedDownload), for: .touchUpInside)
    }

    @objc func tappedDownload() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        UserDefaults.standard.setValue(true, forKey: "mindGarden")
        let url = URL(string: "https://apps.apple.com/us/app/mindgarden-smiling-mind/id1588582890")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
