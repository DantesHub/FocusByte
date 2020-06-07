//
//  AvatarController.swift
//  Test
//
//  Created by Dante Kim on 4/19/20.
//  Copyright © 2020 Steve Ink. All rights reserved.

import UIKit
import RealmSwift
var avatarName = ""
var saveFontSize:CGFloat = 20
var saveButtonPadding:CGFloat = -140
var saveButtonWidth: CGFloat = 80
var avatarArmWidth: CGFloat = 1.7
var avatarBottomPadding:CGFloat = -30
var colorCollectionPadding: CGFloat = -100
var petSize: CGFloat = 100
var frameWidth: CGFloat = 70
//135 x 112
//135 x 87
   var armsImageView: UIImageView = {
      let iv = UIImageView()
      iv.translatesAutoresizingMaskIntoConstraints = false
      iv.contentMode = .scaleAspectFit
      iv.image = gender == "male" ? UIImage(named: "womanArms") : UIImage(named: "womanArms")
      iv.clipsToBounds = false
      return iv
  }()
//113 x 118
  var faceImageView: UIImageView = {
     let iv = UIImageView()
     iv.translatesAutoresizingMaskIntoConstraints = false
     iv.image = gender == "male" ? UIImage(named: "manFace") : UIImage(named: "womanFace")
     iv.clipsToBounds = false
     iv.backgroundColor = .clear
     return iv
 }()
var petImageView: UIImageView = {
    let iv = UIImageView()
    iv.translatesAutoresizingMaskIntoConstraints = false
    iv.contentMode = .scaleAspectFit
    iv.width(petSize)
    iv.height(petSize)
    return iv
}()
var backpackView: UIImageView = {
    let iv = UIImageView()
    iv.translatesAutoresizingMaskIntoConstraints = false
    iv.clipsToBounds = false
    iv.backgroundColor = .clear
    return iv
}()
var hairImageView: UIImageView = {
    let iv = UIImageView()
    iv.translatesAutoresizingMaskIntoConstraints = false
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = false
    iv.image = iv.image?.withRenderingMode(.alwaysTemplate)
    return iv
}()
var eyesImageView: UIImageView = {
    let iv = UIImageView()
    iv.translatesAutoresizingMaskIntoConstraints = false
    iv.width(max:175)
    iv.height(max: 45)
    iv.image = UIImage(named: "eyes")
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = false
    return iv
}()
//shoes 175 x 45
var shoesImageView: UIImageView = {
    let iv = UIImageView()
    iv.translatesAutoresizingMaskIntoConstraints = false
    iv.width(max:175)
    iv.height(max: 45)
    iv.image = UIImage(named: "default shoes")
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = false
    iv.backgroundColor = .clear
    return iv
}()
var gender = ""
var evolveLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont(name: "Menlo", size: 15)
    let evolveLevel = level < 15 ? "15" : "34"
    label.text = "You Evolve at level: \(evolveLevel)"
    return label
}()
//265x235
var sweaterImageView: UIImageView = {
    let iv = UIImageView()
    iv.translatesAutoresizingMaskIntoConstraints = false
    iv.width(max:265)
    iv.height(max: 235)
    iv.image = UIImage(named: "green sweater")
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = false
    iv.backgroundColor = .clear
    return iv
}()

//pants 155 x 223
var pantsImageView: UIImageView = {
     let iv = UIImageView()
     iv.translatesAutoresizingMaskIntoConstraints = false
     iv.width(max:155)
     iv.height(max: 223)
     iv.image = UIImage(named: "blue jeans")
     iv.contentMode = .scaleAspectFit
     iv.clipsToBounds = false
     iv.backgroundColor = .clear
     return iv
 }()
var glassesImageView: UIImageView = {
    let iv = UIImageView()
    iv.translatesAutoresizingMaskIntoConstraints = false

    iv.width(frameWidth)
    iv.height(30)
    iv.clipsToBounds = false
    iv.backgroundColor = .clear
    return iv
}()


class AvatarController: UIViewController {
    var avatarMultipler: CGFloat = 0.20
    var avatarArmMultiplier: CGFloat = 0.20
    var avatarHairPadding: CGFloat = -20
    var petLabelSize:CGFloat = 25
    var avatarPantsPadding:CGFloat = 105
    var avatarTopPadding: CGFloat = 0
    var characterBackgroundBottom: CGFloat {
        get {
            var characterBackgroundBottom: CGFloat = 0
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1334:
                    //Iphone 8
                    avatarHairPadding = 0
                    avatarTopPadding = 55
                    petLabelSize = 15
                    avatarPantsPadding = 90
                    avatarArmWidth = 2
                    saveButtonPadding = -75
                    saveButtonWidth = 55
                    saveFontSize = 15
                    avatarArmMultiplier = 0.25
                    avatarBottomPadding = 0
                    petSize = 75
                    characterBackgroundBottom = -80
                    colorCollectionPadding = -70
                case 1920, 2208:
                    avatarHairPadding = 20
                    avatarTopPadding = 80
                    petLabelSize = 15
                    avatarPantsPadding = 95
                    avatarArmWidth = 2
                    saveButtonPadding = -75
                    petSize = 75
                    saveButtonWidth = 55
                    avatarArmMultiplier = 0.24
                    avatarBottomPadding = 0
                    saveFontSize = 15
                    colorCollectionPadding = -70
                    characterBackgroundBottom = -80
                //("iphone 8plus")
                case 2436:
                    avatarHairPadding = 40
                    avatarTopPadding = 105
                    petLabelSize = 16.5
                    avatarPantsPadding = 90
                    avatarArmWidth = 1.7
                    colorCollectionPadding = -100
                    characterBackgroundBottom = -100
                //print("IPHONE X, IPHONE XS, IPHONE 11 PRO")
                case 2688:
                    avatarHairPadding = 50
                    avatarTopPadding = 125
                    petLabelSize = 20
                    avatarPantsPadding = 100
                    avatarArmWidth = 1.65
                    colorCollectionPadding = -100
                    characterBackgroundBottom = -110
                //print("IPHONE XS MAX, IPHONE 11 PRO MAX")
                case 1792:
                    avatarHairPadding = 50
                    avatarTopPadding = 125
                    petLabelSize = 20
                    avatarArmWidth = 1.65
                    avatarPantsPadding = 100
                    colorCollectionPadding = -100
                    characterBackgroundBottom = -110
                //print("IPHONE XR, IPHONE 11")
                default:
                    print("ipad")
                }
            }
            return characterBackgroundBottom
        }
    }
    //MARK: - properties
    var results: Results<User>!
    var name: String?
    var type = ""
    //    Int((pow(Double(exp), 1.0/3.0)))
    var lvlData: Int = 0
    var avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = false
        iv.backgroundColor = .clear
        return iv
    }()

    lazy var petLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    var delegate: ContainerControllerDelegate!
    lazy var levelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Menlo-Bold", size: 33)
        label.textColor = .white
        
        return label
    }()

    //eye level
 
    
    lazy var experienceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Menlo-Bold", size: 25)
        label.textColor = .white
        label.text = "Experience:"
        return label
    }()
    lazy var experienceBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        let levelNow = floor(sqrt(Double(exp)))
        let left = Double(exp) - pow(levelNow, 2.0)
        let right = pow(levelNow + 1, 2.0) - pow(levelNow, 2.0)
        progressView.setProgress((Float(left)/Float(right)), animated: false)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = brightPurple
        progressView.progressViewStyle = .bar
        progressView.trackTintColor = .white
        progressView.tintColor = .white
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 8)
        return progressView
    }()
    lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Menlo-Bold", size: 15)
        label.textColor = .black
        
        return label
    }()
    lazy var sideBar = AvatarSideBar()
    var characterBackground: UIView!
    
    //MARK: - init
    override func viewDidLoad() {
        getRealmData()
        super.viewDidLoad()
        configureNavigationBar(color: backgroundColor, isTrans: false)
        configureUI()
        view.backgroundColor = backgroundColor
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    //MARK: - Helper functions
    func configureUI() {
        getType()
        self.title = name
        navigationItem.leftBarButtonItem =  UIBarButtonItem(image: resizedMenuImage?.withTintColor(.white), style: .plain, target: self, action: #selector(handleMenuToggle))
        view.addSubview(levelLabel)
        view.addSubview(experienceLabel)
        view.addSubview(experienceBar)
        
        
        
        
        //make label 2 different colors
        let lvlString: String = "Level: \(lvlData)"
        let myMutableString = NSMutableAttributedString(string: lvlString, attributes: [NSAttributedString.Key.font:UIFont(name: "Menlo-Bold", size: 35)!])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: brightPurple, range: NSRange(location:7,length: lvlString.count-7))
        levelLabel.attributedText = myMutableString
        levelLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        levelLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        experienceLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 10).isActive = true
        experienceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        experienceBar.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 23).isActive = true
        experienceBar.leadingAnchor.constraint(equalTo: experienceLabel.trailingAnchor, constant: 10).isActive = true
        experienceBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        if level < 34 {
            view.addSubview(evolveLabel)
            evolveLabel.topToBottom(of: experienceLabel, offset: 5)
            evolveLabel.leadingAnchor.constraint(equalTo:
                view.leadingAnchor, constant: 20).isActive = true
        }
        
        characterBackground = UIView()
        view.addSubview(characterBackground)
        characterBackground.translatesAutoresizingMaskIntoConstraints = false
        characterBackground.layer.masksToBounds = false
        characterBackground.layer.cornerRadius = 25
        characterBackground.layer.shadowOpacity = 0.4
        characterBackground.layer.shadowColor = UIColor.black.cgColor
        characterBackground.layer.shadowOffset = CGSize(width: 8, height: 8)
        characterBackground.layer.shadowRadius = 8
        characterBackground.backgroundColor = superLightLavender
        characterBackground.topAnchor.constraint(equalTo: experienceLabel.bottomAnchor, constant: 40).isActive = true
        characterBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        characterBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true
        characterBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:characterBackgroundBottom).isActive = true
        characterBackground.addSubview(petLabel)
        characterBackground.addSubview(petImageView)
        if lvlData < 34 {
            characterBackground.addSubview(avatarImageView)
            avatarImageView.bottomAnchor.constraint(equalTo: characterBackground.bottomAnchor, constant: avatarBottomPadding).isActive = true
//            avatarImageView.topAnchor.constraint(equalTo: characterBackground.topAnchor, constant: 30).isActive = true
            avatarImageView.leadingAnchor.constraint(equalTo: characterBackground.leadingAnchor, constant: 15).isActive = true
            avatarImageView.trailingAnchor.constraint(equalTo: characterBackground.trailingAnchor, constant: -15).isActive = true
        } else {
            //face
            characterBackground.insertSubview(faceImageView, aboveSubview: characterBackground)
            faceImageView.centerX(to: characterBackground)
            faceImageView.topAnchor.constraint(equalTo: petLabel.bottomAnchor, constant: avatarTopPadding).isActive = true
            if gender == "male" {
                faceImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: avatarMultipler).isActive = true
            } else {
                faceImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: avatarMultipler).isActive = true
            }
            
            faceImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: avatarMultipler + 0.01).isActive = true
            
            //eyes
            faceImageView.addSubview(eyesImageView)
            eyesImageView.centerX(to: faceImageView)
            eyesImageView.topAnchor.constraint(equalTo: faceImageView.topAnchor, constant: 25).isActive = true
            eyesImageView.widthAnchor.constraint(equalTo: faceImageView.widthAnchor, multiplier: 0.55).isActive = true
            eyesImageView.heightAnchor.constraint(equalTo: faceImageView.heightAnchor, multiplier: 0.20).isActive = true
            
            
            //pants
            characterBackground.insertSubview(pantsImageView, aboveSubview: characterBackground)
            pantsImageView.centerX(to: characterBackground)
            if gender == "male" {
                pantsImageView.centerYAnchor.constraint(equalTo: characterBackground.centerYAnchor, constant: avatarPantsPadding).isActive = true
                pantsImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: avatarMultipler * 0.90).isActive = true
                pantsImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: avatarMultipler * 0.90 * 1.2).isActive = true
            } else {
                pantsImageView.centerYAnchor.constraint(equalTo: characterBackground.centerYAnchor, constant: avatarPantsPadding + 10).isActive = true
                pantsImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: avatarMultipler * 0.90).isActive = true
                pantsImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: avatarMultipler * 0.90 * 1.2).isActive = true
            }
      
            
            //backpack
            characterBackground.addSubview(backpackView)
            backpackView.leadingAnchor.constraint(equalTo: characterBackground.leadingAnchor, constant: 20).isActive = true
            backpackView.bottomAnchor.constraint(equalTo: characterBackground.bottomAnchor, constant: -50).isActive = true
            
            //arms
            characterBackground.insertSubview(armsImageView, aboveSubview: characterBackground)
            armsImageView.centerX(to: characterBackground)
            if gender == "male" {
                armsImageView.centerYAnchor.constraint(equalTo: characterBackground.centerYAnchor, constant: 25).isActive = true
                armsImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: avatarArmMultiplier * 1.6).isActive = true
                armsImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: avatarArmMultiplier * 1.6 * 0.40).isActive = true
            } else {
                armsImageView.centerYAnchor.constraint(equalTo: characterBackground.centerYAnchor, constant: 30).isActive = true
                armsImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: avatarMultipler * avatarArmWidth).isActive = true
                armsImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: avatarMultipler * avatarArmWidth * 0.40).isActive = true
            }
            
            
            //sweater
            if gender == "male"
            {
                characterBackground.insertSubview(sweaterImageView, aboveSubview: characterBackground)
                sweaterImageView.centerX(to: characterBackground)
                sweaterImageView.centerYAnchor.constraint(equalTo: characterBackground.centerYAnchor, constant: 15).isActive = true
                sweaterImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: avatarMultipler * 1.4).isActive = true
                sweaterImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: avatarMultipler * 1.4 * 0.95).isActive = true
            } else {
                characterBackground.insertSubview(sweaterImageView, aboveSubview: characterBackground)
                sweaterImageView.centerX(to: characterBackground)
                sweaterImageView.centerYAnchor.constraint(equalTo: characterBackground.centerYAnchor, constant: 25).isActive = true
                sweaterImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: avatarMultipler * 1.5).isActive = true
                sweaterImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: avatarMultipler * 1.5 * 0.95).isActive = true
            }
            
            
            
            //hair
            characterBackground.insertSubview(hairImageView, aboveSubview: faceImageView)
            hairImageView.centerX(to: characterBackground)
            if gender == "male" {
                hairImageView.topAnchor.constraint(equalTo: petLabel.bottomAnchor, constant: avatarHairPadding).isActive = true
                hairImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: avatarMultipler).isActive = true
            } else {
                hairImageView.topAnchor.constraint(equalTo: petLabel.bottomAnchor, constant: avatarHairPadding + 30).isActive = true
                hairImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: avatarMultipler + 0.080).isActive = true
            }
              hairImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: avatarMultipler - 0.0225).isActive = true
    
          
            
            //shoes
            characterBackground.insertSubview(shoesImageView, aboveSubview: characterBackground)
            shoesImageView.centerX(to: characterBackground)
            shoesImageView.topToBottom(of: pantsImageView, offset: -12)
            shoesImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: avatarMultipler).isActive = true
            shoesImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: avatarMultipler * 0.25).isActive = true
            
            //glasses
             characterBackground.insertSubview(glassesImageView, aboveSubview: hairImageView)
             glassesImageView.centerX(to: faceImageView)
             glassesImageView.topAnchor.constraint(equalTo: faceImageView.topAnchor, constant: 20).isActive = true
             
        }
        
 
        
        //
        //type label
        typeLabel.text = "Type: \(type)"
        characterBackground.addSubview(typeLabel)
        typeLabel.leadingAnchor.constraint(equalTo: characterBackground.leadingAnchor, constant: 30).isActive = true
        typeLabel.trailingAnchor.constraint(equalTo: characterBackground.trailingAnchor, constant: -30).isActive = true
        typeLabel.bottomAnchor.constraint(equalTo: characterBackground.bottomAnchor, constant: -10).isActive = true
        
        petLabel.font = UIFont(name: "Menlo-Bold", size: petLabelSize)
        petLabel.text = "Selected Pet: "
        petLabel.topAnchor.constraint(equalTo: characterBackground.topAnchor, constant: 20).isActive = true
        petLabel.leadingAnchor.constraint(equalTo: characterBackground.leadingAnchor, constant: 20).isActive = true
        
        petImageView.topAnchor.constraint(equalTo: characterBackground.topAnchor, constant: 10).isActive = true
        petImageView.trailingAnchor.constraint(equalTo: characterBackground.trailingAnchor, constant: -20).isActive = true
        
        setUpSideBar()
    }
    
    //MARK: - Helper Functions
    func getRealmData() {
        results = uiRealm.objects(User.self)
        _ = characterBackgroundBottom
        var hair = ""
        var eyeColor = ""
        var pack = ""
        var shirt = ""
        var pants = ""
        var glasses = ""
        var shoe = ""
        var pet = ""
        for result in results {
            if result.isLoggedIn == true {
                name = result.name
                gender = result.gender!
                hair = result.hair!
                eyeColor = result.eyes!
                shirt = result.shirt ?? "none"
                pants = result.pants ?? "none"
                shoe = result.shoes ?? "none"
                pet = result.pet ?? "none"
                glasses = result.glasses ?? "noframe"
                skinColor = result.skin!
                lvlData = Int(pow(Double(result.exp), 1.0/2.0))
                pack = result.backpack ?? "nobag"
                //set experience
            }
        }
        level = lvlData
        if pack != "nobag" {
            backpackView.image = UIImage(named: pack)
        }
        if pet != "none" {
            petImageView.image = UIImage(named: pet)
        }
        if shirt != "none" {
            sweaterImageView.image = UIImage(named: shirt)
        }
        if pants != "none" {
            pantsImageView.image = UIImage(named: pants)
        }
        if shoe != "none" {
            shoesImageView.image = UIImage(named: shoe)
        }
        if glasses != "noframe" {
            glassesImageView.image = UIImage(named: glasses)
        }
        updateHair(hair: hair)
        updateEyes(color: eyeColor)
        updateSkin()
    }
    private func updateSkin() {
        faceImageView.image = gender == "male" ? UIImage(named: "\(skinColor)+manFace") : UIImage(named: "\(skinColor)+womanFace")
        armsImageView.image = UIImage(named: "\(skinColor)+womanArms")
        for (i,color) in skinColors.enumerated() {
            if color.color == skinColor {
                skinColors[i].isSelected = true
            } else {
                skinColors[i].isSelected = false
            }
        }
    }
    
    private func updateEyes(color: String) {
        selectedEyeColor = color
        eyesImageView.image = eyesImageView.image?.withRenderingMode(.alwaysTemplate)
        eyesImageView.tintColor = K.getAvatarColor(selectedEyeColor)
        for (i, color) in eyeColors.enumerated() {
            if color.color == selectedEyeColor {
                eyeColors[i].isSelected = true
            } else {
                eyeColors[i].isSelected = false
            }
        }
    }
    
    private func updateHair(hair: String) {
        let hairPlusIndex = hair.firstIndex(of: "+")
        let hairPlusOffset = hair.index(hairPlusIndex!, offsetBy: 1)
        selectedHairColor = (String(hair[..<hairPlusIndex!]))
        selectedHair = String(hair[hairPlusOffset...])
        if selectedHair != "none" {
            hairImageView.image = UIImage(named: "\(selectedHair)")
            if gender == "male"{
                hairImageView.image = hairImageView.image?.withRenderingMode(.alwaysTemplate)
                hairImageView.tintColor = K.getAvatarColor(selectedHairColor)
            } else {
                hairImageView.image = UIImage(named: "\(selectedHairColor)+\(selectedHair)")
            }
        } else {
            hairImageView.image = UIImage()
        }
    
        updateHairArrays()
    }
    
    private final func updateHairArrays() {
        for (i,color) in hairColors.enumerated() {
            if color.color == selectedHairColor{
                hairColors[i].isSelected = true
            } else {
                hairColors[i].isSelected = false
            }
        }
        
        if gender == "male" {
            for (i,hair) in maleHairImages.enumerated() {
                if hair.name == selectedHair {
                    maleHairImages[i].isSelected = true
                } else {
                    maleHairImages[i].isSelected = false
                }
            }
        } else {
            for (i,hair) in femaleHairImages.enumerated() {
                if hair.name == "\(selectedHair)" {
                    femaleHairImages[i].isSelected = true
                } else {
                    femaleHairImages[i].isSelected = false
                }
            }
        }
        
    }
    
    func setUpSideBar() {
        sideBar = AvatarSideBar(frame: CGRect(x: 0 , y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(sideBar)
        view.isUserInteractionEnabled = true
        sideBar.isUserInteractionEnabled = true
        //if this is false, objc funcs dont work
        sideBar.translatesAutoresizingMaskIntoConstraints = true
        
    }
    
    func getType() {
        switch lvlData {
        case 0...14:
            type = "Toddler"
            avatarImageView.image = gender == "male" ? UIImage(named: "boyToddler") : UIImage(named: "girlToddler")
        case 15...34:
            type = "Kid"
            avatarImageView.image = gender == "male" ? UIImage(named: "boy") : UIImage(named: "boy")
        case 34...:
            type = "Adult"
            avatarImageView.image = gender == "male" ? UIImage(named: "man") : UIImage(named: "woman")
        default: type = ""
        }
    }
    
    //MARK: - Handlers
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
}
