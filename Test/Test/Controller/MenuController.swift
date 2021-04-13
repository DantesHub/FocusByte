//
//  MenuController.swift
//  Test
//
//  Created by Dante Kim on 4/8/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit


private let reuseIdentifer = "MenuOptionCell"

class MenuController: UIViewController {
    //MARK: - Properties
    var tableView: UITableView!
    var delegate: ContainerControllerDelegate!
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    
    //MARK: - Handlers
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuOptionCell.self, forCellReuseIdentifier: reuseIdentifer)
        tableView.backgroundColor = superLightLavender
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.tableView.contentInset = UIEdgeInsets(top: 50,left: 0,bottom: 0,right: 0)

    }
}

extension MenuController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDefaults.standard.bool(forKey: "isPro") ? 6 : 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! MenuOptionCell
        let menuOption = MenuOption(rawValue: indexPath.row)
        cell.descriptionLabel.text = menuOption?.description
        if indexPath.row == 6 {
            cell.descriptionLabel.textColor = darkGold
        }
        cell.iconImageView.image = menuOption?.image
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        let menuOption = MenuOption(rawValue: indexPath.row)
        delegate?.handleMenuToggle(forMenuOption: menuOption)
    }
    
    
}
