//
//  NameViewController.swift
//  Test
//
//  Created by Dante Kim on 4/4/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift
import TinyConstraints

class NameViewController: UIViewController {
    //MARK: - Properties
    var nameInput = UITextField()
    let nameLabel = UILabel()
    var finishButton = UILabel()
    let db = Firestore.firestore()
    let container: UIView = UIView()
    var spinner = UIActivityIndicatorView()
    var tagDict = ["unset":"gray", "Study":"red", "Work":"green", "Read":"blue"]
    //MARK: - init
    override func viewDidLoad() {
        if #available(iOS 13, *) {
            spinner = UIActivityIndicatorView(style:  UIActivityIndicatorView.Style.large)
        } else {
            spinner = UIActivityIndicatorView(style:  UIActivityIndicatorView.Style.gray)
        }
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        configureUI()
    }
    
    
    //MARK: - handlers
    @objc func finishTapped() {
        showSpinner()
          let email = Auth.auth().currentUser?.email
   
        if nameInput.text! != "" {
            if let _ = Auth.auth().currentUser?.email {
          db.collection(K.userPreferenes).document(email!).setData([
                    "gender": chosenGender,
                    "name": nameInput.text!,
                    "inventoryArray": ["gray sweater", "blue jeans", "default shoes", "gray cat"],
                    "exp": 1,
                    "coins": 100,
                    "hair": chosenGender == "male" ? "brown+defaultManHair":"blonde+womanHair1",
                    "eyes": "black",
                    "skin": "tan",
                    "tags": tagDict,
                
                ]) { (error) in
                    if let e = error {
                        print("There was a issue saving data to firestore \(e) ")
                    } else {
                        print("Succesfully saved")
                        let timerVC = ContainerController(center: TimerController())
                        self.navigationController?.pushViewController(timerVC, animated: true)
                    }
                }
            }
            UserDefaults.standard.set(false, forKey: "isPro")
            saveToRealm()
        } else {
            let alert = UIAlertController(title: "Must input a name!", message:nil, preferredStyle: .alert)       
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            container.removeFromSuperview()
            self.present(alert, animated: true)
        }
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        configureNavigationBar(color: backgroundColor, isTrans: true)
        self.navigationItem.setHidesBackButton(true, animated: false)
        UINavigationBar.appearance().barTintColor = lightLavender
        nameLabel.text = "What's your\nname?"
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name: "Menlo", size: 35)
        nameLabel.center.x = view.center.x - 200
        nameLabel.center.y = view.center.y - 180
        nameLabel.frame.size.width = 400
        nameLabel.frame.size.height = 130
        view.addSubview(nameLabel)
        
        
        view.addSubview(nameInput)
        nameInput.autocorrectionType = .no
        nameInput.autocapitalizationType = .words
        nameInput.addDoneButtonOnKeyboard()
        nameInput.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 25).isActive = true
        nameInput.applyDesign(view, x: xPadding, y: -30)
        finishButton = UILabel(frame: CGRect(x: view.center.x - 100, y: view.center.y + 240, width: 200, height: 60))
        nameInput.placeholder = "Alex"

        finishButton.text = "Next"
        finishButton.textAlignment = .center
        view.addSubview(finishButton)
        finishButton.textColor = .white
        finishButton.backgroundColor = brightPurple
        finishButton.font = UIFont(name: "Menlo", size: 25)
        finishButton.clipsToBounds = true
        finishButton.layer.cornerRadius = 25
        view.addSubview(finishButton)
        finishButton.isUserInteractionEnabled = true
        finishButton.applyDesign(color: brightPurple)
        let tap = UITapGestureRecognizer(target: self, action: #selector(finishTapped))
        finishButton.addGestureRecognizer(tap)
    }
    
    func showSpinner() {
        spinner.hidesWhenStopped = true
        container.frame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
        container.backgroundColor = .clear
        spinner.center = self.view.center
        view.addSubview(container)
        container.addSubview(spinner)
        spinner.startAnimating()
    }
    
    func saveToRealm() {
        UserDefaults.standard.set(true, forKey: "quotes")
        let itemArray = List<String>()
        itemArray.append("gray sweater")
        itemArray.append("blue jeans")
        itemArray.append("default shoes")
        itemArray.append("gray cat")
        let UserToAdd = User()
        let tagList = List<Tag>()
        tagList.append(unsetTag)
        tagList.append(studyTag)
        tagList.append(workTag)
        tagList.append(readTag)
        UserToAdd.hair = chosenGender == "male" ? "black+defaultManHair":"blonde+womanHair4"
        UserToAdd.eyes = "black"
        UserToAdd.skin = "tan"
        UserToAdd.exp = 1
        UserToAdd.pet = "gray cat"
        UserToAdd.gender = chosenGender
        UserToAdd.inventoryArray = itemArray
        UserToAdd.name = nameInput.text!
        UserToAdd.email = Auth.auth().currentUser?.email
        UserToAdd.tagDictionary = tagList
        UserToAdd.coins = 100
        UserToAdd.deepFocusMode = true
        UserToAdd.isLoggedIn = true
        loggedOut = false
        UserToAdd.writeToRealm()
    }
    
}
