//
//  TagViewCell.swift
//  Test
//
//  Created by Dante Kim on 5/21/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit
import TinyConstraints
import SCLAlertView
import Firebase
import RealmSwift

var selectedColor = "red"
var tagTitle = ""
class TagViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    //MARK: - Properties
    var color = "gray"
    weak var delegate: CustomCellUpdater?
    var results: Results<User>!
    let db = Firestore.firestore()
    var title: String = ""
    var titleLabel = UILabel()
    var colors = ["red","pink","orange","yellow","lightgreen","green","turq", "blue","skyblue","purple"]
    var collectionViewAlert: UICollectionView!
//    override var isSelected: Bool {
//          didSet {
//            print("setting")
//              if isSelected {
//                self.accessoryType = .checkmark
//                self.delegate?.updateTableView()
//              } else {
//                self.accessoryType = .none
//              }
//          }
//      }
     //MARK: - Init
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, color: String, title: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.color = color
        self.title = title
        configureCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Functinos
    func configureCellUI() {
        
        self.selectionStyle = .none
        titleLabel.font = UIFont(name: "Menlo", size: 15)
        titleLabel.text = title
        titleLabel.sizeToFit()
        contentView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60).isActive = true
        titleLabel.centerY(to: contentView)
        let circleLayer = CAShapeLayer();
        circleLayer.path = UIBezierPath(ovalIn: CGRect(x: contentView.center.x - 140, y: titleLabel.center.y + 7, width: 23, height: 23)).cgPath;
        let tagColor = K.getColor(color: color)
        if tagColor == .white {
            let largeConfiguration = UIImage.SymbolConfiguration(weight: .bold)
            let plusImage = UIImage(systemName: "plus", withConfiguration: largeConfiguration)
            let resizedPlusImage = plusImage?.resized(to: CGSize(width: 20, height: 20)).withTintColor(.black, renderingMode:.alwaysOriginal)
            let plusImageView = UIImageView()
            plusImageView.image = resizedPlusImage
            plusImageView.sizeToFit()
            contentView.addSubview(plusImageView)
            plusImageView.center.x = contentView.center.x - 130
            plusImageView.center.y = titleLabel.center.y + 16
            let tappedPlus = UITapGestureRecognizer(target: self, action: #selector(plusTapped))
            contentView.addGestureRecognizer(tappedPlus)
            
        } else {
            circleLayer.fillColor = tagColor.cgColor
            contentView.layer.addSublayer(circleLayer)
        }
    }
    
    @objc func plusTapped() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
//        layout.itemSize = CGSize(width: 22, height: 22)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 15
        collectionViewAlert = UICollectionView(frame: CGRect(x: 10, y: 10, width: 260, height: 120), collectionViewLayout: layout)
        collectionViewAlert.dataSource = self
        collectionViewAlert.delegate = self
        collectionViewAlert.register(ColorCell.self, forCellWithReuseIdentifier: K.chooseColorCell)
        collectionViewAlert.backgroundColor = UIColor.white
        collectionViewAlert.isScrollEnabled = false
        let appearance = SCLAlertView.SCLAppearance(
            kWindowWidth: 300,
            kWindowHeight: 140,
            kButtonHeight: 45,
            kTitleFont: UIFont(name: "Menlo", size: 18)!,
            kTextFont: UIFont(name: "Menlo", size: 15)!,
            showCloseButton: false,
            showCircularIcon: false,
            disableTapGesture: true
        )
        let showTimeout = SCLButton.ShowTimeoutConfiguration(prefix: "(", suffix: " s)")
        let alertView = SCLAlertView(appearance: appearance)
        let text = alertView.addTextField("Enter Tag name")
        text.overrideUserInterfaceStyle = .light
        text.becomeFirstResponder()
        alertView.addButton("Done\n", backgroundColor: brightPurple, textColor: .white, showTimeout: showTimeout) {
            if text.text!.count == 0 {
                text.text = "Must Input Text!"
            } else {
                let tag = Tag(name: text.text!, color: selectedColor, selected: true)
                //save to firebase & realm
                if tagDictionary.contains(where: { $0.name == tag.name }) {
                    return
                } else {
                    self.saveToRealm(tag: tag)
                    tagSelected = tag.name
                    tagColor = tag.color
                    self.delegate?.updateTableView()
                }
            }
         
        }
        alertView.addButton("Cancel", backgroundColor: lightLavender, textColor: .white, showTimeout: showTimeout) {
            return
        }

        let subview = UIView(frame: CGRect(x:0,y:0,width:300,height:120))
        subview.addSubview(self.collectionViewAlert)
        alertView.customSubview = subview
        let selectedIndexPath = NSIndexPath(item: 0, section: 0)
        collectionViewAlert.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: [])
        selectedColor = "red"
        alertView.showCustom("Choose Color", subTitle: "Cancel", color: lightLavender, icon: UIImage())
        
    }
    
    func saveToFirebase(fbTagDict: [String:String]) {
        if let _ = Auth.auth().currentUser?.email {
            let email = Auth.auth().currentUser?.email
            db.collection(K.userPreferenes).document(email!).updateData([
                "tags": fbTagDict
            ]) { (error) in
                if let e = error {
                    print("There was a issue saving data to firestore \(e) ")
                } else {
                    print("Succesfully saved tags")
                }
            }
        }
    }
    
    func saveToRealm(tag: Tag) {
        var fbTagDict = [String:String]()
        results = uiRealm.objects(User.self)
        tagDictionary.remove(at: 0)
        for result  in results {
            if result.isLoggedIn == true {
                do {
                    try uiRealm.write {
                        for tag in tagDictionary {
                            fbTagDict[tag.name] = tag.color
                            tag.selected = false
                        }
                        fbTagDict[tag.name] = tag.color
                        tagDictionary.insert(tag, at: 0)
                        result.setValue(tagDictionary, forKey: "tagDictionary")
                    }
                } catch {
                    print(error)
                }
            }
        }
        saveToFirebase(fbTagDict: fbTagDict)
        tagDictionary.insert(Tag(name: "Create Tag", color: "plus", selected: false), at: 0)
    }
    
    
    //MARK: - CollectionView
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return self.colors.count
       }
    
       public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/8), height: collectionView.frame.height/4
        )
          }

       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.chooseColorCell, for: indexPath as IndexPath) as! ColorCell
            
            cell.setColor(color: self.colors[indexPath.item] )
            return cell
       }
    

       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            selectedColor = colors[indexPath.item]
    }

}


//MARK: - COLOR Cell
class ColorCell: UICollectionViewCell {
    lazy var checked: UILabel = {
       let label = UILabel()
        label.text = "checked"
        label.sizeToFit()
        return label
    }()
    var color = ""
    var checkView = UIImageView()
    let largeConfiguration = UIImage.SymbolConfiguration(weight: .bold)
    var checkImage: UIImage {
        return UIImage(systemName: "checkmark", withConfiguration: largeConfiguration)!
    }
    var resizedCheckImage:UIImage {
        return checkImage.resized(to: CGSize(width: 14, height: 14)).withTintColor(.white, renderingMode:.alwaysOriginal)
    }
   override init(frame:CGRect) {
    super.init(frame: frame)
    contentView.layer.masksToBounds = true
    contentView.layer.cornerRadius = contentView.frame.size.width / 2
    contentView.isUserInteractionEnabled = true
    contentView.backgroundColor = .black
    checkView.image = resizedCheckImage
    checkView.sizeToFit()
    checkView.isHidden = true
    contentView.addSubview(checkView)
    checkView.center = contentView.center
    

    }
    func setColor(color: String) {
        self.color = color
        contentView.backgroundColor = K.getColor(color: color)
    }
    
    override var isSelected: Bool {

        didSet {
            if isSelected {
                checkView.isHidden = false
            } else {
                checkView.isHidden = true
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol CustomCellUpdater: class {
    func updateTableView()
}
