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
        var rowData: [DisplayItem]
    }
    var shirtArray = [DisplayItem(count: -1, name: "green sweater", rarity: "None"), DisplayItem(count: -1, name: "blue sweater", rarity: "None"),DisplayItem(count: -1, name: "yellow sweater", rarity: "None"),DisplayItem(count: -1, name: "black sweater", rarity: "None"),DisplayItem(count: -1, name: "purple sweater", rarity: "None")]
    var pantsArray = [DisplayItem(count: -1, name: "gray joggers", rarity: "None"),DisplayItem(count: -1, name: "blue jeans", rarity: "None"),DisplayItem(count: -1, name: "black pants", rarity: "None")]
    var sections = [Section]()
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = backgroundColor
        
        //load store data
        sections = [Section(sectionName: "Shirts/Sweaters", rowData: shirtArray), Section(sectionName: "Pants", rowData: pantsArray), Section(sectionName: "Hats", rowData: pantsArray),Section(sectionName: "Shirts/Sweaters", rowData: shirtArray), Section(sectionName: "Pants", rowData: pantsArray), Section(sectionName: "Hats", rowData: pantsArray),Section(sectionName: "Pants", rowData: pantsArray), Section(sectionName: "Hats", rowData: pantsArray)]
        configureUI()
 
    }
    
    //MARK: - Helper Functions
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
        cell.setImage(image: UIImage(named: sections[indexPath.section].rowData[indexPath.row].name)!)
        cell.setImageName(name: sections[indexPath.section].rowData[indexPath.row].name)
            return cell
    }
    
}

