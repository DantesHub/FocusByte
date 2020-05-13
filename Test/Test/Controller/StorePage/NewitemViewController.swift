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
    var inventoryLabel = UILabel()
    var inventoryView = UIView()
    var timerImageView: UIImageView = {
        let iv = UIImageView()
        iv.frame.size = CGSize(width: 150, height: 150)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "alarmPic").withAlignmentRectInsets(UIEdgeInsets(top: -5, left: -5, bottom: -5, right: -5))
        iv.applyDesign(color: .black)
        iv.layer.cornerRadius = 25
        iv.isUserInteractionEnabled = true
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFit
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
        view.backgroundColor = backgroundColor
        
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
//        goStoreView.center.x = view.center.x - 120
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
        inventoryView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        inventoryView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        inventoryView.applyDesign(color: .white)
        
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
