//
//  CircularSlider.swift
//  Test
//
//  Created by Dante Kim on 4/10/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import Foundation
import UIKit
import HGCircularSlider

extension TimerController {
    func createCircularSlider() {
        circularSlider = CircularSlider(frame: CGRect(x: view.center.x - 150, y: view.center.y - 200, width: 300, height: 300))
        circularSlider.layer.cornerRadius = 150
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
        circularSlider.minimumValue = 0
        circularSlider.maximumValue = 120.0
        circularSlider.thumbRadius = 20.0
        circularSlider.endPointValue = 10
        circularSlider.addTarget(self, action: #selector(updateTexts), for: .valueChanged)
        view.insertSubview(circularSlider, belowSubview: chest!)
        updateTexts()
    }
    
    
    @objc func updateTexts() {
        let value = circularSlider.endPointValue
        if value >= 100.0 {
            timeL.text = String(format: "%.0f" + ":00", value)
            
        } else {
            timeL.text = String(format: "%.0f" + ":00", value)
        }
        
    }
}
