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
        label.font = UIFont(name: "Menlo-Bold", size: 20)
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
        characterBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        characterBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        characterBackground.addSubview(avatarImageView)
        
        characterBackground.addSubview(petLabel)
        characterBackground.addSubview(petImageView)
        petLabel.text = "Selected Pet: "
        petLabel.topAnchor.constraint(equalTo: characterBackground.topAnchor, constant: 40).isActive = true
        petLabel.leadingAnchor.constraint(equalTo: characterBackground.leadingAnchor, constant: 20).isActive = true
        
        petImageView.topAnchor.constraint(equalTo: characterBackground.topAnchor, constant: 30).isActive = true
        petImageView.trailingAnchor.constraint(equalTo: characterBackground.trailingAnchor, constant: -20).isActive = true
        
        avatarImageView.bottomAnchor.constraint(equalTo: characterBackground.bottomAnchor, constant: -30).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: characterBackground.topAnchor, constant: 30).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: characterBackground.leadingAnchor, constant: 15).isActive = true
        avatarImageView.trailingAnchor.constraint(equalTo: characterBackground.trailingAnchor, constant: -15).isActive = true
        
        typeLabel.text = "Type: \(type)"
        characterBackground.addSubview(typeLabel)
        typeLabel.leadingAnchor.constraint(equalTo: characterBackground.leadingAnchor, constant: 30).isActive = true
        typeLabel.trailingAnchor.constraint(equalTo: characterBackground.trailingAnchor, constant: -30).isActive = true
        typeLabel.bottomAnchor.constraint(equalTo: characterBackground.bottomAnchor, constant: -30).isActive = true

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
