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
let origBackgroundColor = hexStringToUIColor(hex: "#C7B6F5")
let diamond = hexStringToUIColor(hex: "29d4ff")
let gold = hexStringToUIColor(hex: "#F5EB53")
let inventoryCellColor = hexStringToUIColor(hex: "#CCBFED")
let goldBox = hexStringToUIColor(hex: "#ECAF3F")
let darkGold = hexStringToUIColor(hex: "#F7AE03")
let green = hexStringToUIColor(hex: "#196300")
let lightPurple = hexStringToUIColor(hex: "#B99AFF")
let superPurple = hexStringToUIColor(hex: "#A73CDE")
let brightGreen = hexStringToUIColor(hex: "abf972")
let emeraldGreen = hexStringToUIColor(hex: "#4EC375")
let barColor = hexStringToUIColor(hex: "8D8AFF")
let superLightLavender = hexStringToUIColor(hex: "#E3DAFA")
let darkRed = hexStringToUIColor(hex: "#811301")
let darkTan = hexStringToUIColor(hex: "#db762e")
let darkPurple = hexStringToUIColor(hex:"#5E558A")
let darkGreen = hexStringToUIColor(hex: "#165C12")
let blonde = hexStringToUIColor(hex: "#F6CD7F")
let lightGray = hexStringToUIColor(hex: "#EAEAEA")
let turq = hexStringToUIColor(hex: "#3CAEA2")
let brown = hexStringToUIColor(hex: "#663932")
let black = hexStringToUIColor(hex: "#000000")
let skyBlue = hexStringToUIColor(hex: "#05BAF6")
let tan = hexStringToUIColor(hex: "#F9AA71")
let dayKey = "io.focusbyte.day"
let weekKey = "io.focusbyte.week"
let killKey = "io.focusbyte.kill"
let monthKey = "io.focusbyte.month"
let yearKey = "io.focusbyte.year"
let updateCollection = "io.focusbyte.collection"
let commonKey = "io.focusbyte.common"
let rareKey = "io.focusbyte.rare"
let superKey = "io.focusbyte.super"
let epicKey = "io.focusbyte.epic"
let petsKey = "io.focusbyte.pets"
let closetKey = "io.focusbyte.closet"
let quotes = ["Be so good they can’t ignore you.\n– Steve Martin", "Whatever you do, do it well.\n– Walt Disney", "If you’re going through hell, keep going.-Winston Churchill","Yesterday you said tomorrow. Just do it.– Nike", "There is no substitute for hard work.\n– Thomas Edison","And still, I rise.\n– Maya Angelou", "May your choices reflect your hopes, not your fears. – Nelson Mandela", "No pressure, no diamonds.\n-Thomas Carlyle","All limitations are self-imposed.\n– Oliver Wendell Holmes"]
let quotesPro = ["Be so good they can’t ignore you.\n– Steve Martin", "Whatever you do, do it well.\n– Walt Disney", "Yesterday you said tomorrow. Just do it.\n– Nike", "There is no substitute for hard work.\n– Thomas Edison","And still, I rise.\n– Maya Angelou", "May your choices reflect your hopes, not your fears.\n – Nelson Mandela", "Happiness depends upon ourselves.\n– Aristotle","All limitations are self-imposed.\n– Oliver Wendell Holmes","Oh, the things you can find, if you don’t stay behind.\n– Dr. Seuss","Problems are not stop signs, they are guidelines.\n– Robert H. Schiuller", "Tough times never last but tough people do.\n– Robert H. Schiuller", "Aspire to inspire before we expire.\n– Unknown","Every moment is a fresh beginning.\n– T.S Eliot","Impossible is for the unwilling.\n-John Keats", "No pressure, no diamonds.\n-Thomas Carlyle","Happiness depends upon ourselves.\n– Aristotle","Don’t tell people your plans. Show \nthem your results.","I can and I will\n-unknown", "My life is my argument.\n-Albert Schweitzer", "Stay hungry. Stay foolish.\n-Steve Jobs", "Broken crayons still color.", "Don’t dream your life, live your dream.","Forget about style; worry about results.\n-Bobby Orr","If you’re going through hell, keep going.\n-Winston Churchill","We are twice armed if we fight with faith.\n-Plato","The wisest mind has something yet to learn\n-George Santanaya","In life you need either inspiration or \ndesperation.-Tony Robbins","We can do anything we want to if \nwe stick to it long enough. -Helen Keller","I would rather die on my feet than\nlive on my knees. -Euripides","Grow through what you go through.","Whatever you are, be a good one.\n-Abraham Lincoln","You can if you think you can.\n-George Reeves"]
var studyTag = Tag(name: "Study", color: "red", selected: false)
var unsetTag = Tag(name: "unset", color: "gray", selected: true)
var readTag = Tag(name: "Read", color: "blue", selected: false)
var workTag = Tag(name: "Work", color: "green", selected: false)
var petBook = ["Blue Jay", "Cardinal", "Grackle", "Sparrow", "Eastern Towhee","Grosbeak","Cato", "Owen", "Sally","Alexa", "Bear",  "Business Cat","Devil Bear", "Beach Cat", "Alex", "Alexa", "Allie", "Angel Bear", "Angry Bear", "Bat Cat", "George", "Hero Cat", "Emperor Bear", "Pandy", "Samson", "Villain Cat", "Violet", "Wizard Cat", "Zombie Cat", "dog", "red dino", "yellow dino", "green dino", "blue dino", "kitten", "fish"]
var frameBook:[String:Int] = ["black frame": 30, "circle frame": 45, "cool frame":60, "3d frame":80, "winged frame":150, "city frame": 135]
var topBook:[String:Int] = ["black sweater":50, "gray sweater":50, "yellow sweater":50, "blue sweater":50,"purple sweater":50, "yellow top":75, "blue flower-sweater":80, "yellow flower-sweater":80,"red swoosh-tshirt": 50, "blue swoosh-tshirt": 50, "black striped-tshirt":40, "red striped-tshirt":40, "blue striped-tshirt":40, "heart sweater": 55, "heart sweater-red":55, "pink hoodie":60, "blue hoodie":60, "23 jersey-red":60, "23 jersey-blue":60, "white dress-shirt":90, "black dress-shirt":90, "brand shirt-white": 100, "brand shirt-red":100, "varsity jacket-red": 120, "varsity jacket-blue": 120, "varsity jacket-green": 120]
var suitBook:[String:Int] = ["Armored Suit": 800, "Space Suit": 800, "Ninja Suit":800]
let pantsBook:[String:Int] = ["blue jeans": 0,"black pants":60,"white pants":60, "tan pants":60, "dark-green pants":60,"gray joggers":75, "long dress": 75, "camo pants": 100]
let shoeBook:[String:Int] = ["red sneakers": 140, "sandals":50,"chelsea boots": 80, "green sneakers":140, "stan sneakers": 100, "default shoes":0]
let backpackBook:[String:Int] = ["orange backpack": 120, "black suitcase": 80, "pink suitcase": 80, "brown duffle":70, "raven backpack":120]
let allClothes = topBook.merging(pantsBook, uniquingKeysWith: { (current, _) in current }).merging(shoeBook, uniquingKeysWith: { (current, _) in current }).merging(backpackBook, uniquingKeysWith: { (current, _) in current }).merging(frameBook, uniquingKeysWith: { (current, _) in current }).merging(suitBook, uniquingKeysWith: { (current, _) in current })
let itemBook:[String:String] = ["scissors": Rarity.Common.rawValue, "kitten": Rarity.Rare.rawValue, "orange": Rarity.Common.rawValue, "laptop": Rarity.Rare.rawValue, "iphone": Rarity.Rare.rawValue, "candy cane": Rarity.Common.rawValue, "crate": Rarity.Common.rawValue, "red flask": Rarity.Common.rawValue, "folder": Rarity.Common.rawValue, "calendar": Rarity.Common.rawValue, "margarita": Rarity.Common.rawValue, "wooden spoon": Rarity.Common.rawValue, "pear": Rarity.Common.rawValue, "clock":Rarity.Rare.rawValue, "first-aid kit":Rarity.Rare.rawValue, "flower": Rarity.Rare.rawValue,"chocolate":Rarity.Common.rawValue, "donut": Rarity.Common.rawValue, "croissant": Rarity.Common.rawValue, "full pizza": Rarity.Rare.rawValue, "pumpkin":Rarity.Common.rawValue, "pretzel": Rarity.Common.rawValue, "popcorn": Rarity.Common.rawValue, "lolipop": Rarity.Common.rawValue, "slice of cake": Rarity.Common.rawValue, "full cake": Rarity.Rare.rawValue, "slice of pizza":Rarity.Common.rawValue, "icecream": Rarity.Rare.rawValue, "soda": Rarity.Common.rawValue, "mug":Rarity.Common.rawValue, "ladle":Rarity.Common.rawValue, "pineapple": Rarity.Common.rawValue, "eggs": Rarity.Common.rawValue, "sashimi": Rarity.Rare.rawValue, "toaster": Rarity.Rare.rawValue, "shrimp": Rarity.Rare.rawValue,"cucumber": Rarity.Common.rawValue, "mushroom":Rarity.Rare.rawValue, "watermelon": Rarity.Common.rawValue, "cherry": Rarity.Common.rawValue, "coconut": Rarity.Common.rawValue, "squash":Rarity.Common.rawValue, "apple":Rarity.Common.rawValue, "brocoli":Rarity.Common.rawValue, "poison": Rarity.Super.rawValue, "wine": Rarity.Common.rawValue, "beer": Rarity.Common.rawValue, "salt": Rarity.Common.rawValue, "coffee": Rarity.Common.rawValue, "plate":Rarity.Common.rawValue, "pot":Rarity.Common.rawValue, "kitchen knife": Rarity.Common.rawValue, "grater":Rarity.Common.rawValue, "utensils":Rarity.Common.rawValue,"banana":Rarity.Common.rawValue, "blue potion": Rarity.Rare.rawValue, "yellow potion": Rarity.Rare.rawValue, "uranium": Rarity.Super.rawValue, "scale":Rarity.Rare.rawValue, "rolling pin": Rarity.Common.rawValue, "tea kettle": Rarity.Common.rawValue, "milk carton": Rarity.Common.rawValue, "hot sauce": Rarity.Rare.rawValue, "noodle maker": Rarity.Rare.rawValue, "blender": Rarity.Common.rawValue, "measuring cup": Rarity.Common.rawValue, "mutton":Rarity.Common.rawValue, "turkey": Rarity.Common.rawValue, "cheese":Rarity.Common.rawValue, "hot dog":Rarity.Common.rawValue, "hamburger": Rarity.Common.rawValue, "sandwich": Rarity.Common.rawValue, "fish": Rarity.Common.rawValue, "sushi roll": Rarity.Rare.rawValue, "steak":Rarity.Rare.rawValue, "turnip": Rarity.Common.rawValue, "carrot": Rarity.Common.rawValue, "beet": Rarity.Common.rawValue, "tomato": Rarity.Common.rawValue, "corn":Rarity.Common.rawValue, "potatoes": Rarity.Common.rawValue,"onion":Rarity.Common.rawValue, "Blue Jay": Rarity.Rare.rawValue, "Grackle":Rarity.Rare.rawValue, "Sparrow":Rarity.Rare.rawValue, "Eastern Towhee": Rarity.Rare.rawValue, "Grosbeak": Rarity.Rare.rawValue, "dog": Rarity.Super.rawValue, "Sally": Rarity.Epic.rawValue, "Owen": Rarity.Epic.rawValue, "Cato": Rarity.Epic.rawValue, "Business Cat": Rarity.Super.rawValue, "Devil Bear": Rarity.Epic.rawValue, "Beach Cat": Rarity.Epic.rawValue, "Bear": Rarity.Rare.rawValue, "Alex":Rarity.Super.rawValue, "Alexa":Rarity.Super.rawValue, "Allie": Rarity.Super.rawValue, "Angel Bear": Rarity.Epic.rawValue, "Angry Bear":Rarity.Super.rawValue, "Bat Cat":Rarity.Epic.rawValue, "George": Rarity.Super.rawValue, "Emperor Bear": Rarity.Epic.rawValue, "Pandy":Rarity.Super.rawValue, "Samson": Rarity.Super.rawValue, "Villain Cat": Rarity.Epic.rawValue, "Violet": Rarity.Super.rawValue, "Wizard Cat": Rarity.Epic.rawValue, "Zombie Cat": Rarity.Epic.rawValue, "Cardinal": Rarity.Rare.rawValue, "iron helmet": Rarity.Common.rawValue, "basic sword": Rarity.Common.rawValue,  "mask":Rarity.Common.rawValue, "nordic axe":Rarity.Common.rawValue, "red sword":Rarity.Rare.rawValue, "bow":Rarity.Common.rawValue, "crown":Rarity.Rare.rawValue, "scroll":Rarity.Common.rawValue, "fries":Rarity.Common.rawValue,"popsicle":Rarity.Common.rawValue, "avocado": Rarity.Common.rawValue, "strawberry":Rarity.Common.rawValue, "teacup":Rarity.Common.rawValue, "kiwi":Rarity.Common.rawValue, "pepper":Rarity.Common.rawValue, "grapes":Rarity.Common.rawValue, "red book": Rarity.Common.rawValue, "green book":Rarity.Common.rawValue,"diploma":Rarity.Common.rawValue,"log":Rarity.Common.rawValue, "bone":Rarity.Common.rawValue,"dynamite":Rarity.Common.rawValue,"compass":Rarity.Common.rawValue,"feather":Rarity.Common.rawValue,"torch":Rarity.Common.rawValue, "shield":Rarity.Common.rawValue, "axe":Rarity.Common.rawValue, "special bow":Rarity.Rare.rawValue,"stone tablet": Rarity.Rare.rawValue, "armor": Rarity.Common.rawValue, "diamond ring": Rarity.Rare.rawValue, "key":Rarity.Common.rawValue, "necklace":Rarity.Common.rawValue, "wand":Rarity.Common.rawValue,"spear":Rarity.Common.rawValue, "dagger":Rarity.Common.rawValue, "camera":Rarity.Common.rawValue, "gmail":Rarity.Common.rawValue, "google drive":Rarity.Common.rawValue,"pinwheel":Rarity.Common.rawValue, "anvil":Rarity.Rare.rawValue,"pickaxe":Rarity.Common.rawValue, "shovel":Rarity.Common.rawValue, "Mallet":Rarity.Common.rawValue, "crossbow":Rarity.Rare.rawValue,"silver bow":Rarity.Rare.rawValue, "emerald":Rarity.Rare.rawValue, "gold ingot": Rarity.Rare.rawValue, "diamond": Rarity.Super.rawValue, "silver coin":Rarity.Rare.rawValue,"ruby":Rarity.Rare.rawValue, "guitar":Rarity.Rare.rawValue, "electric guitar":Rarity.Super.rawValue, "paperclip": Rarity.Common.rawValue, "keyboard":Rarity.Super.rawValue, "bitcoin":Rarity.Epic.rawValue, "drumkit":Rarity.Super.rawValue, "microphone":Rarity.Rare.rawValue, "ornament":Rarity.Common.rawValue, "Earth":Rarity.Rare.rawValue, "baseball bat": Rarity.Common.rawValue, "saw":Rarity.Common.rawValue, "drill":Rarity.Rare.rawValue, "basketball": Rarity.Rare.rawValue, "swat van":Rarity.Super.rawValue, "jukebox":Rarity.Super.rawValue, "bus":Rarity.Rare.rawValue, "umbrella": Rarity.Common.rawValue, "taxi":Rarity.Rare.rawValue, "jeep":Rarity.Super.rawValue, "sports car":Rarity.Super.rawValue, "pool table":Rarity.Super.rawValue,"record player":Rarity.Rare.rawValue, "bronze coin":Rarity.Common.rawValue, "lock":Rarity.Common.rawValue, "id":Rarity.Rare.rawValue, "tapes":Rarity.Rare.rawValue, "sink":Rarity.Common.rawValue, "tape recorder": Rarity.Super.rawValue, "gold watch":Rarity.Rare.rawValue, "mail":Rarity.Common.rawValue, "megaphone":Rarity.Rare.rawValue, "lightbulb":Rarity.Common.rawValue, "hanger":Rarity.Common.rawValue, "Speaker":Rarity.Rare.rawValue, "toilet paper":Rarity.Epic.rawValue, "old tv":Rarity.Super.rawValue, "clipboard":Rarity.Common.rawValue,"credit card":Rarity.Rare.rawValue, "laptop pro":Rarity.Super.rawValue, "Desktop":Rarity.Super.rawValue, "record":Rarity.Rare.rawValue, "blue dino":Rarity.Super.rawValue, "green dino":Rarity.Super.rawValue, "red dino":Rarity.Super.rawValue, "yellow dino":Rarity.Super.rawValue, "polaroid": Rarity.Super.rawValue, "journal":Rarity.Common.rawValue, "kindle":Rarity.Common.rawValue]
    

struct K {
    static let userPreferenes = "userPreferences"
    static let boxCell = "boxCell"
    static let tagCell = "tagCell"
    static let chooseColorCell = "chooseColorCell"
    static let inventoryCell = "inventoryCell"
    static let hairCell = "hairCell"
    static let avatarColorCell = "avatarColorCell"
    static let eyeColorCell = "eyeColorCell"
    struct FStore {
        static let collectionName = "userPreferences"
    }
    static func getAvatarColor(_ col: String) -> UIColor{
        switch col {
        case "brown":
            return brown
        case "black":
            return black
        case "darkRed":
            return darkRed
        case "darkTan":
            return darkTan
        case "blonde":
            return blonde
        case "green":
            return darkGreen
        case "brightGreen":
            return brightGreen
        case "blue":
            return skyBlue
        case "tan":
            return tan
        case "emeraldGreen":
            return emeraldGreen
        case "gray":
            return UIColor.gray
        default:
            return .white
        }
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
        case "tan":
            return tan
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

