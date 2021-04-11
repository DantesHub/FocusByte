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
import Photos
import AppsFlyerLib

var inventoryArray = [String]()
class NewitemViewController: UIViewController {
    //MARK: - Views & Properties
    var itemImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.width(max: 300)
        iv.height(max: 300)
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
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .white
        return iv
    }()
    var itemName = ""
    var itemLabel = UILabel()
    var shareButton = UIView()
    var shareLabel = UILabel()
    
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
        itemLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: commonTitlePadding).isActive = true
        itemImageView.image = UIImage(named: itemName)
        view.addSubview(itemImageView)
        itemImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        itemImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.backgroundColor = superLightLavender
        configureBottomButtons()
        
        view.addSubview(rarityLabel)
        rarityLabel.translatesAutoresizingMaskIntoConstraints = false
        rarityLabel.text = "-\(itemBook[itemName]!)"
        rarityLabel.textColor = itemBook[itemName] == "Common" ? black : darkRed
        rarityLabel.font = UIFont(name:"Menlo", size: 35)
        rarityLabel.topToBottom(of: itemLabel)
        rarityLabel.centerX(to: view)
        
        createShareButton()
        shareButton.topToBottom(of: rarityLabel)
    }
    
    func createShareButton() {
        view.addSubview(shareButton)
        shareButton.addSubview(shareLabel)
        shareLabel.text = "Share"
        shareButton.width(100)
        shareButton.height(50)
        shareButton.backgroundColor = brightPurple
        shareButton.applyDesign(color: brightPurple)
        shareLabel.center(in: shareButton)
        shareLabel.font = UIFont(name: "Menlo-Bold", size: 17)
        shareLabel.textColor = .white
        shareButton.centerXToSuperview()
        let tappedShare = UITapGestureRecognizer(target: self, action: #selector(shareTapped))
        shareButton.addGestureRecognizer(tappedShare)
    }
    func getScreenshoot() -> UIImage {
        var window: UIWindow? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
        window = UIApplication.shared.windows[0]
        UIGraphicsBeginImageContextWithOptions(window!.frame.size, window!.isOpaque, 0.0)
        window!.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!;
    }
    @objc func shareTapped() {
        PHPhotoLibrary.requestAuthorization { (status) in
            // No crash
        }
        let snap = getScreenshoot()
        let myURL = URL(string: "https://focusbyte.io")
        let objectToshare = [snap, myURL!] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectToshare, applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
        return
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
        timerImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        let tapTimer = UITapGestureRecognizer(target: self, action: #selector(tappedTimer))
        timerImageView.addGestureRecognizer(tapTimer)
        
        view.addSubview(goStoreView)
        goStoreView.translatesAutoresizingMaskIntoConstraints = false
        goStoreView.backgroundColor = .white
        goStoreView.layer.cornerRadius = 25
        let tapStore = UITapGestureRecognizer(target: self, action: #selector(tappedStore))
        goStoreView.addGestureRecognizer(tapStore)
        goStoreView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        goStoreView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -65).isActive = true
        goStoreView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        goStoreView.applyDesign(color: .white)
        goStoreView.trailingToLeading(of: timerImageView, offset: -10)
        
        view.insertSubview(goStoreLabel, aboveSubview: goStoreLabel)
        goStoreLabel.font = UIFont(name: "Menlo-Bold", size: 20)
        goStoreLabel.text = "Store"
        goStoreLabel.sizeToFit()
        goStoreLabel.textColor = .black
        goStoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
            if !commonVideo {
                coins = coins - 15
            } else {
                commonVideo = false
            }
            print("loged")
            Analytics.logEvent("Common_Box", parameters: nil)
            AppsFlyerLib.shared().logEvent("Common_Box", withValues: [AFEventParamContent: "true"])
        case "Gold Box":
             coins = coins - 45
            Analytics.logEvent("Gold_Box", parameters: nil)
            AppsFlyerLib.shared().logEvent("Gold_Box", withValues: [AFEventParamContent: "true"])
        case "Diamond Box":
             coins = coins - 100
             Analytics.logEvent("Diamond_Box", parameters: nil)
            AppsFlyerLib.shared().logEvent("Diamond_Box", withValues: [AFEventParamContent: "true"])
        default:
            return
        }
        //update data in firebase
        if !UserDefaults.standard.bool(forKey: "noLogin") {
            if UserDefaults.standard.bool(forKey: "isPro") {
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
