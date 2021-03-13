//
//  AvatarSideBar.swift
//  Test
//
//  Created by Dante Kim on 5/29/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import Foundation
import UIKit
import TinyConstraints
import RealmSwift
import SCLAlertView
import Firebase
var selectedHair = "defaultManHair"
var selectedHairColor = "black"
var selectedEyeColor = "black"
var skinColor = "tan"
var pets = false
var shoes = false
var maleHairImages = [Feature(name: "defaultManHair", isSelected: false),Feature(name: "manHair2", isSelected: false),Feature(name: "manHair3", isSelected: false),Feature(name: "manHair4", isSelected: false),Feature(name: "manHair5", isSelected: false),Feature(name: "none", isSelected: false)]
var femaleHairImages = [Feature(name: "womanHair1", isSelected: false),Feature(name: "womanHair2", isSelected: false),Feature(name: "womanHair3", isSelected: false),Feature(name: "womanHair4", isSelected: false), Feature(name: "none", isSelected: false)]
 var hairColors = [SelectedColor(color: "black", isSelected: false), SelectedColor(color: "brown", isSelected: false), SelectedColor(color: "blonde", isSelected: false), SelectedColor(color: "darkRed", isSelected: false),SelectedColor(color: "gray", isSelected: false)]
 var skinColors = [SelectedColor(color: "tan", isSelected: false),SelectedColor(color: "darkTan", isSelected: false),SelectedColor(color: "brown", isSelected: false), SelectedColor(color: "brightGreen", isSelected: false), SelectedColor(color: "blue", isSelected: false)]
var eyeColors = [SelectedEyeColor(color: "black", isSelected: false),SelectedEyeColor(color: "blue", isSelected: false), SelectedEyeColor(color: "brown", isSelected: false), SelectedEyeColor(color: "yellow", isSelected: false), SelectedEyeColor(color: "darkRed", isSelected: false),SelectedEyeColor(color: "gray", isSelected: false),SelectedEyeColor(color: "emeraldGreen", isSelected: false)]

class AvatarSideBar: UIView {
    var results: Results<User>!
    //MARK: - Properties
    let db = Firestore.firestore()
    lazy var saveButton: UIView = {
        let button = UIView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.width(saveButtonWidth)
           button.height(saveButtonWidth)
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        label.isUserInteractionEnabled = true
        label.text = "SA\nVE"
        label.numberOfLines = 2
        label.font = UIFont(name: "Menlo-Bold",size: saveFontSize)
        label.textColor = .white
        label.sizeToFit()
        button.addSubview(label)
        button.layer.cornerRadius = 30
        label.center(in: button)

        button.backgroundColor = brightPurple
        button.applyDesign(color: brightPurple)
  
        return button
    }()
    lazy var hairCollectionView: UICollectionView = {
        let layout = ColumnFlowLayout(cellsPerRow: 1, minimumInteritemSpacing: 5, minimumLineSpacing: 15, sectionInset: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(HairCell.self, forCellWithReuseIdentifier: K.hairCell)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    lazy var colorCollectionView: UICollectionView = {
        let layout = ColumnFlowLayout(cellsPerRow: 4, minimumInteritemSpacing: 15, minimumLineSpacing: 15, sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
           layout.scrollDirection = .horizontal
           let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
           cv.register(AvatarColorCell.self, forCellWithReuseIdentifier: K.avatarColorCell)
           cv.translatesAutoresizingMaskIntoConstraints = false
           cv.showsHorizontalScrollIndicator = false
           return cv
    }()
    lazy var eyeColorCollectionView: UICollectionView = {
        let layout = ColumnFlowLayout(cellsPerRow: 1, minimumInteritemSpacing: 5, minimumLineSpacing: 15, sectionInset: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(EyeColorCell.self, forCellWithReuseIdentifier: K.eyeColorCell)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        return cv
       }()
    lazy var skinColorCollectionView: UICollectionView = {
        let layout = ColumnFlowLayout(cellsPerRow: 1, minimumInteritemSpacing: 5, minimumLineSpacing: 15, sectionInset: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(EyeColorCell.self, forCellWithReuseIdentifier: K.eyeColorCell)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        return cv
       }()
    
    lazy var hairImageViewIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.image = gender == "male" ? UIImage(named: "maleHairIcon") :  UIImage(named: "womanHairIcon")
        iv.backgroundColor = .white
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    lazy var backArrowView: UIImageView = {
          let iv = UIImageView()
          iv.translatesAutoresizingMaskIntoConstraints = false
          iv.contentMode = .scaleAspectFit
          iv.image = UIImage(named: "backArrow")
          iv.backgroundColor = .white
          iv.isUserInteractionEnabled = true
          return iv
      }()
      
    
    lazy var eyeImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.frame.size = CGSize(width: 100, height: 100)
        iv.image = UIImage(named: "eyeIcon")
        iv.backgroundColor = .white
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    lazy var pencilImageView: UIImageView = {
           let iv = UIImageView()
           iv.translatesAutoresizingMaskIntoConstraints = false
           iv.frame.size = CGSize(width: 100, height: 100)
           iv.image = UIImage(named: "pencilIcon")
           iv.backgroundColor = .white
           iv.isUserInteractionEnabled = true
           return iv
       }()
    
    lazy var petImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.frame.size = CGSize(width: 100, height: 100)
        iv.image = UIImage(named: "petIcon")
        iv.backgroundColor = .white
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    lazy var shoeImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.frame.size = CGSize(width: 100, height: 100)
        iv.image = UIImage(named: "converse")
        iv.backgroundColor = .white
        iv.isUserInteractionEnabled = true
        let shoeTapped = UITapGestureRecognizer(target: self, action: #selector(tappedShoe))
        iv.addGestureRecognizer(shoeTapped)
        return iv
    }()
    lazy var skinImageView: UIImageView = {
           let iv = UIImageView()
           iv.translatesAutoresizingMaskIntoConstraints = false
           iv.image = UIImage(named: "skinIcon")
        iv.frame.size = CGSize(width: 100, height: 100)
           iv.backgroundColor = .white
           iv.isUserInteractionEnabled = true
           return iv
       }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        overrideUserInterfaceStyle = .light
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        createStartView()
    }
    
    func createStartView() {
        self.addSubview(pencilImageView)
        pencilImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 140).isActive = true
        pencilImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        pencilImageView.applyDesign(color: .white)
        let pencilTapped = UITapGestureRecognizer(target: self, action: #selector(tappedPencil))
        pencilImageView.addGestureRecognizer(pencilTapped)
        
        self.addSubview(petImageView)
        petImageView.topToBottom(of: pencilImageView,offset: 15)
        petImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        petImageView.applyDesign(color: .white)
        let petTapped = UITapGestureRecognizer(target: self, action: #selector(tappedPet))
        petImageView.addGestureRecognizer(petTapped)

        
        self.addSubview(shoeImageView)
        shoeImageView.topToBottom(of: petImageView,offset: 15)
        shoeImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        shoeImageView.applyDesign(color: .white)
         
    }
    
    //MARK: - Helper Functions
    private final func createFeatures() {
        self.addSubview(backArrowView)
        backArrowView.topAnchor.constraint(equalTo: self.topAnchor, constant: 140).isActive = true
        backArrowView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        backArrowView.applyDesign(color: .white)
        let backTapped = UITapGestureRecognizer(target: self, action: #selector(tappedBack))
        backArrowView.addGestureRecognizer(backTapped)
        
        
        self.addSubview(hairImageViewIcon)
        hairImageViewIcon.topToBottom(of: backArrowView,offset: 15)
        hairImageViewIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        hairImageViewIcon.applyDesign(color: .white)
        let hairTapped = UITapGestureRecognizer(target: self, action: #selector(tappedHair))
        hairImageViewIcon.addGestureRecognizer(hairTapped)
        
        self.addSubview(eyeImageView)
        eyeImageView.topToBottom(of: hairImageViewIcon,offset: 15)
        eyeImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        eyeImageView.applyDesign(color: .white)
        let eyeTapped = UITapGestureRecognizer(target: self, action: #selector(tappedEye))
        eyeImageView.addGestureRecognizer(eyeTapped)
        
        self.addSubview(skinImageView)
        skinImageView.topToBottom(of: eyeImageView,offset: 15)
        skinImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        skinImageView.applyDesign(color: .white)
        let skinTapped = UITapGestureRecognizer(target: self, action: #selector(tappedSkin))
        skinImageView.addGestureRecognizer(skinTapped)
               
    }
    
    private final func createHairCollectionView() {
        backArrowView.removeFromSuperview()
        hairCollectionView.delegate = self
        hairCollectionView.dataSource = self
        self.addSubview(hairCollectionView)
        hairCollectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 140).isActive = true
        hairCollectionView.backgroundColor = backgroundColor
        hairCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        hairCollectionView.width(self.frame.width * 0.20)
        hairCollectionView.height(self.frame.height * 0.60)
        createSaveButton()
    }
    
    private final func createEyeColorCollectionView() {
        eyeColorCollectionView.delegate = self
        eyeColorCollectionView.dataSource = self
        self.addSubview(eyeColorCollectionView)
        eyeColorCollectionView.topToBottom(of: eyeImageView, offset: 15)
        eyeColorCollectionView.backgroundColor = backgroundColor
        eyeColorCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        eyeColorCollectionView.width(self.frame.width * 0.20)
        eyeColorCollectionView.height(self.frame.height * skinMultiplier)
        createSaveButton()
    }
    
    private final func createSkinColorCollectionView() {
        skinColorCollectionView.delegate = self
        skinColorCollectionView.dataSource = self
        self.addSubview(skinColorCollectionView)
        skinColorCollectionView.topToBottom(of: skinImageView, offset: 15)
        skinColorCollectionView.backgroundColor = backgroundColor
        skinColorCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        skinColorCollectionView.width(self.frame.width * 0.20)
        skinColorCollectionView.height(self.frame.height * skinMultiplier
        )
        createSaveButton()
    }
    
    private final func createSaveButton() {
        self.addSubview(saveButton)
        saveButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: saveButtonPadding).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        let saveTapped = UITapGestureRecognizer(target: self, action: #selector(tappedSave))
               saveButton.addGestureRecognizer(saveTapped)
    }
    
    private func createColorCollectionView() {
        if selectedHair != "none" {
            if selectedHairColor == "" {
                selectedHairColor = "black"
                hairColors[0].isSelected = true
                updateOtherImages(num: 0, array: hairColors, type: "hairColors")
                createColorCollectionViewSlower()
                colorCollectionView.reloadData()
            } else {
                createColorCollectionViewSlower()
            }
        }
    }
    
    private final func createColorCollectionViewSlower() {
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        self.addSubview(colorCollectionView)
        colorCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        colorCollectionView.backgroundColor = backgroundColor
        colorCollectionView.width(self.frame.width * 0.70)
        colorCollectionView.height(self.frame.height * 0.10)
        colorCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: colorCollectionPadding).isActive = true
    }
    
    //MARK: - Handlers
    @objc func tappedPencil() {
        if level >= 34 {
            pencilImageView.removeFromSuperview()
            petImageView.removeFromSuperview()
            shoeImageView.removeFromSuperview()
            createFeatures()
        } else {
            let appearance = SCLAlertView.SCLAppearance(
                kWindowWidth: 300,
                kWindowHeight:200,
                kButtonHeight: 50,
                kTitleFont: UIFont(name: "Menlo-Bold", size: 25)!,
                kTextFont: UIFont(name: "Menlo", size: 15)!,
                showCloseButton: false,
                showCircularIcon: false,
                hideWhenBackgroundViewIsTapped: true,
                titleColor: brightPurple
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("Got it", backgroundColor: brightPurple, textColor: .white, showTimeout: .none) {
                       return
                   }
            alertView.showCustom("More Work Has To Be Done!", subTitle: "You must be level 34 in order to customize your avatar", color: .white, icon: UIImage())

        }
     }
     
     @objc func tappedShoe() {
        menuLabel = "Closet"
        shoes = true
        let controller = ContainerController(center: InventoryController(whichTab: "shoes"))
        controller.modalPresentationStyle = .fullScreen
        var topVC = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.rootViewController
        while((topVC!.presentedViewController) != nil){
             topVC = topVC!.presentedViewController
        }
        topVC!.present(controller,animated: true,completion: nil)
    

     }
    
    @objc func tappedPet() {
        pets = true
        menuLabel = "Pets"
        let controller = ContainerController(center: InventoryController(whichTab: "pets"))
         controller.modalPresentationStyle = .fullScreen

         var topVC = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.rootViewController
         while((topVC!.presentedViewController) != nil){
              topVC = topVC!.presentedViewController
         }
         topVC!.present(controller,animated: true,completion: nil)
           NotificationCenter.default.post(name: Notification.Name(rawValue: petsKey), object: nil)

    }
    
    @objc func tappedSkin() {
        hairImageViewIcon.removeFromSuperview()
        eyeImageView.removeFromSuperview()
        skinImageView.removeFromSuperview()
        backArrowView.removeFromSuperview()
        self.addSubview(skinImageView)
        skinImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 140).isActive = true
        skinImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        skinImageView.applyDesign(color: .white)
        createSkinColorCollectionView()
        createSaveButton()
    }
    
    @objc func tappedBack() {
        hairImageViewIcon.removeFromSuperview()
        eyeImageView.removeFromSuperview()
        colorCollectionView.removeFromSuperview()
        eyeColorCollectionView.removeFromSuperview()
        hairCollectionView.removeFromSuperview()
        saveButton.removeFromSuperview()
        skinImageView.removeFromSuperview()
        createStartView()
    }
     
     @objc func tappedEye() {
         hairImageViewIcon.removeFromSuperview()
         eyeImageView.removeFromSuperview()
            skinImageView.removeFromSuperview()
        backArrowView.removeFromSuperview()
         self.addSubview(eyeImageView)
        eyeImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 140).isActive = true
         eyeImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
         eyeImageView.applyDesign(color: .white)
        createEyeColorCollectionView()
        createSaveButton()
     }
     
     @objc func tappedHair() {
         hairImageViewIcon.removeFromSuperview()
         eyeImageView.removeFromSuperview()
        skinImageView.removeFromSuperview()
         createColorCollectionView()
         createHairCollectionView()
    }
     
     @objc func tappedSave() {
         hairCollectionView.removeFromSuperview()
         saveButton.removeFromSuperview()
         colorCollectionView.removeFromSuperview()
        eyeImageView.removeFromSuperview()
        eyeColorCollectionView.removeFromSuperview()
        skinColorCollectionView.removeFromSuperview()
        skinImageView.removeFromSuperview()
         saveToRealm()
         createFeatures()
     }
    
    
    private func saveToRealm() {
        results = uiRealm.objects(User.self)
        for result  in results {
            if result.isLoggedIn == true {
                do {
                    try uiRealm.write {
    
                        result.setValue("\(selectedHairColor)+\(selectedHair)", forKey:"hair")
                        result.setValue("\(selectedEyeColor)", forKey: "eyes")
                        result.setValue(skinColor, forKey: "skin")
                    }
                } catch {
                    print(error)
                }
            }
        }
        saveToFirebase()
    }
    
    private final func saveToFirebase() {
        if !UserDefaults.standard.bool(forKey: "noLogin") && UserDefaults.standard.bool(forKey: "isPro") {
            if let _ = Auth.auth().currentUser?.email {
                let email = Auth.auth().currentUser?.email
                self.db.collection(K.userPreferenes).document(email!).updateData([
                    "hair": "\(selectedHairColor)+\(selectedHair)",
                    "eyes": "\(selectedEyeColor)",
                    "skin": "\(skinColor)"
                ]) { (error) in
                    if let e = error {
                        print("There was a issue saving data to firestore \(e) ")
                    } else {
                        print("Succesfully saved new items")
                    }
                }
            }
        }
    }
}


extension AvatarSideBar: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.hairCollectionView {
            return gender == "male" ? maleHairImages.count : femaleHairImages.count
        } else if collectionView == self.colorCollectionView{
            return hairColors.count
        } else if collectionView == self.eyeColorCollectionView {
            return eyeColors.count
        } else if collectionView == self.skinColorCollectionView {
            return skinColors.count
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.hairCollectionView {
            if gender == "male" {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.hairCell, for: indexPath) as! HairCell
                cell.setImage(image: maleHairImages[indexPath.row].name)
                cell.setBorder(border: maleHairImages[indexPath.row].isSelected)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.hairCell, for: indexPath) as! HairCell
                cell.setImage(image: femaleHairImages[indexPath.row].name)
                cell.setBorder(border: femaleHairImages[indexPath.row].isSelected)
                return cell
            }
        } else if collectionView == self.colorCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.avatarColorCell, for: indexPath) as! AvatarColorCell
            cell.setColor(color: hairColors[indexPath.row].color)
            cell.setBorder(border: hairColors[indexPath.row].isSelected)
            return cell
        } else if collectionView == self.eyeColorCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.eyeColorCell, for: indexPath) as! EyeColorCell
            cell.setColor(color: eyeColors[indexPath.row].color)
            cell.setBorder(border: eyeColors[indexPath.row].isSelected)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.eyeColorCell, for: indexPath) as! EyeColorCell
            cell.setColor(color: skinColors[indexPath.row].color)
            cell.setBorder(border: skinColors[indexPath.row].isSelected)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.hairCollectionView {
            if gender == "male" {
                maleHairImages[indexPath.row].isSelected = true
                selectedHair = maleHairImages[indexPath.row].name
                if maleHairImages[indexPath.row].name == "none" {
                    colorCollectionView.removeFromSuperview()
                    selectedHairColor = ""
                    hairImageView.image = UIImage()
                } else  {
                    if !colorCollectionView.isDescendant(of: self) {
                        selectedHairColor = ""
                        createColorCollectionView()
                    }
                    //IPAD START
                    if selectedHair == "defaultManHair" || selectedHair == "manHair2" && UIDevice().userInterfaceIdiom == .pad  {
                        hairMultiplier = 1
                        hairImageView.removeFromSuperview()
                        if gender == "male" {
                            characterBackground.insertSubview(hairImageView, aboveSubview: faceImageView)
                            hairImageView.centerX(to: characterBackground)
                            hairImageView.topAnchor.constraint(equalTo: petLabel.bottomAnchor, constant: avatarHairPadding).isActive = true
                            hairImageView.widthAnchor.constraint(equalTo: self.superview!.widthAnchor, multiplier: avatarMultipler * hairMultiplier).isActive = true
                            hairImageView.heightAnchor.constraint(equalTo: self.superview!.heightAnchor, multiplier: avatarMultipler * hairMultiplier - 0.0225 ).isActive = true
                        }
                    } else if UIDevice().userInterfaceIdiom == .pad {
                        var subtractPadding:CGFloat = 0
                        switch UIScreen.main.nativeBounds.height {
                        case 2388:
                            hairMultiplier = 1.3
                            subtractPadding = 15
                            
                        default:
                            hairMultiplier = 1.4
                            subtractPadding = 30
                            
                        }
                        hairImageView.removeFromSuperview()
                        if gender == "male" {
                            characterBackground.insertSubview(hairImageView, aboveSubview: faceImageView)
                            hairImageView.centerX(to: characterBackground)
                            hairImageView.topAnchor.constraint(equalTo: petLabel.bottomAnchor, constant: avatarHairPadding - subtractPadding).isActive = true
                            hairImageView.widthAnchor.constraint(equalTo: self.superview!.widthAnchor, multiplier: avatarMultipler * hairMultiplier).isActive = true
                            hairImageView.heightAnchor.constraint(equalTo: self.superview!.heightAnchor, multiplier: avatarMultipler * hairMultiplier - 0.0225 ).isActive = true
                        }
                    }
                    //IPAD END
                    hairImageView.image = UIImage(named: selectedHair)
                    if selectedHairColor == "" {
                        hairImageView.image = hairImageView.image?.withRenderingMode(.alwaysTemplate)
                        hairImageView.tintColor = black
                    } else {
                        hairImageView.image = hairImageView.image?.withRenderingMode(.alwaysTemplate)
                        hairImageView.tintColor = K.getAvatarColor(selectedHairColor)
                    }
                }
                updateOtherImages(num: indexPath.row, array: maleHairImages, type: "maleHairImages")
            } else {
                femaleHairImages[indexPath.row].isSelected = true
                selectedHair = femaleHairImages[indexPath.row].name
                if selectedHair == "none" {
                    colorCollectionView.removeFromSuperview()
                    selectedHairColor = ""
                    hairImageView.image = UIImage()
                } else {
                    if !colorCollectionView.isDescendant(of: self) {
                        selectedHairColor = ""
                        createColorCollectionView()
                    }
                    hairImageView.image = UIImage(named: "blonde+defaultWomanHair")
                    if selectedHairColor == "" {
                        hairImageView.image = UIImage(named: "black+defaultWomanHair")
                    } else {
                        hairImageView.image = UIImage(named: "\(selectedHairColor)+\(selectedHair)")
                    }
                }
                  updateOtherImages(num: indexPath.row, array: femaleHairImages, type: "femaleHairImages")
            }
          
        } else if collectionView == self.colorCollectionView {
            hairColors[indexPath.row].isSelected = true
            selectedHairColor = hairColors[indexPath.row].color
            if gender == "male" {
                hairImageView.image = UIImage(named: selectedHair)
                hairImageView.image = hairImageView.image?.withRenderingMode(.alwaysTemplate)
                hairImageView.tintColor = K.getAvatarColor(selectedHairColor)
            } else {
                print("\(selectedHairColor)+\(selectedHair)")
                hairImageView.image = UIImage(named: "\(selectedHairColor)+\(selectedHair)")
            }
           
            self.superview!.setNeedsDisplay()
            updateOtherImages(num: indexPath.row, array: hairColors, type: "hairColors")
        } else if collectionView == self.eyeColorCollectionView {
            eyeColors[indexPath.row].isSelected = true
            selectedEyeColor = eyeColors[indexPath.row].color
            eyesImageView.image = eyesImageView.image?.withRenderingMode(.alwaysTemplate)
            eyesImageView.tintColor =  K.getAvatarColor(selectedEyeColor)
            updateOtherImages(num: indexPath.row, array: eyeColors, type: "eyeColors")
        } else if collectionView == self.skinColorCollectionView {
            skinColors[indexPath.row].isSelected = true
            skinColor = skinColors[indexPath.row].color
            faceImageView.image = gender == "female" ? UIImage(named: "\(skinColor)+womanFace") : UIImage(named: "\(skinColor)+manFace")
            armsImageView.image = UIImage(named: "\(skinColor)+womanArms")
            updateOtherImages(num: indexPath.row, array: skinColors, type: "skinColors")
        }

        collectionView.reloadData()
    }
    func updateOtherImages(num: Int, array: [Any], type: String) {
        for (i,_) in array.enumerated(){
            if i == num {
                continue
            } else {
                if type == "maleHairImages" {
                    maleHairImages[i].isSelected = false
                } else if type == "hairColors" {
                    hairColors[i].isSelected = false
                } else if type == "eyeColors" {
                    eyeColors[i].isSelected = false
                } else if type == "femaleHairImages" {
                    femaleHairImages[i].isSelected = false
                } else if type == "skinColors" {
                    skinColors[i].isSelected = false
                }
            }
        }
    }
}

