//
//  Extensions.swift
//  Test
//
//  Created by Dante Kim on 4/18/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import Foundation
import UIKit

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

    func configureNavigationBar(color: UIColor, isTrans: Bool) {
            navigationController?.navigationBar.barTintColor = color
        navigationController?.navigationBar.barStyle = .black
      self.navigationController?.navigationBar.titleTextAttributes =
          [NSAttributedString.Key.foregroundColor: UIColor.white,
           NSAttributedString.Key.font: UIFont(name: "Menlo-Bold", size: 30)!]
      UINavigationBar.appearance().shadowImage = UIImage()
      UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.isTranslucent = isTrans;
    }
}
extension UIColor {
    static var placeholderGray: UIColor {
        return UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22)
    }
}


extension UILabel {
    func applyDesign() {
         self.setLineSpacing(lineSpacing: 4, lineHeightMultiple: 1)
         self.numberOfLines = 2
         self.font = UIFont(name: "Menlo-Bold", size: 40)
         self.translatesAutoresizingMaskIntoConstraints = false
     }

    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple

        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        // (Swift 4.2 and above) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))


        // (Swift 4.1 and 4.0) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
    }
}
