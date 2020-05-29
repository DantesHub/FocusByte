//
//  AvatarController.swift
//  Test
//
//  Created by Dante Kim on 4/19/20.
//  Copyright © 2020 Steve Ink. All rights reserved.

import UIKit
import RealmSwift
var avatarName = ""
class AvatarController: UIViewController {
    var avatarMultipler: CGFloat = 0.20
    var avatarHairPadding: CGFloat = -20
    var petLabelSize:CGFloat = 25
    var avatarPantsPadding:CGFloat = 90
    var avatarTopPadding: CGFloat {
        get {
            var avatarTopPadding: CGFloat = 0
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1334:
                    //Iphone 8
                    avatarHairPadding = 0
                    avatarTopPadding = 55
                    petLabelSize = 15
                    avatarPantsPadding = 75
                case 1920, 2208:
                    avatarHairPadding = 20
                    avatarTopPadding = 80
                    petLabelSize = 15
                    avatarPantsPadding = 90
                    //("iphone 8plus")
                case 2436:
                    avatarHairPadding = 50
                    avatarTopPadding = 115
                    petLabelSize = 16.5
                    avatarPantsPadding = 75
                    //print("IPHONE X, IPHONE XS, IPHONE 11 PRO")
                case 2688:
                    avatarHairPadding = 70
                    avatarTopPadding = 145
                    petLabelSize = 20
                    avatarPantsPadding = 85
                    //print("IPHONE XS MAX, IPHONE 11 PRO MAX")
                case 1792:
                    avatarHairPadding = 70
                    avatarTopPadding = 145
                    petLabelSize = 20
                    avatarPantsPadding = 85
                    //print("IPHONE XR, IPHONE 11")
                default:
                    print("ipad")
                }
            }
            return avatarTopPadding
        }
    }
    //MARK: - properties
    var results: Results<User>!
    var name: String?
    var type = ""
    var gender = ""
//    Int((pow(Double(exp), 1.0/3.0)))
    var lvlData: Int = 49
    var avatarImageView: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = false
        iv.backgroundColor = .clear
        return iv
    }()
    var petImageView: UIView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "cat")
        return iv
    }()
    var petLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    var delegate: ContainerControllerDelegate!
    var levelLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Menlo-Bold", size: 33)
        label.textColor = .white
        
        return label
    }()
    //135 x 87
    var armsImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
    
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "man arms")
        iv.clipsToBounds = false
        iv.backgroundColor = .clear
        return iv
    }()
    //113 x 118
    var faceImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
       
        iv.image = UIImage(named: "manhead")
        iv.clipsToBounds = false
        iv.backgroundColor = .clear
        return iv
    }()
    //135 x 112
    var hairImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
       
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "manhair")
        iv.clipsToBounds = false
        iv.backgroundColor = .clear
        return iv
      }()
    
    //265x235
    var sweaterImageView: UIImageView = {
         let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.width(max:265)
        iv.height(max: 235)
        iv.image = UIImage(named: "greensweater")
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = false
        iv.backgroundColor = .clear
        return iv
       }()
    //eye level
    //pants 155 x 223
    var pantsImageView: UIImageView = {
          let iv = UIImageView()
         iv.translatesAutoresizingMaskIntoConstraints = false
         iv.width(max:155)
         iv.height(max: 223)
         iv.image = UIImage(named: "manpants")
         iv.contentMode = .scaleAspectFit
         iv.clipsToBounds = false
         iv.backgroundColor = .clear
         return iv
        }()
    
    //shoes 175 x 45
    var shoesImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.width(max:175)
        iv.height(max: 45)
        iv.image = UIImage(named: "manshoes")
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = false
        iv.backgroundColor = .clear
        return iv
    }()
  
    var experienceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Menlo-Bold", size: 25)
        label.textColor = .white
        label.text = "Experience:"
        return label
    }()
    var experienceBar: UIProgressView = {
       let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.setProgress(0.3, animated: false)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = brightPurple
        progressView.progressViewStyle = .bar
        progressView.trackTintColor = .white
        progressView.tintColor = .white
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 8)
        return progressView
    }()
    var typeLabel: UILabel = {
              let label = UILabel()
              label.translatesAutoresizingMaskIntoConstraints = false
              label.font = UIFont(name: "Menlo-Bold", size: 25)
              label.textColor = .black
             
              return label
          }()
    var characterBackground: UIView!
    
    //MARK: - init
    override func viewDidLoad() {
        getRealmData()
        super.viewDidLoad()
        configureNavigationBar(color: backgroundColor, isTrans: false)
        configureUI()
        view.backgroundColor = backgroundColor
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
        let level: String = "Level: \(lvlData)"
        let myMutableString = NSMutableAttributedString(string: level, attributes: [NSAttributedString.Key.font:UIFont(name: "Menlo-Bold", size: 35)!])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: brightPurple, range: NSRange(location:7,length: level.count-7))
        levelLabel.attributedText = myMutableString
        levelLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        levelLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        experienceLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 10).isActive = true
        experienceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        experienceBar.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 23).isActive = true
        experienceBar.leadingAnchor.constraint(equalTo: experienceLabel.trailingAnchor, constant: 10).isActive = true
        experienceBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
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
        characterBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        characterBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true
        characterBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
//        characterBackground.addSubview(avatarImageView)
        
        characterBackground.addSubview(petLabel)
        characterBackground.addSubview(petImageView)
//
//        avatarImageView.bottomAnchor.constraint(equalTo: characterBackground.bottomAnchor, constant: -30).isActive = true
//        avatarImageView.topAnchor.constraint(equalTo: characterBackground.topAnchor, constant: 30).isActive = true
//        avatarImageView.leadingAnchor.constraint(equalTo: characterBackground.leadingAnchor, constant: 15).isActive = true
//        avatarImageView.trailingAnchor.constraint(equalTo: characterBackground.trailingAnchor, constant: -15).isActive = true
        //        face
        characterBackground.insertSubview(faceImageView, aboveSubview: characterBackground)
        faceImageView.centerX(to: characterBackground)
        faceImageView.topAnchor.constraint(equalTo: petLabel.bottomAnchor, constant: avatarTopPadding).isActive = true
        faceImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: avatarMultipler).isActive = true
        faceImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: avatarMultipler + 0.01).isActive = true
        
        //pants
        characterBackground.insertSubview(pantsImageView, aboveSubview: characterBackground)
        pantsImageView.centerX(to: characterBackground)
        pantsImageView.centerYAnchor.constraint(equalTo: characterBackground.centerYAnchor, constant: avatarPantsPadding).isActive = true
        pantsImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: avatarMultipler * 0.90).isActive = true
        pantsImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: avatarMultipler * 0.90 * 1.2).isActive = true
        
        //arms
         characterBackground.insertSubview(armsImageView, aboveSubview: characterBackground)
         armsImageView.centerX(to: characterBackground)
         armsImageView.centerYAnchor.constraint(equalTo: characterBackground.centerYAnchor, constant: 15).isActive = true
        armsImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: avatarMultipler * 1.40).isActive = true
         armsImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: avatarMultipler * 1.35 * 0.40).isActive = true
        
        //sweater
        characterBackground.insertSubview(sweaterImageView, aboveSubview: characterBackground)
        sweaterImageView.centerX(to: characterBackground)
        sweaterImageView.centerYAnchor.constraint(equalTo: characterBackground.centerYAnchor, constant: 0).isActive = true
        sweaterImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: avatarMultipler * 1.35).isActive = true
        sweaterImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: avatarMultipler * 1.35 * 0.95).isActive = true
        
   

        //hair
        characterBackground.insertSubview(hairImageView, aboveSubview: faceImageView)
        hairImageView.centerX(to: characterBackground)
        hairImageView.topAnchor.constraint(equalTo: petLabel.bottomAnchor, constant: avatarHairPadding).isActive = true
        hairImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: avatarMultipler).isActive = true
        hairImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: avatarMultipler - 0.0225).isActive = true
        
        //shoes
        characterBackground.insertSubview(shoesImageView, aboveSubview: characterBackground)
        shoesImageView.centerX(to: characterBackground)
        shoesImageView.topToBottom(of: pantsImageView, offset: -20)
        shoesImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: avatarMultipler).isActive = true
        shoesImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: avatarMultipler * 0.25).isActive = true
//
        //type label
        typeLabel.text = "Type: \(type)"
        characterBackground.addSubview(typeLabel)
        typeLabel.leadingAnchor.constraint(equalTo: characterBackground.leadingAnchor, constant: 30).isActive = true
        typeLabel.trailingAnchor.constraint(equalTo: characterBackground.trailingAnchor, constant: -30).isActive = true
        typeLabel.bottomAnchor.constraint(equalTo: characterBackground.bottomAnchor, constant: -30).isActive = true
        
        petLabel.font = UIFont(name: "Menlo-Bold", size: petLabelSize)
        petLabel.text = "Selected Pet: "
        petLabel.topAnchor.constraint(equalTo: characterBackground.topAnchor, constant: 20).isActive = true
        petLabel.leadingAnchor.constraint(equalTo: characterBackground.leadingAnchor, constant: 20).isActive = true
        
        petImageView.topAnchor.constraint(equalTo: characterBackground.topAnchor, constant: 10).isActive = true
        petImageView.trailingAnchor.constraint(equalTo: characterBackground.trailingAnchor, constant: -20).isActive = true
    }
    
    //MARK: - Helper Functions
    func getRealmData() {
        results = uiRealm.objects(User.self)
        for result in results {
            if result.isLoggedIn == true {
                name = result.name
                gender = result.gender!
                //set level data
                //set experience
            }
        }
    }
    
    func getType() {
        switch lvlData {
        case 0...19:
            type = "Toddler"
            avatarImageView.image = gender == "male" ? UIImage(named: "boyToddler") : UIImage(named: "girlToddler")
        case 20...48:
            type = "Kid"
            avatarImageView.image = gender == "male" ? UIImage(named: "kidBoy") : UIImage(named: "kidGirl")
        case 49...84:
            type = "Adult"
            avatarImageView.image = gender == "male" ? UIImage(named: "man") : UIImage(named: "woman")
        case 85...100:
            type = "Elder"
        default: type = ""
        }
    }
    
    //MARK: - Handlers
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
}
