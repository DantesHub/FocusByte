//
//  AvatarStoreController.swift
//  Test
//
//  Created by Dante Kim on 6/1/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit
import TinyConstraints
class AvatarStoreController: UIViewController {
    //MARK: - Properties
    lazy var collectionView: UICollectionView = {
        let columnLayout = ColumnFlowLayout(
            cellsPerRow: 2,
            minimumInteritemSpacing: 25,
            minimumLineSpacing: 20,
            sectionInset: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        )
        columnLayout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: columnLayout)
        cv.backgroundColor = backgroundColor
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false

        return cv
    }()
    struct Section {
        var sectionName: String
        var rowData: [String]
    }
    var shirtArray = [String]()
    var pantsArray = [String]()
    var backpackArray = [String]()
    var shoeArray = [String]()
    var glassesArray = [String]()
    var sections = [Section]()
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = backgroundColor
        NotificationCenter.default.addObserver(self, selector: #selector(AvatarStoreController.reloadView(notificaton:)), name: NSNotification.Name(rawValue: updateCollection), object: nil)
        //load store data
        getArrays()
        sections = [Section(sectionName: "Glasses", rowData: glassesArray),Section(sectionName: "Shirts/Sweaters", rowData: shirtArray), Section(sectionName: "Pants", rowData: pantsArray), Section(sectionName: "Shoes", rowData: shoeArray), Section(sectionName: "Backpacks/Luggage", rowData: backpackArray), Section(sectionName: "Hats", rowData: pantsArray),Section(sectionName: "Pants", rowData: pantsArray), Section(sectionName: "Suits Level 70+", rowData: pantsArray)]
        configureUI()
 
    }
    
    //MARK: - Helper Functions
    @objc final func reloadView(notificaton: NSNotification) {
        shirtArray = [String]()
        pantsArray = [String]()
        shoeArray = [String]()
        backpackArray = [String]()
        glassesArray = [String]()
        getArrays()
        sections = [Section(sectionName: "Glasses", rowData: glassesArray),Section(sectionName: "Shirts/Sweaters", rowData: shirtArray), Section(sectionName: "Pants", rowData: pantsArray), Section(sectionName: "Shoes", rowData: shoeArray), Section(sectionName: "Backpacks/Luggage", rowData: backpackArray), Section(sectionName: "Hats", rowData: pantsArray),Section(sectionName: "Pants", rowData: pantsArray), Section(sectionName: "Suits Level 70+", rowData: pantsArray)]
        collectionView.reloadData()
    }
    
    func getArrays() {
        for item in allClothes {
            if !inventoryArray.contains(item.key) {
                if topBook.contains(where: {$0.key == item.key}) {
                    shirtArray.append(item.key)
                } else if pantsBook.contains(where: {$0.key == item.key}) {
                    pantsArray.append(item.key)
                } else if shoeBook.contains(where: {$0.key == item.key}) {
                    shoeArray.append(item.key)
                } else if backpackBook.contains(where: {$0.key == item.key}) {
                    backpackArray.append(item.key)
                } else if frameBook.contains(where: {$0.key == item.key}) {
                    glassesArray.append(item.key)
                }
            }
        }
    }
    
    func configureUI() {
        view.backgroundColor = backgroundColor
        navigationItem.title = "Clothing"
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.register(AvatarStoreCell.self, forCellWithReuseIdentifier: AvatarStoreCell.cellId)
        collectionView.register(SectionHeaderViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderViewCell.reuseId)
        collectionView.topToSuperview(offset: 30)
        collectionView.leadingToSuperview(offset: 0)
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        collectionView.bottomToSuperview(offset: 0)
  
    }
}


//MARK: - Collection Extension
extension AvatarStoreController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].rowData.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView,
                     layout collectionViewLayout: UICollectionViewLayout,
                     referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize(width: CGFloat(signOf: collectionView.frame.size.width, magnitudeOf: CGFloat(60)), height: 60)
    }
    
  // MARK: Header
       func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
           switch kind {
           case UICollectionView.elementKindSectionHeader:
               let cell = self.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderViewCell.reuseId, for: indexPath) as! SectionHeaderViewCell
               cell.initializeUI()
               cell.createConstraints()
               cell.setTitle(title: self.sections[indexPath.section].sectionName)
               return cell
           default:  fatalError("Unexpected element kind")
           }
       }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AvatarStoreCell.cellId, for: indexPath) as! AvatarStoreCell
        cell.setImage(image: UIImage(named: sections[indexPath.section].rowData[indexPath.row])!)
        cell.setImageName(name: sections[indexPath.section].rowData[indexPath.row])
            return cell
    }
    
}

