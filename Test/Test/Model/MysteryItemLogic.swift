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
        let commonNumber = Int.random(in: 0..<166)
        var commonAndRareItems = [String]()
        for item in itemBook.shuffled() {
            if item.value == "Common" || item.value == "Rare" {
                commonAndRareItems.append(item.key)
            }
        }
        print(commonAndRareItems.shuffled())
        print(commonAndRareItems.count)
        let randomItem = commonAndRareItems.shuffled()[commonNumber]
        return randomItem
    }
    
    static func getGoldItems() -> [String] {
        var commonItems = [String]()
        var rareAndSuperItems = [String]()
        var returnArray = [String]()
        
        let commonNumber = Int.random(in: 0..<112)
        let rareNumber = Int.random(in: 0..<84)
        
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
        returnArray.insert(commonItems.shuffled()[commonNumber], at: 0)
        returnArray.insert(rareAndSuperItems.shuffled()[rareNumber], at: 1)
        return returnArray
    }
    
    static func getDiamondItems() -> [String] {
        let commonNumber = Int.random(in: 0..<112)
        let rareNumber = Int.random(in: 0..<54)
        let epicNumber = Int.random(in: 0..<44)
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
        returnArray.insert(commonItems.shuffled()[commonNumber], at: 0)
        returnArray.insert(rareItems.shuffled()[rareNumber], at: 1)
        returnArray.insert(epicAndSuperRareItems.shuffled()[epicNumber], at: 2)
        return returnArray
        
    }
}
