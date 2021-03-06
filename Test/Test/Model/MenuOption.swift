//
//  MenuOption.swift
//  Test
//
//  Created by Dante Kim on 4/8/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//
import UIKit
enum MenuOption: Int {
    case timer
    case store
    case avatar
    case statistics
    case inventory
    case settings
    case goPro
    var description: String {
        switch self {
        case .timer: return "Timer"
        case .store: return "Store"
        case .avatar: return "Avatar"
        case .statistics: return "Statistics"
        case .inventory: return "Inventory"
        case .settings: return "Settings"
        case .goPro: return "Go Pro!"
        }
    }
    
    var image: UIImage {
         switch self {
         case .timer: return UIImage(named: "clockicon") ?? UIImage()
         case .store: return UIImage(named: "carticon") ?? UIImage()
         case .avatar: return UIImage(named: "personicon") ?? UIImage()
         case .statistics: return UIImage(named: "statsicon") ?? UIImage()
         case .inventory: return UIImage(named: "chesticon") ?? UIImage()
         case .settings: return UIImage(named: "gearicon") ?? UIImage()
         case .goPro: return UIImage(named: "goldIcon")?.resized(to: CGSize(width: 35, height: 35)) ?? UIImage()
         }
     }
}
