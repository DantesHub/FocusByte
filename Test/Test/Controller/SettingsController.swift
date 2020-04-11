//
//  SettingsController.swift
//  Test
//
//  Created by Dante Kim on 4/9/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
    //MARK: - Properties
    
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Helper functions
    func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = backgroundColor
        navigationController?.navigationBar.prefersLargeTitles = true
    
        navigationItem.title = "Settings"
        navigationController?.navigationBar.barStyle = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
    }

    //MARK: - Handlers
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
}
