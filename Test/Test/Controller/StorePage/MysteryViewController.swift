//
//  MysterViewController.swift
//  Test
//
//  Created by Dante Kim on 4/18/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit

class MysteryViewController: UIViewController {
   //MARK: - Properties
    var goldMysteryBox = UIImageView()
    var goldMysteryImage = UIImage()
    var diamondMysteryBox = UIImageView()
    let minLineSpace: CGFloat = 4
    
    fileprivate let collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 30
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(BoxCell.self, forCellWithReuseIdentifier: K.boxCell)
        return cv
    }()
    
    let data = [
        MysteryBox(description: "There are 100 different items in the Common Mystery Box", image: UIImage(named: "commonmysterybox")!, title: "Common Box", color: .black),
         MysteryBox(description: "There are 40 different items in the Gold Mystery Box", image: UIImage(named: "goldmysterybox")!, title: "Gold Box", color: gold),
         MysteryBox(description: "There are 20 different items in the Diamond Mystery Box", image: UIImage(named: "diamondmysterybox")!, title: "Diamond Box", color: diamond)

     ]
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        view.backgroundColor = backgroundColor
        view.addSubview(collectionView)
        collectionView.showsHorizontalScrollIndicator = false
        self.title = "Mystery Boxes"
        configureNavigationBar(color: backgroundColor, isTrans: false)
        navigationController?.navigationBar.tintColor = .white
        
        collectionView.backgroundColor = backgroundColor
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.isPagingEnabled = true;

    }

}

extension MysteryViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - minLineSpace), height: collectionView.frame.height/1.2)
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.boxCell, for: indexPath) as! BoxCell
        cell.data = self.data[indexPath.row]
        cell.clipsToBounds = false
        cell.desc.text = self.data[indexPath.row].description
        cell.titleLabel.text = self.data[indexPath.row].title
        cell.titleLabel.textColor = self.data[indexPath.row].color
        cell.buyButton.backgroundColor = self.data[indexPath.row].color
        if self.data[indexPath.row].color == gold {
            cell.buyButton.backgroundColor = darkGold
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(minLineSpace)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: (CGFloat(minLineSpace / 2)), bottom: 0, right: (CGFloat(minLineSpace / 2)))
    }
}


