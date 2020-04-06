//
//  Constants.swift
//  Test
//
//  Created by Dante Kim on 3/29/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import Foundation
import UIKit

let brightPurple = hexStringToUIColor(hex: "#C7B6F5")
let color1 = hexStringToUIColor(hex: "#5E558A")
let lightLavender = hexStringToUIColor(hex: "#ABA9FF")
let superLightLavender = hexStringToUIColor(hex: "#E3DAFA")
let darkPurple = hexStringToUIColor(hex:"#5E558A")

struct K {
    static let userPreferenes = "userPreferences"
}



func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}




extension UIView {
    func asImage(viewLayer: CALayer, viewBounds: CGRect) -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: viewBounds)
            return renderer.image { rendererContext in
                viewLayer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(viewBounds.size)
            viewLayer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}
