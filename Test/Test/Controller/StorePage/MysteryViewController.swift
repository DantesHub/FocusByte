//
//  MysterViewController.swift
//  Test
//
//  Created by Dante Kim on 4/18/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit
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
        MysteryBox(description: "There are 100 different items in the Common Mystery Box", image: UIImage(named: "commonmysterybox")!, title: "Common Box", color: .black),
         MysteryBox(description: "There are 40 different items in the Gold Mystery Box", image: UIImage(named: "goldmysterybox")!, title: "Gold Box", color: gold),
         MysteryBox(description: "There are 20 different items in the Diamond Mystery Box", image: UIImage(named: "diamondmysterybox")!, title: "Diamond Box", color: diamond)

     ]
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        if #available(iOS 10.0, *) {collectionView.isPrefetchingEnabled = false}
        collectionView.isUserInteractionEnabled = false
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

        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
        collectionView.isPagingEnabled = true;
        
        view.addSubview(nextButton!)
        nextButton?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        nextButton?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        

    }
    
    @objc func nextTapped() {
        let visibleItems: NSArray = self.collectionView.indexPathsForVisibleItems as NSArray
        
        var minItem: NSIndexPath = visibleItems.object(at: 0) as! NSIndexPath
        for itr in visibleItems {
            print("itr \(itr)")
            if minItem.row > (itr as AnyObject).row {
                print("minItem \(minItem)")
                minItem = itr as! NSIndexPath
            }
        }
        
        let nextItem = NSIndexPath(row: minItem.row + 1, section: 0)
        self.collectionView.scrollToItem(at: nextItem as IndexPath, at: .left, animated: true)
    }
    
    @objc func backTapped() {
        print("back")
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
        print(indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.boxCell, for: indexPath) as! BoxCell
        if indexPath.row == 1 {
            view.addSubview(backButton)
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
            backButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            if !self.view.subviews.contains(nextButton!) {
                view.addSubview(nextButton!)
                nextButton?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
                nextButton?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            }
        } else if indexPath.row == 2 {
            nextButton?.removeFromSuperview()
        } else {
            view.addSubview(nextButton!)
            nextButton?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
            nextButton?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            backButton.removeFromSuperview()
        }
        name  = self.data[indexPath.row].title
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
        return cell
    }
    
    @objc func tappedBuy() {
        print("bought")
        let controller = GifController()
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


