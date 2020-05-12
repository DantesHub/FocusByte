//
//  BoxCell.swift
//  Test
//
//  Created by Dante Kim on 4/18/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit

class BoxCell: UICollectionViewCell {
    
    //MARK: - properties
    var data: MysteryBox? {
        didSet {
            guard let data = data else { return }
            boxView.image = data.image
        }
    }

    let boxView : UIImageView = {
           let iv = UIImageView()
           iv.translatesAutoresizingMaskIntoConstraints = false
           iv.contentMode = .scaleAspectFit
           iv.clipsToBounds = true
           return iv
       }()
    let desc : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        label.clipsToBounds = true
        label.font = UIFont(name: "Menlo", size: 25)
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
         label.textColor = .white
        label.textAlignment = .center
         label.translatesAutoresizingMaskIntoConstraints = false
         label.numberOfLines = 0
         label.textColor = .black
         label.clipsToBounds = true
         label.font = UIFont(name: "Menlo-Bold", size: 35)
         return label

    }()
    
    let buyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel!.font = UIFont(name: "Menlo-Bold", size: 30)
        button.setTitle("BUY", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel!.textColor = .white
        button.sizeToFit()
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 10, height: 10)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.5
        return button
    }()
    override init(frame:CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(boxView)
        contentView.addSubview(desc)
        contentView.addSubview(buyButton)
        contentView.backgroundColor = superLightLavender
        contentView.layer.cornerRadius = 25
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 10)
        contentView.layer.shadowRadius = 2
        contentView.layer.shadowOpacity = 0.5
        
        
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 20).isActive = false
        
        boxView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -10).isActive = true
        boxView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30).isActive = true
        boxView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
//
        desc.topAnchor.constraint(equalTo: boxView.bottomAnchor, constant: 0).isActive = true
        desc.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60).isActive = true
        desc.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
        
        buyButton.topAnchor.constraint(equalTo: desc.bottomAnchor, constant: 0).isActive = false
        buyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60).isActive = true
        buyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60).isActive = true
        buyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
