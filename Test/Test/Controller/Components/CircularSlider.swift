
import Foundation
import UIKit
import HGCircularSlider

extension TimerController {
    func createIpodSlider() {
        circularSlider = CircularSlider(frame: CGRect(x: view.center.x - 125, y: view.center.y - 150, width: 250, height: 250))
        circularSlider.layer.cornerRadius = 125
        circularSlider.lineWidth = 10
        circularSlider.backtrackLineWidth = 15
        circularSlider.thumbLineWidth = 5
        circularSlider.thumbRadius = 20
        configureSlider()
    }
    
    func createCircularSlider() {
        circularSlider = CircularSlider(frame: CGRect(x: view.center.x - 150, y: view.center.y - 200, width: 300, height: 300))
        circularSlider.layer.cornerRadius = 150
        circularSlider.lineWidth = 20
        circularSlider.backtrackLineWidth = 20
        circularSlider.thumbLineWidth = 5.00
        circularSlider.thumbRadius = 25.0
        configureSlider()
    }
    
    func configureSlider() {
        circularSlider.clipsToBounds = true
        circularSlider.backgroundColor = superLightLavender
        circularSlider.diskColor = superLightLavender
        circularSlider.diskFillColor = .clear
        circularSlider.endThumbTintColor = brightPurple
        circularSlider.tintColor = brightPurple
        circularSlider.numberOfRounds = 1
        circularSlider.endThumbStrokeHighlightedColor = brightPurple
        circularSlider.endThumbStrokeColor = brightPurple
        circularSlider.trackColor = darkPurple
        circularSlider.trackFillColor = brightPurple
        circularSlider.diskColor = .clear
        circularSlider.minimumValue = 0
        circularSlider.maximumValue = 120
        circularSlider.endPointValue = 25
        circularSlider.addTarget(self, action: #selector(updateTexts), for: .valueChanged)
        view.insertSubview(circularSlider, belowSubview: chestImageView!)
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
