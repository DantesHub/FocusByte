//
//  EyeColorCell.swift
//  Test
//
//  Created by Dante Kim on 5/30/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit
import TinyConstraints
class EyeColorCell: UICollectionViewCell {
    //MARK: - properties
    var colorView: UIView = {
          let cv = UIView()
          cv.translatesAutoresizingMaskIntoConstraints = false
          return cv
      }()
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    func configureUI() {
        self.backgroundColor = .clear
        colorView.height(contentView.frame.height)
        colorView.width(contentView.frame.width)
        self.layer.cornerRadius = 25
        self.layer.masksToBounds = true
        self.addSubview(colorView)
        colorView.layer.cornerRadius = 25
        colorView.center(in: contentView)
        colorView.dropShadow(superview: self)
    }
    
    func setBorder(border: Bool) {
          if border == true {
              self.layer.masksToBounds = true
              self.layer.borderWidth = 5
              self.layer.cornerRadius = 25
              self.layer.borderColor = UIColor.white.cgColor
          } else {
              self.layer.borderColor = UIColor.clear.cgColor
          }
      }
      
      func setColor(color: String) {
          self.colorView.backgroundColor = K.getAvatarColor(color)
      }
}

struct SelectedEyeColor {
    var color: String
    var isSelected: Bool
}
