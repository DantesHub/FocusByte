//
//  Constants.swift
//  Test
//
//  Created by Dante Kim on 3/29/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import Foundation
import UIKit
let largeConfiguration = UIImage.SymbolConfiguration(weight: .bold)
let menuImage = UIImage(systemName: "line.horizontal.3", withConfiguration: largeConfiguration)
let resizedMenuImage = menuImage?.resized(to: CGSize(width: 35, height: 25)).withTintColor(.white, renderingMode:.alwaysOriginal)
let brightPurple = hexStringToUIColor(hex: "#5351C0")
let lightLavender = hexStringToUIColor(hex: "#ABA9FF")
let backgroundColor = hexStringToUIColor(hex: "#C7B6F5")
let green = hexStringToUIColor(hex: "#196300")
let lightPurple = hexStringToUIColor(hex: "#B99AFF")
let superLightLavender = hexStringToUIColor(hex: "#E3DAFA")
let darkRed = hexStringToUIColor(hex: "#811301")
let darkPurple = hexStringToUIColor(hex:"#5E558A")

struct K {
    static let userPreferenes = "userPreferences"
    
    struct FStore {
        static let collectionName = "userPreferences"
    }
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

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

extension UIViewController {
  func presentInFullScreen(_ viewController: UIViewController,
                           animated: Bool,
                           completion: (() -> Void)? = nil) {
    viewController.modalPresentationStyle = .fullScreen
    present(viewController, animated: animated, completion: completion)
  }

 func configureNavigationBar() {
      navigationController?.navigationBar.barTintColor = backgroundColor
      navigationController?.navigationBar.barStyle = .black
      navigationItem.title = "Home"
      self.navigationController?.navigationBar.titleTextAttributes =
          [NSAttributedString.Key.foregroundColor: UIColor.white,
           NSAttributedString.Key.font: UIFont(name: "Menlo-Bold", size: 30)!]
      navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
      navigationController?.navigationBar.shadowImage = UIImage()
      
  }
}
