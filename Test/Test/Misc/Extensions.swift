//
//  Extensions.swift
//  Test
//
//  Created by Dante Kim on 4/18/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Charts
import SCLAlertView
import TinyConstraints
import CryptoKit
import StoreKit

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }

        return array
    }
}
extension UIViewController {
    var topBarHeight: CGFloat {
        var top = self.navigationController?.navigationBar.frame.height ?? 0.0
        if #available(iOS 13.0, *) {
            top += UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            top += UIApplication.shared.statusBarFrame.height
        }
        return top
    }
}
extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
extension UIAlertController {
    func addImage(image: UIImage) {
        let imgAction = UIAlertAction(title: "", style: .default, handler: nil)
        imgAction.isEnabled = true
        imgAction.setValue(image.withRenderingMode(.alwaysOriginal), forKey: "image")
        self.addAction(imgAction)
    }
}

extension Collection where Element: Equatable {
    func secondIndex(of element: Element) -> Index? {
        guard let index = firstIndex(of: element) else { return nil }
        return self[self.index(after: index)...].firstIndex(of: element)
    }
    func indexes(of element: Element) -> [Index] {
        var indexes: [Index] = []
        var startIndex = self.startIndex
        while let index = self[startIndex...].firstIndex(of: element) {
            indexes.append(index)
            startIndex = self.index(after: index)
        }
        return indexes
    }
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
        var parentViewController: UIViewController? {
            var parentResponder: UIResponder? = self
            while parentResponder != nil {
                parentResponder = parentResponder!.next
                if let viewController = parentResponder as? UIViewController {
                    return viewController
                }
            }
            return nil
        }
    
    func applyDesign(color: UIColor) {
        self.backgroundColor = color
        self.layer.cornerRadius = 25
        if color != .black {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.5;
        } else {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.5;
        }
 
        self.layer.shadowRadius = 12
        self.layer.shadowOffset = CGSize(width: 10, height: 10)
    }
    
    func dropShadow(superview: UIView) {
        // Get context from superview
        UIGraphicsBeginImageContext(self.bounds.size)
        superview.drawHierarchy(in: CGRect(x: -self.frame.minX, y: -self.frame.minY, width: superview.bounds.width, height: superview.bounds.height), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Add a UIImageView with the image from the context as a subview
        let imageView = UIImageView(frame: self.bounds)
        imageView.image = image
        imageView.layer.cornerRadius = self.layer.cornerRadius
        imageView.clipsToBounds = true
        self.addSubview(imageView)
        
        // Bring the background color to the front, alternatively set it as UIColor(white: 1, alpha: 0.2)
        let brighter = UIView(frame: self.bounds)
        brighter.backgroundColor = self.backgroundColor ?? UIColor(white: 1, alpha: 0.2)
        brighter.layer.cornerRadius = self.layer.cornerRadius
        brighter.clipsToBounds = true
        self.addSubview(brighter)
        
        // Set the shadow
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
    }
}
extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
extension UIImage {
    func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.red
    
//        let textFont = UIFont(name: "Helvetica Bold", size: 12)!

        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)

        let textFontAttributes = [
            NSAttributedString.Key.strokeColor : UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "Menlo", size: 16)!,
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.strokeWidth : -5.0,
            ] as [NSAttributedString.Key : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))

        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
    func resize(targetSize: CGSize) -> UIImage {
            return UIGraphicsImageRenderer(size:targetSize).image { _ in
                self.draw(in: CGRect(origin: .zero, size: targetSize))
            }
            
        }
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
extension CATransition {
    func segueFromLeft() -> CATransition {
        self.duration = 0.3 //set the duration to whatever you'd like.
        self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.type = CATransitionType.moveIn
        self.subtype = CATransitionSubtype.fromLeft
        return self
    }
    func segueFromRight() -> CATransition {
        self.duration = 0.3 //set the duration to whatever you'd like.
        self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.type = CATransitionType.moveIn
        self.subtype = CATransitionSubtype.fromRight
        return self
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
    public func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }

    public func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    

}

extension UINavigationController {
    func customPopView(_ viewController: UIViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        view.layer.add(transition, forKey: nil)
        pushViewController(viewController, animated: false)
    }
}
extension UIColor {
    static var placeholderGray: UIColor {
        return UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22)
    }
}

extension NSMutableAttributedString {

    func setColor(color: UIColor, forText stringValue: String) {
       let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }

}
extension UILabel {
    func applyDesign() {
        self.setLineSpacing(lineSpacing: 4, lineHeightMultiple: 1)
        self.numberOfLines = 2
        self.font = UIFont(name: "Menlo-Bold", size: 40)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func applyDesign(text: String) {
        self.font = UIFont(name: "Menlo", size: 25)
        self.text = text
        self.textAlignment = .center
        self.textColor = .white
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
extension String {

    func toDate(withFormat format: String = "MM-dd-yyyy HH:mm")-> Date?{

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date

    }
    func attributedStringWithColor(_ strings: [String], color: UIColor, characterSpacing: UInt? = nil) -> NSAttributedString {
         let attributedString = NSMutableAttributedString(string: self)
         for string in strings {
             let range = (self as NSString).range(of: string)
             attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
         }

         guard let characterSpacing = characterSpacing else {return attributedString}

         attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))

         return attributedString
     }
}

extension Date {
    func toString(withFormat format: String = "MM/dd/yyyy HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)
        return str
    }
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}
extension TimeInterval{
        func stringFromTimeInterval() -> String {

            let time = NSInteger(self)

            let seconds = time % 60
            let minutes = (time / 60) % 60
            let hours = (time / 3600)

            return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
        }
    }
extension UITextField {
    
    func applyDesign(_ view: UIView, x: CGFloat, y: CGFloat) {
        
        let paddingView = UIView(frame: CGRect(x:0,y:0,width:(15 + CGFloat(titlePadding)), height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = UITextField.ViewMode.always
        self.attributedPlaceholder = NSAttributedString(string: "placeholder text", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderGray])
        self.textColor = .black
        self.layer.cornerRadius = 25
        self.font = UIFont(name: "Menlo", size: 20)
        self.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = self.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let widthConstraint = self.widthAnchor.constraint(equalToConstant: 300)
        let heightConstraint = self.heightAnchor.constraint(equalToConstant: 75)
        view.addConstraints([horizontalConstraint, widthConstraint, heightConstraint])
        let shadowView = UIView(frame: CGRect(x: view.center.x + x , y: view.center.y + y , width: buttonWidth, height: 75))
        shadowView.backgroundColor = .white
        shadowView.layer.cornerRadius = 25.0
        shadowView.dropShadow(superview: view)
        view.addSubview(shadowView)
        view.insertSubview(self, aboveSubview: shadowView)
    }
    
    @IBInspectable var doneAccessory: Bool{
          get{
              return self.doneAccessory
          }
          set (hasDone) {
              if hasDone{
                  addDoneButtonOnKeyboard()
              }
          }
      }
      
      func addDoneButtonOnKeyboard()
      {
          let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
          doneToolbar.barStyle = .default
          
          let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
          let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
          
          let items = [flexSpace, done]
          doneToolbar.items = items
          doneToolbar.sizeToFit()
          
          self.inputAccessoryView = doneToolbar
      }
      
      @objc func doneButtonAction()
      {
          self.resignFirstResponder()
      }
    
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
