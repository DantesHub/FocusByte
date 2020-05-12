//
//  NewitemViewController.swift
//  Test
//
//  Created by Dante Kim on 5/10/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit

class NewitemViewController: UIViewController {
    var itemImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    var goStoreLabel = UILabel()
    var goStoreView = UIView()
    var goStoreShadow = UIView()
    var inventoryLabel = UILabel()
    var inventoryView = UIView()
    var inventoryShadow = UIView()
    var timerImageView: UIImageView = {
        let iv = UIImageView()
        iv.frame.size = CGSize(width: 150, height: 150)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "alarmPic").withAlignmentRectInsets(UIEdgeInsets(top: -5, left: -5, bottom: -5, right: -5))
        iv.applyDesign(color: .black)
        iv.layer.cornerRadius = 25
        iv.isUserInteractionEnabled = true
        iv.backgroundColor = .white
        return iv
    }()
    var itemLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        itemLabel.font = UIFont(name: "Menlo-Bold", size: 50)
        itemLabel.textColor = .white
        itemLabel.sizeToFit()
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        itemLabel.text = "Scissors"
        view.addSubview(itemLabel)
        itemLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        itemLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        itemImageView.image = UIImage(named: "scissors")
        view.addSubview(itemImageView)
        itemImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        itemImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.backgroundColor = color
        
        view.addSubview(timerImageView)
        timerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timerImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        let tapTimer = UITapGestureRecognizer(target: self, action: #selector(tappedTimer))
        timerImageView.addGestureRecognizer(tapTimer)
        
        goStoreView.frame.size.width = 125
        goStoreView.frame.size.height = 75
        goStoreView.center.x = view.center.x - 120
        goStoreView.backgroundColor = .white
        goStoreView.center.y = view.center.y + 305
        goStoreView.layer.cornerRadius = 25
        let tapStore = UITapGestureRecognizer(target: self, action: #selector(tappedStore))
        goStoreView.addGestureRecognizer(tapStore)
        view.addSubview(goStoreView)
    
        
        goStoreShadow = UIView(frame: CGRect(x: goStoreView.center.x - 60  , y: goStoreView.center.y-30 , width: 125, height: 75))
        goStoreShadow.backgroundColor = .clear
        goStoreShadow.layer.cornerRadius = 25
        goStoreShadow.dropShadow(superview: goStoreView)
        view.addSubview(goStoreShadow)
        view.insertSubview(goStoreView, aboveSubview: goStoreShadow)
        
        goStoreLabel.font = UIFont(name: "Menlo-Bold", size: 20)
        goStoreLabel.text = "Store"
        goStoreLabel.sizeToFit()
        goStoreLabel.textColor = .black
        goStoreLabel.center.x = goStoreView.center.x
        goStoreLabel.center.y = goStoreView.center.y
        view.addSubview(goStoreLabel)
        view.insertSubview(goStoreLabel, aboveSubview: goStoreView)
        
        inventoryView.frame.size.width = 125
        inventoryView.frame.size.height = 75
        inventoryView.center.x = view.center.x + 120
        inventoryView.backgroundColor = .white
        inventoryView.center.y = goStoreView.center.y
        inventoryView.layer.cornerRadius = 25
        //add tapInventory
        view.addSubview(inventoryView)
        
        inventoryShadow = UIView(frame: CGRect(x: inventoryView.center.x - 60, y: goStoreView.center.y-30 , width: 125, height: 75))
        inventoryShadow.backgroundColor = .clear
        inventoryShadow.layer.cornerRadius = 25
        inventoryShadow.dropShadow(superview: inventoryView)
        view.addSubview(inventoryShadow)
        view.insertSubview(inventoryShadow, aboveSubview: goStoreShadow)
        
        inventoryLabel.font = UIFont(name: "Menlo-Bold", size: 20)
        inventoryLabel.text = "Inventory"
        inventoryLabel.sizeToFit()
        inventoryLabel.textColor = .black
        inventoryLabel.center.x = inventoryView.center.x
        inventoryLabel.center.y = inventoryView.center.y
        view.addSubview(inventoryLabel)
        view.insertSubview(inventoryLabel, aboveSubview: inventoryView)
        
        

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
    
    
}
