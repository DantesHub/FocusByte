//
//  InventoryController.swift
//  Test
//
//  Created by Dante Kim on 5/13/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit
import RealmSwift
import TinyConstraints

class InventoryController: UIViewController {
    //MARK: - properties
    var delegate: ContainerControllerDelegate!
    lazy var collectionView: UICollectionView = {

        let columnLayout = ColumnFlowLayout(
            cellsPerRow: 3,
            minimumInteritemSpacing: 25,
            minimumLineSpacing: 20,
            sectionInset: UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        )
      
        columnLayout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: columnLayout)
        cv.backgroundColor = backgroundColor
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false

        return cv
    }()
    
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        configureNavigationBar(color: backgroundColor, isTrans: false)
        navigationItem.title = "Inventory"
         navigationItem.leftBarButtonItem =  UIBarButtonItem(image: resizedMenuImage?.withTintColor(.white), style: .plain, target: self, action: #selector(handleMenuToggle))
        view.backgroundColor = backgroundColor
        parent?.title = "Inventory"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.register(InventoryCell.self, forCellWithReuseIdentifier: K.inventoryCell)
        collectionView.edgesToSuperview(insets: TinyEdgeInsets(top: 5, left: 15, bottom: 25, right: 15))
    }
    
    //MARK: - Handlers
      @objc func handleMenuToggle() {
          delegate?.handleMenuToggle(forMenuOption: nil)
      }
}

extension InventoryController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.inventoryCell, for: indexPath) as! InventoryCell
        cell.setImage(image: UIImage(named: "cucumber")!)
        return cell
    }
    
}
