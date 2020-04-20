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

class NameViewController: UIViewController {
    var nameInput = UITextField()
    let nameLabel = UILabel()
    var finishButton = UILabel()
    let db = Firestore.firestore()
    let container: UIView = UIView()
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = lightLavender
        configureNavigationBar(color: backgroundColor, isTrans: true)
           self.navigationItem.setHidesBackButton(true, animated: false)
           UINavigationBar.appearance().barTintColor = lightLavender
           nameLabel.text = "What's your name?"
           nameLabel.textColor = .white
           nameLabel.font = UIFont(name: "Menlo", size: 35)
           nameLabel.center.x = view.center.x - 170
           nameLabel.center.y = view.center.y - 180
           nameLabel.frame.size.width = 400
           nameLabel.frame.size.height = 130
           view.addSubview(nameLabel)
           
           nameInput.placeholder = "Steve"
           view.addSubview(nameInput)
           nameInput.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 25).isActive = true
           nameInput.applyDesign(view, x: -170, y: -30)
           // Do any additional setup after loading the view.
            
            finishButton = UILabel(frame: CGRect(x: view.center.x - 100, y: view.center.y + 240, width: 200, height: 60))
            finishButton.text = "Next"
            finishButton.textAlignment = .center
            view.addSubview(finishButton)
            finishButton.textColor = .white
            finishButton.backgroundColor = brightPurple
            finishButton.font = UIFont(name: "Menlo", size: 25)
            finishButton.clipsToBounds = true
            finishButton.layer.cornerRadius = 25
            let shadowView = UIView(frame: CGRect(x: 105 , y: finishButton.center.y-20 , width: 200, height: 60))
            shadowView.backgroundColor = .clear
            shadowView.layer.cornerRadius = 25
            shadowView.dropShadow(superview: finishButton)
            view.addSubview(shadowView)
            view.insertSubview(finishButton, aboveSubview: shadowView)
             finishButton.isUserInteractionEnabled = true
             let tap = UITapGestureRecognizer(target: self, action: #selector(finishTapped))
             finishButton.addGestureRecognizer(tap)
            
    }

    
    
    @objc func finishTapped() {
        showSpinner()
        if nameInput.text! != "" {
            if let _ = Auth.auth().currentUser?.email {
                let email = Auth.auth().currentUser?.email
                db.collection(K.userPreferenes).document(email!).setData([
                    "gender": chosenGender,
                    "name": nameInput.text!,
                    "coins": 0
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
            saveToRealm()
        } else {
            let alert = UIAlertController(title: "Must input a name!", message:nil, preferredStyle: .alert)       
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            container.removeFromSuperview()
            self.present(alert, animated: true)
        }
    }
    
    func showSpinner() {
        spinner.hidesWhenStopped = true
        container.frame = CGRect(x: 0, y: 0, width: 1000, height: 1000) // Set X and Y whatever you want
        container.backgroundColor = .clear
        spinner.center = self.view.center
        view.addSubview(container)
        container.addSubview(spinner)
        spinner.startAnimating()
    }
    
    func saveToRealm() {
        let UserToAdd = User()
        UserToAdd.gender = chosenGender
        UserToAdd.name = nameInput.text!
        UserToAdd.email = Auth.auth().currentUser?.email
        UserToAdd.coins = 0
        UserToAdd.isLoggedIn = true
        loggedOut = false
        UserToAdd.writeToRealm()
    }
    
}
