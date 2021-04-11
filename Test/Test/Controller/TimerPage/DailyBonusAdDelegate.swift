//
//  DailyBonusAdDelegate.swift
//  Test
//
//  Created by Dante Kim on 4/10/21.
//  Copyright © 2021 Steve Ink. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AppsFlyerLib
extension DailyBonusView: GADRewardedAdDelegate, UIGestureRecognizerDelegate {
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        AppsFlyerLib.shared().logEvent("video_bonus", withValues: [AFEventParamContent: "true"])
        watchedVideo = true
    }
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        if watchedVideo {
            saveData(video: true)
            watchedVideo = false
        }
      
    }

//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//         if touch.view?.isDescendant(of: self) == true {
//            return false
//         }
//         return true
//    }
    
    func loadVideoAd() {
        rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-5091808253991399/9683704081")
        videoBox.addSubview(spinner)
        spinner.center(in: videoBox)
        spinner.startAnimating()
        rewardedAd?.load(GADRequest()) { [self] error in
              if let error = error {
                // Handle ad failed to load case.
              } else {
                spinner.removeFromSuperview()
                createVideoBox()
              }
            }
    }
}

