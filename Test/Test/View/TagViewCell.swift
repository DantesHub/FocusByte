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


class TagViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    //MARK: - Properties
    var color = "gray"
    var title: String = ""
    var titleLabel = UILabel()
    var colors = ["red","blue","green","purple","red","blue","green","purple","red","blue"]
    var collectionViewAlert: UICollectionView!
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
            kTextFont: UIFont(name: "Menlo", size: 15)!,
            disableTapGesture: true
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addTextField("Enter category name").overrideUserInterfaceStyle = .light
        let subview = UIView(frame: CGRect(x:0,y:0,width:300,height:120))
        subview.addSubview(self.collectionViewAlert)
        alertView.customSubview = subview
        alertView.showEdit("Choose color", subTitle: "This alert view has buttons")
        
    }


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
           print("You selected cell #\(indexPath.item)!")
       }

}

class ColorCell: UICollectionViewCell {
    lazy var checked: UILabel = {
       let label = UILabel()
        label.text = "checked"
        label.sizeToFit()
        return label
    }()
    var checkView = UIImageView()
   override init(frame:CGRect) {
        super.init(frame: frame)
//        contentView.frame.size = CGSize(width: , height: 5 )
     
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = contentView.frame.size.width / 2
        
        let tap = UIGestureRecognizer(target: self, action: #selector(colorTapped))
        self.addGestureRecognizer(tap)
    }
    func setColor(color: String) {
        contentView.backgroundColor = K.getColor(color: color)
        let largeConfiguration = UIImage.SymbolConfiguration(weight: .bold)
             let checkImage = UIImage(systemName: "checkmark", withConfiguration: largeConfiguration)
        let resizedCheckImage = checkImage?.resized(to: CGSize(width: 5, height: 5)).withTintColor(.white, renderingMode:.alwaysOriginal)
        checkView.image = resizedCheckImage
        contentView.addSubview(checkView)
        checkView.center = contentView.center
        
    }
    
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted { contentView.addSubview(checked)}
            else { checked.removeFromSuperview() }
        }
    }
    

    @objc func colorTapped() {
        print("binged")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
