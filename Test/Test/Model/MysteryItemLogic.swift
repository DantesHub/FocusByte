//
//  MysteryItemLogic.swift
//  Test
//
//  Created by Dante Kim on 5/27/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import Foundation
import UIKit

struct MysteryItemLogic {
    static func getCommonItem() -> String {
        var commonAndRareItems = [String]()
        for item in itemBook.shuffled() {
            if item.value == "Common" || item.value == "Rare" {
                commonAndRareItems.append(item.key)
            }
        }
        print(commonAndRareItems.shuffled())
        print(commonAndRareItems.count)
        let randomItem = commonAndRareItems.shuffled()[0]
        return randomItem
    }
    
    static func getGoldItems() -> [String] {
        var commonItems = [String]()
        var rareAndSuperItems = [String]()
        var returnArray = [String]()
        
        for (i,item) in itemBook.shuffled().enumerated() {
            if item.value == "Common" {
                commonItems.append(item.key)
            }
            if item.value == "Rare" || item.value == "Super Rare" {
                rareAndSuperItems.append(item.key)
            }
            if i % 3 == 0 && item.value == "Rare"{
                rareAndSuperItems.append(item.key)
            }
        }
        returnArray.insert(commonItems.shuffled()[0], at: 0)
        returnArray.insert(rareAndSuperItems.shuffled()[0], at: 1)
        return returnArray
    }
    
    static func getDiamondItems() -> [String] {
        var commonItems = [String]()
        var rareItems = [String]()
        var epicAndSuperRareItems = [String]()
        var returnArray = [String]()
        for (i,item) in itemBook.shuffled().enumerated() {
            if item.value == "Common" {
                commonItems.append(item.key)
            }
            if item.value == "Rare" {
                rareItems.append(item.key)
            }
            if item.value == "Epic" || item.value == "Super Rare" {
                epicAndSuperRareItems.append(item.key)
            }
            if i % 10 == 0  && item.value == "Super Rare"{
                epicAndSuperRareItems.append(item.key)
            }
        }
        returnArray.insert(commonItems.shuffled()[0], at: 0)
        returnArray.insert(rareItems.shuffled()[0], at: 1)
        returnArray.insert(epicAndSuperRareItems.shuffled()[0], at: 2)
        return returnArray
        
    }
}
