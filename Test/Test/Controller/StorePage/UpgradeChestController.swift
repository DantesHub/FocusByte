//
//  UpgradeChestController.swift
//  Test
//
//  Created by Dante Kim on 6/5/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit
import SCLAlertView
import RealmSwift
import Firebase
import StoreKit
var onUpgrade = false
var boughtChest = false
class UpgradeChestController: UIViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate{
    var myProducts = [SKProduct?]()
    let goldId = "co.byteteam.focusbyte.GoldChest"
    let epicId = "co.byteteam.focusbyte.EpicChest"
    let diamondId = "co.byteteam.focusbyte.DiamondChest"
    
    let data = [
        MysteryBox(description: "Receive 2x (double) coins for the next seven days", image: UIImage(named: "goldChest")!, title: "Gold Chest", color: gold, price: "  0.99"),
        MysteryBox(description: "Receive 2x (double) exp points for the next seven days", image: UIImage(named: "epicChest")!, title: "Epic Chest", color: superPurple, price: "  0.99"),
        MysteryBox(description: "Receive 2x coins and exp points for the next 21 days", image: UIImage(named: "diamondChest")!, title: "Diamond Chest", color: diamond, price: "  1.99")
    ]
    //MARK: - Properties
    let db = Firestore.firestore()
    var results: Results<User>!
    let minLineSpace: CGFloat = 4
     let pageControl: UIPageControl = {
         let pc = UIPageControl()
         pc.pageIndicatorTintColor = .lightGray
         return pc
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
    //MARK: - Init
     override func viewDidLoad() {
        onUpgrade = true
         super.viewDidLoad()
        fetchProducts()
         SKPaymentQueue.default().add(self)
         configureUI()
         if #available(iOS 10.0, *) {collectionView.isPrefetchingEnabled = false}
         collectionView.isScrollEnabled = false
         collectionView.delegate = self
         collectionView.dataSource = self
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        onUpgrade = false
    }
    
    //MARK: - Helper Functions
      func configureUI() {
          view.backgroundColor = brightPurple
          view.addSubview(collectionView)
          collectionView.showsHorizontalScrollIndicator = false
          self.title = "Chests"
//          configureNavigationBar(color: brightPurple, isTrans: false)
          navigationController?.navigationBar.barTintColor = brightPurple
          navigationController?.navigationBar.tintColor = .white
          collectionView.backgroundColor = brightPurple
          collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
          
          collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
          collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
          collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: boxPadding - 40).isActive = true
          collectionView.isPagingEnabled = true;
        
          
          view.addSubview(nextButton!)
          nextButton?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
          nextButton?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

      }
    @objc func tappedExit() {
        print("tappedExit")
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
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        for product in response.products {
            print(product.productIdentifier)
            myProducts.append(product)
        }
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing :
                break
            case .purchased, .restored:
                //unlock their item
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                save()
                print("success")
                break
            case .failed, .deferred:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                print("failed")
                break
            default:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            }
        }
       }
    
}

extension UpgradeChestController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
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
        let attributedDesc: NSAttributedString = self.data[indexPath.row].description.attributedStringWithColor(["2x"], color: self.data[indexPath.row].color)
        cell.desc.attributedText = attributedDesc
        cell.desc.font = UIFont(name: "Menlo-Bold", size: chestFont)
        cell.desc.textAlignment = .center
        cell.titleLabel.text = self.data[indexPath.row].title
        cell.titleLabel.textColor = self.data[indexPath.row].color
        cell.buyButton.backgroundColor = self.data[indexPath.row].color
        cell.buyButton.setTitle((self.data[indexPath.row].price), for: .normal)
        if self.data[indexPath.row].color == gold {
            cell.buyButton.backgroundColor = darkGold
        }
        cell.buyButton.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedBuy))
        cell.buyButton.addGestureRecognizer(tap)
        return cell
    }
    
    @objc func tappedBuy() {
      //save typeofchest + startDate
      startPurchase()
      //lock upgrade chests
    }
    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: [diamondId, epicId, goldId])
        print(request)
        request.delegate = self
        request.start()
    }
    private final func startPurchase() {
        var num = 0
        switch name {
               case "Gold Chest":
                   num = 2
               case "Epic Chest":
                   num = 1
               case "Diamond Chest":
                   num = 0
               default:
                   print("im still")
               }
        guard let myProduct = myProducts[num] else {
            return
        }
        if SKPaymentQueue.canMakePayments() {
            //Can make payments
            let payment = SKPayment(product: myProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            //user cant make payments
            return
        }
    }
    
    private final func save() {
        var days = 0
        switch name {
        case "Gold Chest":
            days = 7
            Analytics.logEvent("Gold_Chest", parameters: ["level":level])
        case "Epic Chest":
            days = 7
            Analytics.logEvent("Epic_Chest", parameters: ["level":level])
        case "Diamond Chest":
            days = 14
            Analytics.logEvent("Diamond_Chest", parameters: ["level":level])
        default:
            print("im still")
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        let modifiedDate = Calendar.current.date(byAdding: .day, value: days, to: date)!
        let result = formatter.string(from: modifiedDate)
        inventoryArray.append("\(result) + \(name)")
        
        //update data in firebase
        if let _ = Auth.auth().currentUser?.email {
            let email = Auth.auth().currentUser?.email
            self.db.collection(K.userPreferenes).document(email!).updateData([
                "inventoryArray": inventoryArray
            ]) { (error) in
                if let e = error {
                    print("There was a issue saving data to firestore \(e) ")
                } else {
                    print("Succesfully saved new items")
                }
            }
        }
        //save To Realm
        let realmInventory = List<String>()
        for item in inventoryArray {
            realmInventory.append(item)
        }
        results = uiRealm.objects(User.self)
        for result  in results {
            if result.isLoggedIn == true {
                do {
                    try uiRealm.write {
                        result.setValue(realmInventory, forKey: "inventoryArray")
                    }
                } catch {
                    print(error)
                }
            }
        }
        
        let controller = ContainerController(center: TimerController())
        controller.modalPresentationStyle = .fullScreen
        presentInFullScreen(UINavigationController(rootViewController: controller), animated: false, completion: nil)
        boughtChest = true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(minLineSpace)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: (CGFloat(minLineSpace / 2)), bottom: 0, right: (CGFloat(minLineSpace / 2)))
    }
}
