//
//  AvatarSideBar.swift
//  Test
//
//  Created by Dante Kim on 5/29/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import Foundation
import UIKit
import TinyConstraints
import RealmSwift
var selectedHair = "hairIcon"
var selectedHairColor = "black"
var hairImages = [Feature(name: "DefaultManHair", isSelected: false),Feature(name: "DefaultManHair", isSelected: false),Feature(name: "none", isSelected: false),Feature(name: "DefaultManHair", isSelected: false)]
 var hairColors = [SelectedColor(color: "black", isSelected: false), SelectedColor(color: "brown", isSelected: false), SelectedColor(color: "blonde", isSelected: false), SelectedColor(color: "darkRed", isSelected: false)]
class AvatarSideBar: UIView {
    var results: Results<User>!
    //MARK: - Properties
    lazy var petImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "petIcon")
        iv.backgroundColor = .white
        return iv
    }()
    lazy var saveButton: UIView = {
        let button = UIView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.width(100)
           button.height(40)
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        label.isUserInteractionEnabled = true
        label.text = "SAVE"
        label.font = UIFont(name: "Menlo-Bold",size: 20)
        label.textColor = .white
        label.sizeToFit()
        button.addSubview(label)
        button.layer.cornerRadius = 30
        label.center(in: button)

        button.backgroundColor = brightPurple
  
        return button
    }()
    lazy var hairCollectionView: UICollectionView = {
        let layout = ColumnFlowLayout(cellsPerRow: 1, minimumInteritemSpacing: 5, minimumLineSpacing: 15, sectionInset: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(HairCell.self, forCellWithReuseIdentifier: K.hairCell)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    lazy var colorCollectionView: UICollectionView = {
        let layout = ColumnFlowLayout(cellsPerRow: 4, minimumInteritemSpacing: 15, minimumLineSpacing: 15, sectionInset: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
           layout.scrollDirection = .horizontal
           let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
           cv.register(AvatarColorCell.self, forCellWithReuseIdentifier: K.avatarColorCell)
           cv.translatesAutoresizingMaskIntoConstraints = false
           cv.showsHorizontalScrollIndicator = false
           return cv
    }()
    
    lazy var hairImageViewIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "maleHairIcon")
        iv.backgroundColor = .white
        iv.isUserInteractionEnabled = true
      
        return iv
    }()
    
    lazy var shoeImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.frame.size = CGSize(width: 100, height: 100)
        iv.image = UIImage(named: "converse")
        iv.backgroundColor = .white
        iv.isUserInteractionEnabled = true
//        let shoeTapped = UITapGestureRecognizer(target: self, action: #selector(tapp))
//        iv.addGestureRecognizer(shoeTapped)
        return iv
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        overrideUserInterfaceStyle = .light
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        createStartView()
    }
    
    func createStartView() {
        self.addSubview(petImageView)
        petImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        petImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 140).isActive = true
        petImageView.applyDesign(color: .white)
        
        self.addSubview(hairImageViewIcon)
        hairImageViewIcon.topToBottom(of: petImageView,offset: 15)
        hairImageViewIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        hairImageViewIcon.applyDesign(color: .white)
        let hairTapped = UITapGestureRecognizer(target: self, action: #selector(tappedHair))
        hairImageViewIcon.addGestureRecognizer(hairTapped)
        
        self.addSubview(shoeImageView)
        shoeImageView.topToBottom(of: hairImageViewIcon,offset: 15)
        shoeImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        shoeImageView.applyDesign(color: .white)
         
    }
    
    @objc func tappedShoe(sender: UIImageView) {
        print("tappedShoe")
    }
    
    @objc func tappedHair() {
        removeOtherViews()
        createColorCollectionView()
    }
    
    @objc func tappedSave() {
        hairCollectionView.removeFromSuperview()
        saveButton.removeFromSuperview()
        colorCollectionView.removeFromSuperview()
        saveToRealm()
        createStartView()
    }
    
    func createHairCollectionView() {
        hairCollectionView.delegate = self
        hairCollectionView.dataSource = self
        self.addSubview(hairCollectionView)
        hairCollectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 140).isActive = true
        hairCollectionView.backgroundColor = backgroundColor
        hairCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        hairCollectionView.width(self.frame.width * 0.20)
        hairCollectionView.height(self.frame.height * 0.60)
        self.addSubview(saveButton)
        saveButton.topAnchor.constraint(equalTo: hairCollectionView.bottomAnchor, constant: 15).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        
        saveButton.applyDesign(color: brightPurple)
        let saveTapped = UITapGestureRecognizer(target: self, action: #selector(tappedSave))
        saveButton.addGestureRecognizer(saveTapped)
        
     
    }
    
    func createColorCollectionView() {
        if selectedHair != "none" {
            if selectedHairColor == "" {
                selectedHairColor = "black"
                hairColors[0].isSelected = true
                updateOtherImages(num: 0, array: hairColors, type: "hairColors")
                createColorCollectionViewSlower()
                colorCollectionView.reloadData()
            } else {
                createColorCollectionViewSlower()
            }
        }
        createHairCollectionView()
    }
    
    private final func createColorCollectionViewSlower() {
        colorCollectionView.delegate = self
               colorCollectionView.dataSource = self
               self.addSubview(colorCollectionView)
               colorCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
               colorCollectionView.backgroundColor = backgroundColor
               colorCollectionView.width(self.frame.width * 0.70)
               colorCollectionView.height(self.frame.height * 0.10)
               colorCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100).isActive = true
    }
    
    private final func removeOtherViews() {
        shoeImageView.removeFromSuperview()
        hairImageViewIcon.removeFromSuperview()
        petImageView.removeFromSuperview()
    }
    
    private func saveToRealm() {
        results = uiRealm.objects(User.self)
               for result  in results {
                   if result.isLoggedIn == true {
                       do {
                           try uiRealm.write {
                            result.setValue("\(selectedHairColor)+\(selectedHair)", forKey:"hair")
                           }
                       } catch {
                           print(error)
                       }
                   }
               }
    }
}

extension AvatarSideBar: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.hairCollectionView {
            return hairImages.count
        } else {
            return hairColors.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.hairCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.hairCell, for: indexPath) as! HairCell
            cell.setImage(image: hairImages[indexPath.row].name)
          
            cell.setBorder(border: hairImages[indexPath.row].isSelected)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.avatarColorCell, for: indexPath) as! AvatarColorCell
            cell.setColor(color: hairColors[indexPath.row].color)
            cell.setBorder(border: hairColors[indexPath.row].isSelected)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.hairCollectionView {
            hairImages[indexPath.row].isSelected = true
            selectedHair = hairImages[indexPath.row].name
            if hairImages[indexPath.row].name == "none" {
                colorCollectionView.removeFromSuperview()
                selectedHairColor = ""
                hairImageView.image = UIImage()
            } else  {
                
                if !colorCollectionView.isDescendant(of: self) {
                    selectedHairColor = ""
                    createColorCollectionView()
                }
                hairImageView.image = UIImage(named: "\(selectedHairColor)+\(selectedHair)")
            }
            
            updateOtherImages(num: indexPath.row, array: hairImages, type: "hairImages")
        } else {
           
            hairColors[indexPath.row].isSelected = true
            selectedHairColor = hairColors[indexPath.row].color
            hairImageView.image = UIImage(named: "\(selectedHairColor)+\(selectedHair)")
            updateOtherImages(num: indexPath.row, array: hairColors, type: "hairColors")
        }

        collectionView.reloadData()
    }
    func updateOtherImages(num: Int, array: [Any], type: String) {
        for (i,_) in array.enumerated(){
            if i == num {
                continue
            } else {
                if type == "hairImages" {
                    hairImages[i].isSelected = false
                } else {
                    hairColors[i].isSelected = false
                }
            }
        }
    }
}

