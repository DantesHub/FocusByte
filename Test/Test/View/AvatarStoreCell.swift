//
//  AvatarStoreCell.swift
//  Test
//
//  Created by Dante Kim on 6/1/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit
import TinyConstraints
import SCLAlertView
import Firebase
import Foundation
import RealmSwift

class AvatarStoreCell: UICollectionViewCell {
    var leadingPrice = 60
    var coinPadding: CGFloat {
        get {
            var coinPadding: CGFloat = 0
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 2688:
                    leadingPrice = 95
                    coinPadding = -13
                //print("IPHONE XS MAX, IPHONE 11 PRO MAX")
                case 1792:
                    leadingPrice = 95
                    coinPadding = -13
                //print("IPHONE XR, IPHONE 11")
                case 1920, 2208:
                    //iphone 8 plus
                     coinPadding = -15
                default:
                    coinPadding = -5
                }
            }
            return coinPadding
        }
    }
    //MARK: - properties
    static var cellId = "AvatarStoreCellId"
    var img = UIImage()
    var imgName = ""
    var price = 0
    var results: Results<User>!
    let db = Firestore.firestore()
    var bigIpad = false
    lazy var itemImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFit

        return iv
    }()
    lazy var coinImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        iv.image = UIImage(named: "coins")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    var priceLabel = UILabel()
    var titleLabel = UILabel()
    //MARK: - init
    override init(frame:CGRect) {
        super.init(frame: frame)
        if UIDevice().userInterfaceIdiom != .pad {
            configureUI()
        } else {
            switch UIScreen.main.nativeBounds.height {
            case 2732:
                bigIpad = true
            default:
                print("Im sorry")
            }
            configurePadUI()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Handlers
    func configurePadUI() {
        self.backgroundColor = superLightLavender
        self.layer.cornerRadius = 25
        self.layer.masksToBounds = true
        self.dropShadow(superview: self)
        self.addSubview(titleLabel)
        
        self.addSubview(priceLabel)
        priceLabel.font = UIFont(name: "Menlo", size:bigIpad ? 45 : 30)
        priceLabel.width()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: bigIpad ? 210:160).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        

        
        self.addSubview(coinImageView)
        coinImageView.height(40)
        coinImageView.width(30)
        coinImageView.leftToRight(of: priceLabel,offset: 5)
        coinImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant:  -60).isActive = true
        
        self.addSubview(itemImageView)
        itemImageView.height(bigIpad ? 300 : 200)
        itemImageView.width(bigIpad ? 300 : 200)
        itemImageView.centerX(to: contentView)
        itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        itemImageView.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -10).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedItem))
        self.addGestureRecognizer(tap)
    }
    func configureUI() {
        self.backgroundColor = superLightLavender
        self.layer.cornerRadius = 25
        self.layer.masksToBounds = true
        self.dropShadow(superview: self)
        contentView.addSubview(titleLabel)
        
        contentView.insertSubview(priceLabel, at: 1000)
        priceLabel.font = UIFont(name: "Menlo", size: 21)
//        priceLabel.width()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        if isIpod {
            priceLabel.bottom(to: self,offset: -30)
        } else {
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        }
        priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60).isActive = true
        self.addSubview(coinImageView)
          coinImageView.height(20)
          coinImageView.width(15)
          coinImageView.leftToRight(of: priceLabel,offset: 5)
          coinImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: coinPadding).isActive = true
        
        self.addSubview(itemImageView)
        itemImageView.height(100)
        itemImageView.width(100)
        itemImageView.centerX(to: contentView)
        itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        itemImageView.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -10).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedItem))
        self.addGestureRecognizer(tap)
        
    }
    
    @objc func tappedItem() {
        let appearance = SCLAlertView.SCLAppearance(
            kWindowWidth: 300,
            kWindowHeight: 380,
            kButtonHeight: 50,
            kTitleFont: UIFont(name: "Menlo-Bold", size: 25)!,
            kTextFont: UIFont(name: "Menlo", size: 15)!,
            showCloseButton: false,
            showCircularIcon: false,
            hideWhenBackgroundViewIsTapped: true,
            contentViewColor: .white
        )
        let alertView = SCLAlertView(appearance: appearance)
        let subview = UIView(frame: CGRect(x:0,y:0,width:280,height:350))
        let itemIV = UIImageView()
        let coinIV = UIImageView()
        coinIV.translatesAutoresizingMaskIntoConstraints = false
        coinIV.image = UIImage(named: "coins")
        let priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.text = String(price)
        priceLabel.font = UIFont(name: "Menlo", size: 30)
        
  
        
        itemIV.translatesAutoresizingMaskIntoConstraints = false
        itemIV.contentMode = .scaleAspectFit
        itemIV.image = img
        subview.addSubview(itemIV)
        itemIV.translatesAutoresizingMaskIntoConstraints = false
        itemIV.edges(to: subview, insets: TinyEdgeInsets(top: 10, left: 30, bottom: 70, right: 40))
        subview.addSubview(priceLabel)
        subview.backgroundColor = superLightLavender
        subview.layer.cornerRadius = 25
        priceLabel.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 110).isActive = true
        priceLabel.topAnchor.constraint(equalTo: itemIV.bottomAnchor, constant: 35).isActive = true
        
        subview.addSubview(coinIV)
        coinIV.height(30)
        coinIV.width(20)
        coinIV.topAnchor.constraint(equalTo: itemIV.bottomAnchor, constant: 35).isActive = true
        coinIV.leftToRight(of: priceLabel, offset: 5)
        
        
        alertView.addButton("Buy", backgroundColor: brightPurple, textColor: .white, showTimeout: .none) {
            if suitBook.contains(where: {$0.key == self.imgName}) {
                if level < 70 {
                    let alertView = SCLAlertView()
                              alertView.showNotice("Must be at least level 70 to purchase", subTitle: "")
                } else {
                    if coins >= self.price {
                        //saveToRealm and firebase
                        inventoryArray.append(self.imgName)
                        coins = coins - self.price
                        self.save()
                        //add to clothesarray
                        //reload collectionView
                        NotificationCenter.default.post(name: NSNotification.Name(updateCollection), object: nil)
                        return
                    } else {
                        let alertView = SCLAlertView()
                        alertView.showNotice("Not Enough Coins", subTitle: "")
                    }
                }
            } else {
                if level < 34 {
                    let alertView = SCLAlertView()
                    alertView.showNotice("Must be at least level 34 to purchase", subTitle: "")
                } else {
                    if coins >= self.price {
                        //saveToRealm and firebase
                        inventoryArray.append(self.imgName)
                        coins = coins - self.price
                        self.save()
                        //add to clothesarray
                        //reload collectionView
                        NotificationCenter.default.post(name: NSNotification.Name(updateCollection), object: nil)
                        return
                    } else {
                        let alertView = SCLAlertView()
                        alertView.showNotice("Not Enough Coins", subTitle: "")
                    }
                }
            }
        }
        alertView.addButton("Cancel", backgroundColor: .gray, textColor: .white, showTimeout: .none) {
            return
        }
        alertView.customSubview = subview
        alertView.showCustom(imgName, subTitle: "", color: .white, icon: UIImage())

    }
    func save() {
        if UserDefaults.standard.bool(forKey: "isPro") == true {
            //update data in firebase
                 if let _ = Auth.auth().currentUser?.email {
                     let email = Auth.auth().currentUser?.email
                     self.db.collection(K.userPreferenes).document(email!).updateData([
                         "coins": coins,
                         "inventoryArray": inventoryArray
                     ]) { (error) in
                         if let e = error {
                             print("There was a issue saving data to firestore \(e) ")
                         } else {
                             print("Succesfully saved new items")
                         }
                     }
                 }
        }
        
        //saveToRealm
        let realmInventory = List<String>()
        for item in inventoryArray {
            realmInventory.append(item)
        }
        results = uiRealm.objects(User.self)
        for result  in results {
            if result.isLoggedIn == true {
                do {
                    try uiRealm.write {
                        result.setValue((coins), forKey: "coins")
                        result.setValue(realmInventory, forKey: "inventoryArray")
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func setImage(image: UIImage) {
        self.img = image
        itemImageView.image = image
    }
    
    func setImageName(name: String) {
        self.imgName = name
        titleLabel.text = imgName
           for piece in allClothes {
            if piece.key == imgName {
                price = piece.value
                priceLabel.text = String(piece.value)
            }
           }
    }
    

}
