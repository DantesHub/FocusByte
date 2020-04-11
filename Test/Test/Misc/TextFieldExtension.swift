//
//  TextViewExtension.swift
//  Test
//
//  Created by Dante Kim on 3/31/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//
import Foundation
import UIKit

extension UITextField {
    func applyDesign(_ view: UIView, x: CGFloat, y: CGFloat) {
        
        let paddingView = UIView(frame: CGRect(x:0,y:0,width:15, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = UITextField.ViewMode.always
   
        self.textColor = .black
        self.layer.cornerRadius = 25
        self.font = UIFont(name: "Menlo", size: 20)
        self.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = self.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let widthConstraint = self.widthAnchor.constraint(equalToConstant: 300)
        let heightConstraint = self.heightAnchor.constraint(equalToConstant: 75)
        view.addConstraints([horizontalConstraint, widthConstraint, heightConstraint])
        let shadowView = UIView(frame: CGRect(x: view.center.x + x , y: view.center.y + y , width: 340, height: 75))
        shadowView.backgroundColor = .white
        shadowView.layer.cornerRadius = 25.0
        shadowView.dropShadow(superview: view)
        view.addSubview(shadowView)
        view.insertSubview(self, aboveSubview: shadowView)
    }
    
    
    
}




extension UIView {
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
