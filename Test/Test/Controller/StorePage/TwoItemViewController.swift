//
//  TwoItemViewController.swift
//  Test
//
//  Created by Dante Kim on 5/27/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit
import TinyConstraints

class TwoItemViewController: NewitemViewController {
    lazy var commonItemImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    var youGotLabel = UILabel()
    var goldItemArray = [String]()
    var commonItemLabel = UILabel()
    lazy var rareItemImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    var rareItemLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBottomButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        goldItemArray = MysteryItemLogic.getGoldItems()
        inventoryArray.append(goldItemArray[0])
        inventoryArray.append(goldItemArray[1])
        saveToFirebaseAndRealm()
        configureUI()
    }
    
    override func configureUI() {
        if name == "Diamond Box" {
            goldItemArray = MysteryItemLogic.getGoldItems()
        } else {
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1920, 2208:
                    commonItemPadding = 60
                //("iphone 8plus ")
                case 1334:
                    commonItemPadding = 60
                default:
                    print("kobe")
                }
            }
        }
        view.backgroundColor = superLightLavender
        view.addSubview(youGotLabel)
        youGotLabel.text = "You Got:"
        youGotLabel.font = UIFont(name: "Menlo-Bold", size: youGotFontSize)
        youGotLabel.translatesAutoresizingMaskIntoConstraints = false
        youGotLabel.topToSuperview(offset: commonItemPadding)
        youGotLabel.centerX(to: view)
        
        view.addSubview(commonItemImageView)
        if name == "Gold Box" {
            commonItemImageView.topAnchor.constraint(equalTo: youGotLabel.bottomAnchor, constant: commonItemPadding).isActive = true
        } else {
            commonItemImageView.topAnchor.constraint(equalTo: youGotLabel.bottomAnchor, constant: 40).isActive = true
        }
        
        commonItemImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        commonItemImageView.image = UIImage(named: goldItemArray[0])
        commonItemImageView.width(itemImageSize)
        commonItemImageView.height(itemImageSize)
        
        commonItemLabel.translatesAutoresizingMaskIntoConstraints = false
        commonItemLabel.numberOfLines = 0
        commonItemLabel.text = "\(goldItemArray[0])\n-Common"
        commonItemLabel.font = UIFont(name: "Menlo", size: 20)
        view.addSubview(commonItemLabel)
        commonItemLabel.leftToRight(of: commonItemImageView, offset: 5)
        commonItemLabel.centerYAnchor.constraint(equalTo: commonItemImageView.centerYAnchor).isActive = true
        
        view.addSubview(rareItemImageView)
        rareItemImageView.topToBottom(of: commonItemImageView, offset: 10)
        rareItemImageView.leadingToSuperview(offset: 10)
        rareItemImageView.image = UIImage(named: goldItemArray[1])
        rareItemImageView.width(itemImageSize)
        rareItemImageView.height(itemImageSize)
        
        rareItemLabel.translatesAutoresizingMaskIntoConstraints = false
        
        rareItemLabel.text = "\(goldItemArray[1])"
        rareItemLabel.font = UIFont (name: "Menlo", size: 20)
        view.addSubview(rareItemLabel)
        rareItemLabel.leftToRight(of: rareItemImageView, offset: 5)
        rareItemLabel.centerYAnchor.constraint(equalTo: rareItemImageView.centerYAnchor).isActive = true
        rarityLabel.translatesAutoresizingMaskIntoConstraints = false
        rarityLabel.font = UIFont(name: "Menlo-Bold",size:20)
        rarityLabel.text = itemBook[goldItemArray[1]]! == "Rare" ? "-\(itemBook[goldItemArray[1]]!)!" : "-\(itemBook[goldItemArray[1]]!)!!"
        rarityLabel.textColor = itemBook[goldItemArray[1]]! == "Rare" ?  darkRed : diamond
        view.addSubview(rarityLabel)
        rarityLabel.leftToRight(of: rareItemImageView, offset: 10)
        rarityLabel.topToBottom(of: rareItemLabel, offset: 5)
        
        
    }
}
