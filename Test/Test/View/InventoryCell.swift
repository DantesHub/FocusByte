//
//  InventoryCell.swift
//  Test
//
//  Created by Dante Kim on 5/26/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit
import TinyConstraints
import SCLAlertView

class InventoryCell: UICollectionViewCell {
    //MARK: - Properties
    var img = UIImage()
    lazy var itemImageView: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "greenpurse")
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedItem))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    let label = UILabel()
    //MARK: - init
    override init(frame:CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        self.backgroundColor = inventoryCellColor
        self.layer.cornerRadius = 25
        self.layer.masksToBounds = true
        self.dropShadow(superview: self)
        self.addSubview(itemImageView)
        itemImageView.edges(to: contentView, insets: TinyEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    func setImage(image: UIImage) {
        self.img = image
        itemImageView.image = image
    }
    
    @objc func tappedItem() {
       let appearance = SCLAlertView.SCLAppearance(
           kWindowWidth: 300,
           kWindowHeight: 380,
           kButtonHeight: 35,
           kTitleFont: UIFont(name: "Menlo-Bold", size: 25)!,
           kTextFont: UIFont(name: "Menlo", size: 15)!,
           showCloseButton: false,
           showCircularIcon: false,
           hideWhenBackgroundViewIsTapped: true,
           contentViewColor: superLightLavender
       )
        let itemIV = UIImageView()
        itemIV.translatesAutoresizingMaskIntoConstraints = false
        itemIV.contentMode = .scaleAspectFit
        itemIV.image = img
        
        let alertView = SCLAlertView(appearance: appearance)
        let rarityLabel = UILabel()
        rarityLabel.text = "Rarity:"
        rarityLabel.font = UIFont(name: "Menlo", size: 20)
        rarityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let rarity = UILabel()
        rarity.text = "Common"
        rarity.translatesAutoresizingMaskIntoConstraints = false
        rarity.font = UIFont(name: "Menlo-Bold", size: 20)
        
        let stockLabel = UILabel()
        stockLabel.text = "Stock: 1"
        stockLabel.font = UIFont(name: "Menlo", size: 20)
        stockLabel.translatesAutoresizingMaskIntoConstraints = false

        let subview = UIView(frame: CGRect(x:0,y:0,width:300,height:350))
        subview.addSubview(itemIV)
        itemIV.translatesAutoresizingMaskIntoConstraints = false
        itemIV.edges(to: subview, insets: TinyEdgeInsets(top: 10, left: 0, bottom: 70, right: 25))
        subview.addSubview(rarityLabel)
        rarityLabel.topToBottom(of: itemIV)
        rarityLabel.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 15).isActive = true
        subview.addSubview(rarity)
        rarity.leftToRight(of: rarityLabel, offset: 10)
        rarity.topToBottom(of: itemIV)
        
        subview.addSubview(stockLabel)
        stockLabel.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: -10).isActive = true
        stockLabel.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 15).isActive = true
        alertView.customSubview = subview
        alertView.showCustom("Scissors", subTitle: "", color: .white, icon: UIImage())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}