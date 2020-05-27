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
let gold = hexStringToUIColor(hex: "#F5EB53")
let inventoryCellColor = hexStringToUIColor(hex: "#CCBFED")
let goldBox = hexStringToUIColor(hex: "#ECAF3F")
let darkGold = hexStringToUIColor(hex: "#F7AE03")
let green = hexStringToUIColor(hex: "#196300")
let lightPurple = hexStringToUIColor(hex: "#B99AFF")
let superLightLavender = hexStringToUIColor(hex: "#E3DAFA")
let darkRed = hexStringToUIColor(hex: "#811301")
let darkPurple = hexStringToUIColor(hex:"#5E558A")
let darkGreen = hexStringToUIColor(hex: "#165C12")
let turq = hexStringToUIColor(hex: "#3CAEA2")
let dayKey = "io.focusbyte.day"
let weekKey = "io.focusbyte.week"
let killKey = "io.focusbyte.kill"
let monthKey = "io.focusbyte.month"
let yearKey = "io.focusbyte.year"
var studyTag = Tag(name: "Study", color: "red", selected: false)
var unsetTag = Tag(name: "unset", color: "gray", selected: true)
var readTag = Tag(name: "Read", color: "blue", selected: false)
var workTag = Tag(name: "Work", color: "green", selected: false)
let itemBook = ["scissors": "Common", "cat": "Super Rare", "orange": "Common", "laptop": "Rare", "iphone": "rare", "candy cane": "Common", "crate": "Common", "red flask": "Common", "folder": "Common", "calendar": "Common", "margarita": "Common", "wooden spoon": "Common", "pear": "Common", "clock":"rare", "first-aid kit":"rare", "flower": "Rare","chocolate":"Common", "donut": "Common", "croissant": "Common", "full pizza": "Rare", "pumpkin":"Common", "pretzel": "Common", "popcorn": "Common", "lolipop": "Common", "slice of cake": "Common", "full cake": "Rare", "slice of pizza":"Common", "icecream": "Rare", "soda": "Common", "mug":"Common", "ladle":"Common", "pineapple": "Common", "eggs": "Common", "sashimi": "Rare", "toaster": "Rare", "shrimp": "Rare","cucumber": "Common", "mushroom":"Rare", "watermelon": "Common", "cherry": "Common", "coconut": "Common", "squash":"Common", "apple":"Common", "brocoli":"Common", "poison": "Super Rare", "wine": "Common", "beer": "Common", "salt": "Common", "coffee": "Common", "plate":"Common", "pot":"Common", "kitchen knife": "Common", "grater":"Common", "utensils":"Common","banana":"Common", "blue potion": "Rare", "yellow potion": "Rare", "uranium": "Super Rare", "scale":"Rare", "rolling pin": "Common", "tea kettle": "Common", "milk carton": "Common", "hot sauce": "Rare", "noodle maker": "Rare", "blender": "Common", "measuring cup": "Common", "mutton":"Common", "turkey": "Common", "cheese":"Common", "hot dog":"Common", "hamburger": "Common", "sandwich": "Common", "fish": "Rare", "sushi roll": "Rare", "steak":"Rare", "turnip": "Common", "carrot": "Common", "beet": "Common", "tomato": "Common", "corn":"Common", "potatoes": "Common","onion":"Common", "Blue Jay": "Rare", "Grackle":"Rare", "Sparrow":"Rare", "Eastern Towhee": "Rare", "Grosbeak": "Rare", "dog": "Super Rare", "kitten":"Extremly Rare", "Sally": "Extremely Rare", "Owen": "Extremely Rare", "Cato": "Extremely Rare", "Business Cat": "Super Rare", "Devil Bear": "Extremely Rare", "Beach Cat": "Extremely Rare", "Bear": "Super Rare", "Alex":"Super Rare", "Alexa":"Super Rare", "Allie": "Super Rare", "Angel Bear": "Extremely Rare", "Angry Bear":"Super Rare", "Bat Cat":"Extremely Rare", "Devil Bear": "Extremely Rare", "George": "Super Rare", "Hero Cat": "Extremely Rare", "Emperor Bear": "Extremely Rare", "Pandy":"Super Rare", "Samson": "Super Rare", "Villain Cat": "Extremely Rare", "Violet": "Super Rare", "Wizard Cat": "Extremely Rare", "Zombie Cat": "Extremely Rare", "Cardinal": "Rare", "iron helmet": "Common", "basic sword": "Common", "mask":"Common", "nordic ax":"Common", "red sword":"Rare", "bow":"common", "crown":"Rare", "scroll":"Common", "fries":"Common","popsicle":"Common", "avocado": "Common", "strawberry":"Common", "teacup":"Common", "kiwi":"Common", "pepper":"Common", "grapes":"Common", "red book": "Common", "green book":"Common","diploma":"Common","log":"Common", "bone":"Common","dynamite":"Common","compass":"Common","feather":"Common","torch":"Common", "shield":"Common", "ax":"Common", "special bow":"Rare","stone tablet": "Rare", "armor": "Common", "diamond ring": "Rare", "key":"Common", "necklace":"Common", "wand":"Common","spear":"Common", "dagger":"Common", "camera":"Common", "gmail":"Common", "google drive":"Common","pinwheel":"Common", "anvil":"Rare","pickaxe":"Common", "shovel":"Common", "Mallet":"Common", "crossbow":"Rare","silver bow":"Rare", "emerald":"Rare", "gold ingot": "Rare", "diamond": "Super Rare", "silver coin":"Rare","ruby":"Rare", "guitar":"Rare", "electric guitar":"Super Rare", "paperclip": "Common", "keyboard":"Super Rare", "bitcoin":"Extremely Rare", "drumkit":"Super Rare", "microphone":"Rare", "ornament":"Common", "Earth":"Rare", "baseball bat": "Common", "saw":"Common", "drill":"Rare", "basketball": "Rare", "swat van":"Super Rare", "jukebox":"Super Rare", "bus":"Rare", "umbrella": "Common", "taxi":"Rare", "jeep":"Super Rare", "sports car":"Super Rare", "pool table":"Super Rare", "Rare": "Extremely Rare", "record player":"Rare", "bronze coin":"Common", "lock":"Common", "id":"Rare", "tapes":"Rare", "sink":"Common", "tape recorder": "Super Rare", "gold watch":"Rare", "mail":"Common", "megaphone":"Rare", "lightbulb":"Common", "hanger":"Common", "Speaker":"Rare", "toilet paper":"Extremely Rare", "old tv":"Super Rare", "clipboard":"Common","credit card":"Rare", "laptop pro":"Super Rare", "Desktop":"Super Rare", "Record":"Rare", "blue dino":"Super Rare", "green dino":"Super Rare", "red dino":"Super Rare", "yellow dino":"Super Rare" ]


 struct K {
    static let userPreferenes = "userPreferences"
    static let boxCell = "boxCell"
    static let tagCell = "tagCell"
    static let chooseColorCell = "chooseColorCell"
    static let inventoryCell = "inventoryCell"
    
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
        case "pink":
            return UIColor.systemPink.withAlphaComponent(0.5)
        case "orange":
            return UIColor.orange.withAlphaComponent(0.5)
        case "yellow":
            return gold
        case "turq":
            return turq
        case "skyblue":
            return UIColor.blue.withAlphaComponent(0.5)
        case "lightgreen":
            return UIColor.green.withAlphaComponent(0.5)
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

