//
//  NewitemViewController.swift
//  Test
//
//  Created by Dante Kim on 5/10/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift
var inventoryArray = [String]()
class NewitemViewController: UIViewController {
    //MARK: - Views & Properties
    var itemImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    var results: Results<User>!
    let db = Firestore.firestore()
    var goStoreLabel = UILabel()
    var goStoreView = UIView()
    var rarityLabel = UILabel()
    var inventoryLabel = UILabel()
    var inventoryView = UIView()
    var timerImageView: UIImageView = {
        let iv = UIImageView()
        iv.frame.size = CGSize(width: 100, height: 100)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "alarmPic").withAlignmentRectInsets(UIEdgeInsets(top: -5, left: -5, bottom: -5, right: -5))
        iv.applyDesign(color: .black)
        iv.layer.cornerRadius = 25
        iv.isUserInteractionEnabled = true
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    var itemName = ""
    var itemLabel = UILabel()
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        itemName = MysteryItemLogic.getCommonItem()
        inventoryArray.append(itemName)
        saveToFirebaseAndRealm()
        configureUI()
    }
    
    //MARK: - Helper Funcs
    func configureUI() {
        itemLabel.font = UIFont(name: "Menlo-Bold", size: 50)
        itemLabel.textColor = .white
        itemLabel.sizeToFit()
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        itemLabel.text = itemName
        view.addSubview(itemLabel)
        itemLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        itemLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        itemImageView.image = UIImage(named: itemName)
        view.addSubview(itemImageView)
        itemImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        itemImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.backgroundColor = superLightLavender
        configureBottomButtons()
        
        view.addSubview(rarityLabel)
        rarityLabel.translatesAutoresizingMaskIntoConstraints = false
        rarityLabel.text = "-\(itemBook[itemName]!)"
        rarityLabel.font = UIFont(name:"Menlo", size: 35)
        rarityLabel.topToBottom(of: itemLabel)
        rarityLabel.centerX(to: view)
        
    }
    @objc func tappedStore() {
        let controller = ContainerController(center: StoreController())
        controller.modalPresentationStyle = .fullScreen
        presentInFullScreen(UINavigationController(rootViewController: controller), animated: false, completion: nil)
    }
    
    @objc func tappedTimer() {
        let controller = ContainerController(center: TimerController())
        controller.modalPresentationStyle = .fullScreen
        presentInFullScreen(UINavigationController(rootViewController: controller), animated: false, completion: nil)
    }
    
    @objc func tappedItems() {
        let controller = ContainerController(center: InventoryController())
        controller.modalPresentationStyle = .fullScreen
        presentInFullScreen(UINavigationController(rootViewController: controller), animated: false, completion: nil)
    }
    
    func configureBottomButtons() {
        view.addSubview(timerImageView)
        timerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //        timerImageView.topAnchor.constraint(equalTo: itemImageView.centerYAnchor, constant: 250).isActive = true
        timerImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        let tapTimer = UITapGestureRecognizer(target: self, action: #selector(tappedTimer))
        timerImageView.addGestureRecognizer(tapTimer)
        goStoreView.translatesAutoresizingMaskIntoConstraints = false
        goStoreView.backgroundColor = .white
        goStoreView.layer.cornerRadius = 25
        let tapStore = UITapGestureRecognizer(target: self, action: #selector(tappedStore))
        goStoreView.addGestureRecognizer(tapStore)
        view.addSubview(goStoreView)
        goStoreView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        goStoreView.trailingAnchor.constraint(equalTo: timerImageView.leadingAnchor, constant: -20).isActive = true
        goStoreView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -65).isActive = true
        goStoreView.widthAnchor.constraint(equalToConstant: 110).isActive = true
        goStoreView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        goStoreView.applyDesign(color: .white)
        
        goStoreLabel.font = UIFont(name: "Menlo-Bold", size: 20)
        goStoreLabel.text = "Store"
        goStoreLabel.sizeToFit()
        goStoreLabel.textColor = .black
        goStoreLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(goStoreLabel)
        view.insertSubview(goStoreLabel, aboveSubview: goStoreView)
        goStoreLabel.centerXAnchor.constraint(equalTo: goStoreView.centerXAnchor).isActive = true
        goStoreLabel.centerYAnchor.constraint(equalTo: goStoreView.centerYAnchor).isActive = true
        
        inventoryView.translatesAutoresizingMaskIntoConstraints = false
        inventoryView.backgroundColor = .white
        inventoryView.layer.cornerRadius = 25
        //add tapInventory
        view.addSubview(inventoryView)
        inventoryView.leadingAnchor.constraint(equalTo: timerImageView.trailingAnchor, constant: 20).isActive = true
        inventoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        inventoryView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -65).isActive = true
        //        inventoryView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        inventoryView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        inventoryView.applyDesign(color: .white)
        let tapItems = UITapGestureRecognizer(target: self, action: #selector(tappedItems))
         inventoryView.addGestureRecognizer(tapItems)
        
        inventoryLabel.font = UIFont(name: "Menlo-Bold", size: 20)
        inventoryLabel.text = "Items"
        inventoryLabel.sizeToFit()
        inventoryLabel.textColor = .black
        inventoryLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inventoryLabel)
        view.insertSubview(inventoryLabel, aboveSubview: inventoryView)
        inventoryLabel.centerXAnchor.constraint(equalTo: inventoryView.centerXAnchor).isActive = true
        inventoryLabel.centerYAnchor.constraint(equalTo: inventoryView.centerYAnchor).isActive = true
        
    }
    
    func saveToFirebaseAndRealm() {
        switch name {
        case "Common Box":
            coins = coins - 15
        case "Gold Box":
             coins = coins - 45
        case "Diamond Box":
             coins = coins - 100
        default:
            return
        }
        //update data in firebase
        if let _ = Auth.auth().currentUser?.email {
            let email = Auth.auth().currentUser?.email
            self.db.collection(K.userPreferenes).document(email!).updateData([
                "coins": coins,
                "inventoryArray": inventoryArray
            ]) { (error) in
                if let e = error {
                    print("There was a issue saving data to firestore \(e) ")
                } else {
                    print("Succesfully saved new items")
                }
            }
        }
        
        //save To Realm
        let realmInventory = List<String>()
        for item in inventoryArray {
            realmInventory.append(item)
        }
        results = uiRealm.objects(User.self)
        for result  in results {
            if result.isLoggedIn == true {
                do {
                    try uiRealm.write {
                        result.setValue((coins), forKey: "coins")
                        result.setValue(realmInventory, forKey: "inventoryArray")
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}
