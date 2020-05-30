//
//  HairCell.swift
//  Test
//
//  Created by Dante Kim on 5/29/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit
import TinyConstraints
class HairCell: UICollectionViewCell {
    //MARK: - Properties
    var image: String? {
           didSet {
            guard let image = image else { return }
            hairView.image = UIImage(named: image)
           }
       }
    var hairView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        let tap = UIGestureRecognizer(target: self, action: #selector(tappedHair))
        return iv
    }()
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: helper funcs
    func configureUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 25
        self.layer.masksToBounds = true
        self.dropShadow(superview: self)
        self.addSubview(hairView)
        hairView.center(in: contentView)
    }
    
    func setImage(image: String) {
        hairView.image = UIImage(named: image)
    }
    
    func setBorder(border: Bool) {
        if border == true {
            self.layer.masksToBounds = true
            self.layer.borderWidth = 3
            self.layer.cornerRadius = 25
            self.layer.borderColor = UIColor.black.cgColor
        } else {
            self.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    @objc func tappedHair() {
        
    }
}
