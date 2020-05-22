//
//  Constants.swift
//  Test
//
//  Created by Dante Kim on 3/29/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import Foundation
import UIKit

let largeConfiguration = UIImage.SymbolConfiguration(weight: .bold)
let menuImage = UIImage(systemName: "line.horizontal.3", withConfiguration: largeConfiguration)
let resizedMenuImage = menuImage?.resized(to: CGSize(width: 35, height: 25)).withTintColor(.white, renderingMode:.alwaysOriginal)
let brightPurple = hexStringToUIColor(hex: "#5351C0")
let lightLavender = hexStringToUIColor(hex: "#ABA9FF")
let commonBoxColor = hexStringToUIColor(hex: "#A73CDE")
let backgroundColor = hexStringToUIColor(hex: "#C7B6F5")
let diamond = hexStringToUIColor(hex: "29d4ff")
let gold = hexStringToUIColor(hex: "fcff00")
let goldBox = hexStringToUIColor(hex: "#ECAF3F")
let darkGold = hexStringToUIColor(hex: "#F7AE03")
let green = hexStringToUIColor(hex: "#196300")
let lightPurple = hexStringToUIColor(hex: "#B99AFF")
let superLightLavender = hexStringToUIColor(hex: "#E3DAFA")
let darkRed = hexStringToUIColor(hex: "#811301")
let darkPurple = hexStringToUIColor(hex:"#5E558A")
let darkGreen = hexStringToUIColor(hex: "#165C12")
let dayKey = "io.focusbyte.day"
let weekKey = "io.focusbyte.week"
let killKey = "io.focusbyte.kill"
let monthKey = "io.focusbyte.month"
let yearKey = "io.focusbyte.year"
var studyTag = Tag(name: "Study", color: "red", selected: false)
var unsetTag = Tag(name: "unset", color: "gray", selected: true)
var readTag = Tag(name: "Read", color: "blue", selected: false)
var workTag = Tag(name: "Work", color: "green", selected: false)



 struct K {
    static let userPreferenes = "userPreferences"
    static let boxCell = "boxCell"
    static let tagCell = "tagCell"
    
    struct FStore {
        static let collectionName = "userPreferences"
    }
    
    static func getColor(color: String) -> UIColor {
        switch color {
        case "blue":
            return UIColor.blue
        case "black":
            return UIColor.black
        case "brown":
            return UIColor.brown
        case "yellow":
            return UIColor.yellow
        case "red":
            return UIColor.red
        case "green":
            return darkGreen
        case "gray":
            return UIColor.gray
        case "purple":
            return brightPurple
        default:
            return UIColor.white
        }
    }
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}



//For some reason this extension gives errors when put
//into the extensions class..xcode bug
extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        var indices: [Index] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                indices.append(range.lowerBound)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return indices
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}

