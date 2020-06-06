//
//  MysterViewController.swift
//  Test
//
//  Created by Dante Kim on 4/18/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit
import SCLAlertView
var name: String = ""

class MysteryViewController: UIViewController {
    //MARK: - Properties
    var goldMysteryBox = UIImageView()
    var goldMysteryImage = UIImage()
    var diamondMysteryBox = UIImageView()
    let minLineSpace: CGFloat = 4
    let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        return pc
    }()
    lazy var nextButton: UIButton? = {
        let button = UIButton()
        let largeConfiguration = UIImage.SymbolConfiguration(weight: .bold)
        let carrotGreat = UIImage(systemName: "greaterthan", withConfiguration: largeConfiguration)
        let carrotGreat2 = carrotGreat?.resized(to: CGSize(width: 50, height: 50)).withTintColor(.white, renderingMode:.alwaysOriginal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(carrotGreat2, for: .normal)
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        return button
    }()
    lazy var backButton: UIButton = {
        let button = UIButton()
        let largeConfiguration = UIImage.SymbolConfiguration(weight: .bold)
        let carrotGreat = UIImage(systemName: "lessthan", withConfiguration: largeConfiguration)
        let carrotGreat2 = carrotGreat?.resized(to: CGSize(width: 50, height: 50)).withTintColor(.white, renderingMode:.alwaysOriginal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(carrotGreat2, for: .normal)
        button.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        return button
    }()
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
        MysteryBox(description: "-Box contains 1 common item or 1 rare item. \n-(70% Common/30% Rare)", image: UIImage(named: "commonmysterybox")!, title: "Common Box", color: .black, price: "15"),
        MysteryBox(description: "-Box contains 1 common item and 1 rare or super rare item\n-(70% Rare/30% Super Rare)", image: UIImage(named: "goldmysterybox")!, title: "Gold Box", color: gold, price: "45"),
        MysteryBox(description: "Box contains:\n-1 Common Item\n-1 Rare Item\n-1 Super Rare or Extremely Rare Item", image: UIImage(named: "diamondmysterybox")!, title: "Diamond Box", color: diamond, price: "100")
    ]
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        if #available(iOS 10.0, *) {collectionView.isPrefetchingEnabled = false}
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        view.backgroundColor = darkPurple
        view.addSubview(collectionView)
        collectionView.showsHorizontalScrollIndicator = false
        self.title = "Mystery Boxes"
        configureNavigationBar(color: backgroundColor, isTrans: false)
        navigationController?.navigationBar.barTintColor = darkPurple
        navigationController?.navigationBar.tintColor = .white
        
        collectionView.backgroundColor = darkPurple
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: boxPadding).isActive = true
        collectionView.isPagingEnabled = true;
        
        view.addSubview(nextButton!)
        nextButton?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        nextButton?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc func nextTapped() {
        let visibleItems: NSArray = self.collectionView.indexPathsForVisibleItems as NSArray
        
        var minItem: NSIndexPath = visibleItems.object(at: 0) as! NSIndexPath
        for itr in visibleItems {
            if minItem.row > (itr as AnyObject).row {
                minItem = itr as! NSIndexPath
            }
        }
        
        let nextItem = NSIndexPath(row: minItem.row + 1, section: 0)
        self.collectionView.scrollToItem(at: nextItem as IndexPath, at: .left, animated: true)
    }
    
    @objc func backTapped() {
        let visibleItems: NSArray = self.collectionView.indexPathsForVisibleItems as NSArray
        
        var minItem: NSIndexPath = visibleItems.object(at: 0) as! NSIndexPath
        for itr in visibleItems {
            
            if minItem.row > (itr as AnyObject).row {
                minItem = itr as! NSIndexPath
            }
        }
        
        let nextItem = NSIndexPath(row: minItem.row - 1, section: 0)
        self.collectionView.scrollToItem(at: nextItem as IndexPath, at: .right, animated: true)
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
        if indexPath.row == 1 {
            view.addSubview(backButton)
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            backButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            if !self.view.subviews.contains(nextButton!) {
                view.addSubview(nextButton!)
                nextButton?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
                nextButton?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            }
        } else if indexPath.row == 2 {
            nextButton?.removeFromSuperview()
        } else {
            view.addSubview(nextButton!)
            nextButton?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            nextButton?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            backButton.removeFromSuperview()
        }
        name = self.data[indexPath.row].title
        cell.data = self.data[indexPath.row]
        cell.clipsToBounds = false
        cell.desc.text = self.data[indexPath.row].description
        cell.titleLabel.text = self.data[indexPath.row].title
        cell.titleLabel.textColor = self.data[indexPath.row].color
        cell.buyButton.backgroundColor = self.data[indexPath.row].color
        if self.data[indexPath.row].color == gold {
            cell.buyButton.backgroundColor = darkGold
        }
        cell.buyButton.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedBuy))
        cell.buyButton.addGestureRecognizer(tap)
        cell.priceLabel.text = "Price: \(self.data[indexPath.row].price)"
        return cell
    }
    
    @objc func tappedBuy() {
        let controller = GifController()
        let appearance = SCLAlertView.SCLAppearance(
                  kWindowWidth: 300,
                  kWindowHeight: 250,
                  kButtonHeight: 50,
                  kTitleFont: UIFont(name: "Menlo-Bold", size: 25)!,
                  kTextFont: UIFont(name: "Menlo", size: 15)!,
                  showCloseButton: false,
                  showCircularIcon: false,
                  hideWhenBackgroundViewIsTapped: true,
                  contentViewColor: .white
              )
        let alertView = SCLAlertView(appearance: appearance)
        switch name {
        case "Common Box":
            if coins < 15 {
                alertView.showNotice("Not Enough Coins", subTitle: "")
                return
            }
        case "Gold Box":
            if coins < 45 {
                alertView.showNotice("Not Enough Coins", subTitle: "")
                return
            }
        case "Diamond Box":
            if coins < 100 {
                alertView.showNotice("Not Enough Coins", subTitle: "")
                return
            }
        default:
            return
        }
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        self.present(controller, animated: true, completion: nil)
        return
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(minLineSpace)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: (CGFloat(minLineSpace / 2)), bottom: 0, right: (CGFloat(minLineSpace / 2)))
    }
}


