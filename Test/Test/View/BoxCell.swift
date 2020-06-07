//
//  BoxCell.swift
//  Test
//
//  Created by Dante Kim on 4/18/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit
import TinyConstraints
var boxDescFontSize:CGFloat = 21
var commonItemPadding: CGFloat = 70
var youGotFontSize:CGFloat = 35
var itemImageSize: CGFloat = 150
var commonTitlePadding: CGFloat = 80
var chestFont: CGFloat = 30
var titleFont: CGFloat = 35
var boxPadding: CGFloat {
    get {
        var size: CGFloat = 0
        if UIDevice().userInterfaceIdiom == .phone || UIDevice().userInterfaceIdiom == .pad {
            switch UIScreen.main.nativeBounds.height {
            case 1920, 2208:
                size = -5
                boxDescFontSize = 21
                itemImageSize = 100
                boxSize = 150
                youGotFontSize = 30
                commonItemPadding = 20
                commonTitlePadding = 30
                titleFont = 30
                chestFont = 20
            //("iphone 8plus ")
            case 1334:
                //Iphone 8
                size = -5
                boxSize = 150
                itemImageSize = 100
                youGotFontSize = 30
                boxDescFontSize = 16
                titleFont = 30
                commonItemPadding = 20
                commonTitlePadding = 30
                chestFont = 20
            case 2436:
                size = -5
                titleFont = 30
                youGotFontSize = 28
                boxDescFontSize = 21
                chestFont = 25
            //print("IPHONE X, IPHONE XS, IPHONE 11 PRO")
            case 2688:
                size = -30
                boxDescFontSize = 23
                commonItemPadding = 120
            //print("IPHONE XS MAX, IPHONE 11 PRO MAX")
            case 1792:
                size = -30
                boxDescFontSize = 23
                commonItemPadding = 100
            //print("IPHONE XR, IPHONE 11")
            default:
                size = -30
                titleFont = 60
                titlePadding = 9
                itemImageSize = 200
                boxDescFontSize = 30
                chestFont = 45
            }
        }
        return size
    }
}
var boxSize: CGFloat = 200

class BoxCell: UICollectionViewCell {
    //MARK: - properties
    var data: MysteryBox? {
        didSet {
            guard let data = data else { return }
            boxView.image = data.image
            boxView.widthAnchor.constraint(greaterThanOrEqualToConstant: boxSize).isActive = true
            boxView.heightAnchor
                .constraint(greaterThanOrEqualToConstant: boxSize).isActive = true

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
        label.font = UIFont(name: "Menlo", size: boxDescFontSize)
        return label
    }()
    let coinImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "coins")
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
         label.textColor = .white
        label.textAlignment = .center
         label.translatesAutoresizingMaskIntoConstraints = false
         label.numberOfLines = 0
         label.textColor = .black
         label.clipsToBounds = true
         label.font = UIFont(name: "Menlo-Bold", size: titleFont)
         return label

    }()
    let dollarIconView: UIImageView = {
        let iv = UIImageView ()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "dollarIcon")
        return iv
    }()
    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "Menlo", size: UIDevice().userInterfaceIdiom == .pad ? 40 : 25)
        return label
    }()
    
    let buyButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel!.font = UIFont(name: "Menlo-Bold", size: youGotFontSize)
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
        contentView.backgroundColor = lightLavender
        contentView.layer.cornerRadius = 25
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 10)
        contentView.layer.shadowRadius = 2
        contentView.layer.shadowOpacity = 0.5
        
        
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 20).isActive = false
        
        boxView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        boxView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        boxView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true

        
        desc.topAnchor.constraint(equalTo: boxView.bottomAnchor, constant: 20).isActive = true
        desc.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: onUpgrade ? 45:60).isActive = true
        desc.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: onUpgrade ? -45:-60
        ).isActive = true
        
    
        
        buyButton.topAnchor.constraint(equalTo: desc.bottomAnchor, constant: 0).isActive = false
        buyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60).isActive = true
        buyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60).isActive = true
        buyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30).isActive = true
        if onUpgrade {
            buyButton.addSubview(dollarIconView)
            dollarIconView.leadingAnchor.constraint(equalTo: buyButton.leadingAnchor, constant: 30).isActive = true
            dollarIconView.centerY(to: buyButton)
            dollarIconView.height(max: buyButton.frame.height * 1.50)
            dollarIconView.width(max: buyButton.frame.width * 0.80)
        }
        
        
        if !onUpgrade {
            contentView.addSubview(priceLabel)
            priceLabel.text = "Price: 70"
            priceLabel.bottomAnchor.constraint(equalTo: buyButton.topAnchor, constant: -10).isActive = true
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIDevice().userInterfaceIdiom == .pad ? 200:70).isActive = true
            
            contentView.addSubview(coinImageView)
            coinImageView.width(UIDevice().userInterfaceIdiom == .pad ? 40:25)
            coinImageView.height(UIDevice().userInterfaceIdiom == .pad ? 50:30)
              coinImageView.bottomAnchor.constraint(equalTo: buyButton.topAnchor, constant: -10).isActive = true
            coinImageView.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant:10).isActive = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
