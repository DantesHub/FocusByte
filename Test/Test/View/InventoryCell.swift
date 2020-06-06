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
import RealmSwift


class InventoryCell: UICollectionViewCell {
    //MARK: - Properties
    var results: Results<User>!
    var img = UIImage()
    var imgName = ""
    lazy var itemImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFit
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedItem))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    var count = 0
    var rarity = ""
    let label = UILabel()
    var type = ""
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
        if imgName != "blank" {
            let appearance = SCLAlertView.SCLAppearance(
                kWindowWidth: 300,
                kWindowHeight: count > -1 ? 330 : 280,
                kButtonHeight: 50,
                kTitleFont: UIFont(name: "Menlo-Bold", size: 25)!,
                kTextFont: UIFont(name: "Menlo", size: 15)!,
                showCloseButton: false,
                showCircularIcon: false,
                hideWhenBackgroundViewIsTapped: true,
                contentViewColor: superLightLavender
            )
            let alertView = SCLAlertView(appearance: appearance)
            let subview = UIView(frame: CGRect(x:0,y:0,width:300,height:count > -1 ? 350:250))
            if count > -1 && menuLabel != "Pets" {
                let itemIV = UIImageView()
                itemIV.translatesAutoresizingMaskIntoConstraints = false
                itemIV.contentMode = .scaleAspectFit
                itemIV.image = img
                
                let rarityLabel = UILabel()
                rarityLabel.text = "Rarity:"
                rarityLabel.font = UIFont(name: "Menlo", size: 20)
                rarityLabel.translatesAutoresizingMaskIntoConstraints = false
                
                let scarcity = UILabel()
                scarcity.text = "\(rarity)"
                scarcity.font = UIFont(name: "Menlo", size: 20)
                switch rarity {
                case "Common":
                    scarcity.textColor = .black
                case "Rare":
                    scarcity.textColor = .black
                    scarcity.font =  UIFont(name: "Menlo-Bold", size: 20)
                case "Super Rare":
                    scarcity.textColor = diamond
                    scarcity.font =  UIFont(name: "Menlo-Bold", size: 20)
                case "Epic":
                    scarcity.textColor = brightPurple
                    scarcity.font =  UIFont(name: "Menlo-Bold", size: 20)
                default:
                    print("default")
                }
                scarcity.translatesAutoresizingMaskIntoConstraints = false
                
                let stockLabel = UILabel()
                stockLabel.text = "Stock: \(count)"
                stockLabel.font = UIFont(name: "Menlo", size: 20)
                stockLabel.translatesAutoresizingMaskIntoConstraints = false
                
                subview.addSubview(itemIV)
                itemIV.translatesAutoresizingMaskIntoConstraints = false
                itemIV.edges(to: subview, insets: TinyEdgeInsets(top: 10, left: 0, bottom: 70, right: 25))
                subview.addSubview(rarityLabel)
                rarityLabel.topToBottom(of: itemIV)
                rarityLabel.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 15).isActive = true
                subview.addSubview(scarcity)
                scarcity.leftToRight(of: rarityLabel, offset: 10)
                scarcity.topToBottom(of: itemIV)
                
                subview.addSubview(stockLabel)
                stockLabel.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: -10).isActive = true
                stockLabel.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 15).isActive = true
            } else {  //this is a clothing item
                let itemIV = UIImageView()
                itemIV.translatesAutoresizingMaskIntoConstraints = false
                itemIV.contentMode = .scaleAspectFit
                itemIV.image = img
                
                subview.addSubview(itemIV)
                itemIV.translatesAutoresizingMaskIntoConstraints = false
                itemIV.edges(to: subview, insets: TinyEdgeInsets(top: 10, left: 0, bottom: 30, right: 25))
                //create equip button
                if count == -1 || menuLabel == "Pets"{
                    alertView.addButton("Equip", backgroundColor: darkRed, textColor: .white, showTimeout: .none) {
                        if topBook.contains(where: {$0.key == self.imgName }) {
                            sweaterImageView.image = UIImage(named: self.imgName)
                            self.type = "shirt"
                        } else if shoeBook.contains(where: {$0.key == self.imgName }) {
                            shoesImageView.image = UIImage(named: self.imgName)
                            self.type = "shoes"
                        } else if backpackBook.contains(where: {$0.key == self.imgName }) {
                            backpackView.image = UIImage(named: self.imgName)
                            self.type = "backpack"
                        } else if pantsBook.contains(where: {$0.key == self.imgName }) {
                            pantsImageView.image = UIImage(named: self.imgName)
                            self.type = "pants"
                        } else if self.imgName == "nobag" {
                            backpackView.image = UIImage(named: "blank")
                            self.type = "backpack"
                        } else if self.imgName == "noframe" {
                            glassesImageView.image = UIImage()
                            self.type = "glasses"
                        } else if petBook.contains(where: {$0 == self.imgName}) {
                            petImageView.image = UIImage(named: self.imgName)
                            self.type = "pet"
                        } else if frameBook.contains(where: {$0.key == self.imgName}) {
                            glassesImageView.image = UIImage(named: self.imgName)
                            self.type = "glasses"
                        }
                        self.saveToRealm()
                        return
                    }
                }
            }
            
            alertView.customSubview = subview
            alertView.showCustom(imgName, subTitle: "", color: .white, icon: UIImage())
            
        }
        
    }
    
    func saveToRealm() {
        self.results = uiRealm.objects(User.self)
        for result  in self.results {
            if result.isLoggedIn == true {
                do {
                    try uiRealm.write {
                        result.setValue(imgName, forKey: type)
                    }
                } catch {
                    print(error)
                }
            }
        }
        self.superview?.setNeedsDisplay()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
