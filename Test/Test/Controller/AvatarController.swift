//
//  AvatarController.swift
//  Test
//
//  Created by Dante Kim on 4/19/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit
import RealmSwift
var avatarName = ""
class AvatarController: UIViewController {
    //MARK: - properties
    var delegate: ContainerControllerDelegate!
    var label: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Menlo-Bold", size: 35)
        label.textColor = .white
        label.text = "Testing"
        return label
    }()
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(color: backgroundColor, isTrans: false)
        configureUI()
        view.backgroundColor = backgroundColor
    }
    
    //MARK: - Helper functions
    func configureUI() {
        self.title = "Avatar"
        navigationItem.leftBarButtonItem =  UIBarButtonItem(image: resizedMenuImage?.withTintColor(.white), style: .plain, target: self, action: #selector(handleMenuToggle))
        view.addSubview(label)
       
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    //MARK: - Handlers
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
}
