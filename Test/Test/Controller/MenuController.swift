//
//  MenuController.swift
//  Test
//
//  Created by Dante Kim on 4/8/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit

enum MenuType: Int {
    case timer
    case store
    case avatar
    case statistics
    case inventory
    case settings
}

class MenuController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        // Do any additional setup after loading the view.
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else { return }
        dismiss(animated: true) {
            print("\(menuType) dismissed")
        }
    }
    
}
