//
//  SettingsController.swift
//  Test
//
//  Created by Dante Kim on 4/9/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit
import RealmSwift
var loggedOut = false
class SettingsController: UIViewController {
    //MARK: - Properties
    var results: Results<User>!
    let logOutButton = UIButton()
    
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Helper functions
    func configureUI() {
        configureNavigationBar(color: backgroundColor, isTrans: false)
        view.backgroundColor = backgroundColor
        navigationController?.navigationBar.backgroundColor = backgroundColor
        navigationItem.title = "Settings"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        
        logOutButton.setTitle("Log out", for: .normal)
        logOutButton.titleLabel?.font = UIFont(name: "Menlo-Bold", size: 20)
        logOutButton.titleLabel?.textAlignment = .center
        logOutButton.layer.cornerRadius = 25
        logOutButton.backgroundColor = darkRed
        logOutButton.layoutSubviews()
        view.addSubview(logOutButton)
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logOutButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        logOutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        logOutButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        logOutButton.addTarget(self, action: #selector(logOutPressed), for: .touchUpInside)
    }

    //MARK: - Handlers
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func logOutPressed() {
        results = uiRealm.objects(User.self)
            for result  in results {
                if result.isLoggedIn == true {
                    do {
                        try uiRealm.write {
                            result.setValue(false, forKey: "isLoggedIn")
                            loggedOut = true
                            self.dismiss(animated: true, completion: nil)
                        }
                    } catch {
                        print(error)
                    }                    
                }
            }
    }
    
}

