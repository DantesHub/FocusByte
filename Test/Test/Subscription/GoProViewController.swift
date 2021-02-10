//
//  GoProViewController.swift
//  Test
//
//  Created by Dante Kim on 6/7/20.
//

import UIKit
import StoreKit
import Firebase
import Purchases
class GoProViewController: UIViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    let db = Firestore.firestore()
    var myProduct: SKProduct?
    let proId = "co.byteteam.focusbyte.ProUpgrade"
    var iphone8 = false
    var goProPadding:CGFloat = 30
    var onePadding: CGFloat = 25
    var descSize: CGFloat {
           get {
               var descSize: CGFloat = 16
               if UIDevice().userInterfaceIdiom == .phone {
                   switch UIScreen.main.nativeBounds.height {
                   case 1334:
                       //Iphone 8
                      descSize = 14
                      iphone8 = true
                      goProPadding = 10
                    onePadding = 10
                   case 1920, 2208:
                      descSize = 14
                      iphone8 = true
                    goProPadding = 10
                    onePadding = 10
                   //("iphone 8plus")
                   case 2436:
                      descSize = 16
                   //print("IPHONE X, IPHONE XS, IPHONE 11 PRO")
                   case 2688:
                    descSize = 16
                   //print("IPHONE XS MAX, IPHONE 11 PRO MAX")
                   case 1792:
                   descSize = 16
                   //print("IPHONE XR, IPHONE 11")
                   default:
                       descSize = 16
                   }
               }
               return descSize
           }
       }
    var titleLabel = UILabel()
    var subTitle1 = UILabel()
    var subText1 = UILabel()
    var goProButton = UIView()
    var goProLabel = UILabel()
    var subTitle2 = UILabel()
    var subText2 = UILabel()
    var subTitle3 = UILabel()
    var subText3 = UILabel()
    var subTitle4 = UILabel()
    var subText4 = UILabel()
    var subTitle5 = UILabel()
    var subText5 = UILabel()

    override func viewDidLoad() {
        fetchProducts()
        _ = descSize
        super.viewDidLoad()
        configureNavigationBar(color: .white, isTrans: false)
        view.backgroundColor = .white
        navigationItem.title = "Pro Upgrade"
        navigationController?.navigationBar.barStyle = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
         NSAttributedString.Key.font: UIFont(name: "Menlo-Bold", size: 21)!]
        navigationController?.navigationBar.barTintColor = darkGold
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        titleLabel.font = UIFont(name: "Menlo", size: iphone8 ? 20 : 28)
        titleLabel.centerX(to: view)
        titleLabel.text = "One Time Purchase"
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        
        //Stats
        subTitle1.translatesAutoresizingMaskIntoConstraints = false
        subTitle1.font = UIFont(name: "Menlo", size: 20)
        view.addSubview(subTitle1)
        subTitle1.topToBottom(of: titleLabel, offset: onePadding)
        subTitle1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        subTitle1.text = "📊 Access To Your Statistics"
        subTitle1.textColor = darkGold
        
        view.addSubview(subText1)
        subText1.translatesAutoresizingMaskIntoConstraints = false
        subText1.font = UIFont(name: "Menlo", size: descSize)
        subText1.topToBottom(of: subTitle1)
        subText1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        subText1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        subText1.numberOfLines = 0
        subText1.text = "Get access valuable insights and how your time is being spent."
        //Saved data
        view.addSubview(subTitle2)
        subTitle2.translatesAutoresizingMaskIntoConstraints = false
        subTitle2.font = UIFont(name: "Menlo", size: 20)
        view.addSubview(subTitle2)
        subTitle2.topToBottom(of: subText1, offset: 25)
        subTitle2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        subTitle2.text = "☁️ Saved Data"
        subTitle2.textColor = darkGold
        
        view.addSubview(subText2)
        subText2.translatesAutoresizingMaskIntoConstraints = false
        subText2.font = UIFont(name: "Menlo", size: descSize)
        subText2.topToBottom(of: subTitle2)
        subText2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        subText2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        subText2.numberOfLines = 0
        subText2.text = "Data saved on the cloud so it's never lost, even if you log on to a different device"
        
        //Access to Tags
        view.addSubview(subTitle3)
        subTitle3.translatesAutoresizingMaskIntoConstraints = false
        subTitle3.font = UIFont(name: "Menlo", size: 20)
        view.addSubview(subTitle3)
        subTitle3.topToBottom(of: subText2, offset: 25)
        subTitle3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        subTitle3.text = "🏷 Custom Tags"
        subTitle3.textColor = darkGold
        
        view.addSubview(subText3)
        subText3.translatesAutoresizingMaskIntoConstraints = false
        subText3.font = UIFont(name: "Menlo", size: descSize)
        subText3.topToBottom(of: subTitle3)
        subText3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        subText3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        subText3.numberOfLines = 0
        subText3.text = "Tag your timer sessions with custom tags and colors, data is then visible on your stats page"
        
        //Quotes
        view.addSubview(subTitle4)
        subTitle4.translatesAutoresizingMaskIntoConstraints = false
        subTitle4.font = UIFont(name: "Menlo", size: 20)
        view.addSubview(subTitle4)
        subTitle4.topToBottom(of: subText3, offset: 25)
        subTitle4.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        subTitle4.text = "🖋 Exclusive Quotes"
        subTitle4.textColor = darkGold
        
        view.addSubview(subText4)
        subText4.translatesAutoresizingMaskIntoConstraints = false
        subText4.font = UIFont(name: "Menlo", size: descSize)
        subText4.topToBottom(of: subTitle4)
        subText4.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        subText4.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        subText4.numberOfLines = 0
        subText4.text = "Get an additional 20+ quotes that are randomized every session"
        
        view.addSubview(subTitle5)
        subTitle5.translatesAutoresizingMaskIntoConstraints = false
        subTitle5.font = UIFont(name: "Menlo", size: 20)
        view.addSubview(subTitle5)
        subTitle5.topToBottom(of: subText4, offset: 25)
        subTitle5.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        subTitle5.text = "💜 Coming Soon..."
        subTitle5.textColor = darkGold
        
        view.addSubview(subText5)
        subText5.translatesAutoresizingMaskIntoConstraints = false
        subText5.font = UIFont(name: "Menlo", size: descSize)
        subText5.topToBottom(of: subTitle5)
        subText5.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        subText5.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        subText5.numberOfLines = 0
        subText5.text = "With enough support we are planning to give pro members access to soundtracks, dark mode, and the ability to study with friends"
            
        
        view.addSubview(goProButton)
        goProButton.translatesAutoresizingMaskIntoConstraints = false
        goProButton.centerX(to: view)
        goProButton.topToBottom(of: subText5, offset: goProPadding)
        goProButton.width(view.frame.width * 0.70)
        goProButton.height(view.frame.height * 0.10)
        goProButton.backgroundColor = darkGold
        goProButton.addSubview(goProLabel)
        goProLabel.translatesAutoresizingMaskIntoConstraints = false
        goProLabel.center(in: goProButton)
        goProLabel.font = UIFont(name: "Menlo-Bold", size: 20)
        goProLabel.text = "Go Pro!"
        goProLabel.textColor = .white
        goProButton.applyDesign(color: darkGold)
        let proTapped = UITapGestureRecognizer(target: self, action: #selector(tappedPro))
        goProButton.addGestureRecognizer(proTapped)
    }
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing :
                break
            case .purchased, .restored:
                //unlock their item
                save()
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                Analytics.logEvent(AnalyticsEventPurchase, parameters: nil)
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
    private final func save() {
        UserDefaults.standard.set(true, forKey: "isPro")
        //update data in firebase
          if let _ = Auth.auth().currentUser?.email {
              let email = Auth.auth().currentUser?.email
            self.db.collection(K.userPreferenes).document(email!).updateData([
                "isPro": true,
                "coins": coins,
                "inventoryArray": inventoryArray,
                "exp": exp,
                "TimeData": timeData
              ]) { (error) in
                  if let e = error {
                      print("There was a issue saving data to firestore \(e) ")
                  } else {
                      print("Succesfully made user pro")
                    let controller = ContainerController(center: TimerController())
                    controller.modalPresentationStyle = .fullScreen
                    self.presentInFullScreen(UINavigationController(rootViewController: controller), animated: false, completion: nil)
                    boughtChest = true
                  }
              }
          }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first {
            myProduct = product
        }
    }
    private final func fetchProducts() {
      let request = SKProductsRequest(productIdentifiers: [proId])
        request.delegate = self
        request.start()
    }
    @objc func tappedPro() {
        guard let myProduct = myProduct else {
            return
        }
        if SKPaymentQueue.canMakePayments() {
            //Can make payments
            print("over here")
            let payment = SKPayment(product: myProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            //user cant make payments
            return
        }
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
}
