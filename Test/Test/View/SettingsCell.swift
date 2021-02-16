
import UIKit
import RealmSwift
import Firebase
import StoreKit
import Purchases
class SettingsCell:UITableViewCell,SKPaymentTransactionObserver, SKProductsRequestDelegate {
    static var settingsCell = "settingsCell"
    let db = Firestore.firestore()
    var myProduct: SKProduct?
    let proId = "co.byteteam.focusbyte.ProUpgrade"
    var titleLabel = UILabel()
    var results: Results<User>!
    let defaults: UserDefaults = UserDefaults.standard
    lazy var dfmSwitch: UISwitch = {
        let dswitch = UISwitch()
        dswitch.isUserInteractionEnabled = true
        dswitch.translatesAutoresizingMaskIntoConstraints = false
        dswitch.onTintColor = brightPurple
        if deepFocusMode {
            dswitch.setOn(true, animated: false)
        }
        dswitch.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        return dswitch
    }()
    lazy var quoteSwitch: UISwitch = {
        let qswitch = UISwitch()
        qswitch.isUserInteractionEnabled = true
        qswitch.translatesAutoresizingMaskIntoConstraints = false
        qswitch.onTintColor = brightPurple
        if defaults.bool(forKey: "quotes") == true {
            qswitch.setOn(true, animated: false)
        }
        qswitch.addTarget(self, action: #selector(quoteToggled(_:)), for: .valueChanged)
        return qswitch
    }()
    

    @available(iOS 13.0, *)
    lazy var syncView: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "arrow.2.circlepath")
        iv.tintColor = .white
        iv.width(35)
        iv.height(35)
        return iv
    }()
    
    lazy var emailView: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "envelope.fill")
        iv.tintColor = .white
        iv.width(35)
        iv.height(35)
        return iv
    }()
    
    lazy var restoreView: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "clock.fill")
        iv.tintColor = .white
        iv.width(35)
        iv.height(35)
        return iv
    }()
    
    lazy var lockView: UIImageView = {
          let iv = UIImageView()
           iv.translatesAutoresizingMaskIntoConstraints = false
           iv.image = defaults.bool(forKey: "isPro") ? UIImage(systemName: "smiley.fill") : UIImage(systemName: "lock.fill")
           iv.tintColor = .white
           iv.width(35)
           iv.height(35)
           return iv
       }()
    
    lazy var starView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "star.fill")
        iv.tintColor = .white
        iv.width(35)
        iv.height(35)
        iv.isUserInteractionEnabled = true
 
        return iv
      }()
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         configureUI()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: helper funcs
    func configureUI() {
        fetchProducts()
        self.selectionStyle = .none
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "Menlo", size: 17)
        titleLabel.centerY(to: self)
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -45).isActive = true
    }
    
    func setTitle(title: String, type: String) {
        if type == "dfm" {
            contentView.addSubview(dfmSwitch)
            dfmSwitch.centerY(to: self)
            dfmSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        } else if type == "sync" {
            contentView.addSubview(syncView)
            syncView.centerY(to: self)
            syncView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        } else if type == "rate" {
            contentView.addSubview(starView)
            starView.centerY(to: self)
            starView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
            let starTapped = UITapGestureRecognizer(target: self, action: #selector(tappedStar))
             self.addGestureRecognizer(starTapped)
        } else if type == "quotes" {
            contentView.addSubview(quoteSwitch)
            quoteSwitch.centerY(to: self)
            quoteSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        } else if type == "gopro" {
            contentView.addSubview(lockView)
            lockView.centerY(to: self)
            lockView.trailingAnchor.constraint(equalTo:
            contentView.trailingAnchor, constant: -15).isActive = true
            let proTapped = UITapGestureRecognizer(target: self, action: #selector(tappedPro))
            if defaults.bool(forKey: "isPro") != true {
                self.addGestureRecognizer(proTapped)
            } else {
                titleLabel.text = "You're Pro!"
                return
            }
            
        } else if type == "restore" {
            contentView.addSubview(restoreView)
            restoreView.centerY(to: self)
            restoreView.trailingAnchor.constraint(equalTo:
            contentView.trailingAnchor, constant: -15).isActive = true
            let restoreTapped = UITapGestureRecognizer(target: self, action: #selector(tappedRestore))
            self.addGestureRecognizer(restoreTapped)
        } else if type == "email" {
            contentView.addSubview(emailView)
            emailView.centerY(to: self)
            titleLabel.font = UIFont(name: "Menlo", size: 13)
            emailView.trailingAnchor.constraint(equalTo:
            contentView.trailingAnchor, constant: -15).isActive = true
        } else if type == "warning" {
            if UserDefaults.standard.bool(forKey: "isPro") {
                return
            }
            titleLabel.textAlignment = .center
        }
        titleLabel.text = title
        
    }
    private final func fetchProducts() {
       let request = SKProductsRequest(productIdentifiers: [proId])
         request.delegate = self
         request.start()
     }
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first {
            myProduct = product
        }
    }
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing :
                break
            case .purchased, .restored:
                //unlock their item
                print("success")
                save()
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
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
                  "exp": exp
              ]) { (error) in
                  if let e = error {
                      print("There was a issue saving data to firestore \(e) ")
                  } else {
                      print("Succesfully made user pro")
                    let controller = ContainerController(center: TimerController())
                    controller.modalPresentationStyle = .fullScreen
                    self.parentViewController!.presentInFullScreen(UINavigationController(rootViewController: controller), animated: false,  completion: nil)
                    upgradedToPro = true
                  }
              }
          }
    }
    @objc func tappedRestore() {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
        let okayAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: {
                                        (action : UIAlertAction!) -> Void in })
        alertController.addAction(okayAction)
        Purchases.shared.restoreTransactions { (purchaserInfo, error) in
            if purchaserInfo?.entitlements.all["premium"]?.isActive == true {
                alertController.title = "Purchase Restored!"
                UserDefaults.standard.setValue(true, forKey: "isPro")
            } else {
                alertController.title = "Unable to restore purchase on this account"
                UserDefaults.standard.setValue(false, forKey: "isPro")
            }
            self.parentViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    @objc func tappedPro() {
        let controller = GoProViewController()
                  controller.modalPresentationStyle = .fullScreen
        self.parentViewController?.presentInFullScreen(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    @objc func quoteToggled(_ sender:UISwitch!) {
        if (sender.isOn == true) {
            defaults.set(true, forKey: "quotes")
        } else {
            defaults.set(false, forKey: "quotes")
        }
    }
    
    @objc func switchToggled(_ sender:UISwitch!) {
           if (sender.isOn == true){
                 deepFocusMode = true
             }
             else{
                 deepFocusMode = false
           }
           saveToRealm()
       }
    
    @objc func tappedStar() {
        SKStoreReviewController.requestReview()
    }


    //MARK: - realm
       func saveToRealm() {
           results = uiRealm.objects(User.self)
           for result  in results {
               if result.isLoggedIn == true {
                   do {
                       try uiRealm.write {
                           result.setValue(deepFocusMode, forKey: "deepFocusMode")
                       }
                   } catch {
                       print(error)
                   }
               }
           }
       }
}
