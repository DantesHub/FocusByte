//
//  Alert.swift
//  Test
//
//  Created by Dante Kim on 5/24/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import Foundation
import UIKit

struct Alert {
    private static func showBasicAlert(on vc: UIViewController, with title: String, message: String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        return alert
    }
//
    static func showColorAlert(on vc: UIViewController) -> UIAlertController {
        let alert = showBasicAlert(on: vc, with: "Create Tag", message: "")
        return alert
    }
}
