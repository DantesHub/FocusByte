
import UIKit
import RealmSwift
import Firebase
import StoreKit
class SettingsCell:UITableViewCell {
    static var settingsCell = "settingsCell"
    let db = Firestore.firestore()
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

    lazy var syncView: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "arrow.2.circlepath")
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
           iv.image = defaults.bool(forKey: "isPro") ? UIImage(named: "smiley.fill") : UIImage(systemName: "lock.fill")
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
        self.selectionStyle = .none
        self.backgroundColor = backgroundColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        titleLabel.font = UIFont(name: "Menlo", size: 17)
        titleLabel.centerY(to: self)
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
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
            }
        } else if type == "restore" {
            contentView.addSubview(restoreView)
            restoreView.centerY(to: self)
            restoreView.trailingAnchor.constraint(equalTo:
            contentView.trailingAnchor, constant: -15).isActive = true
            let restoreTapped = UITapGestureRecognizer(target: self, action: #selector(tappedRestore))
            self.addGestureRecognizer(restoreTapped)
        }
        titleLabel.text = title
        
    }
    @objc func tappedRestore() {
        print("tappedRestore")
    }
    @objc func tappedPro() {
        print("go pro")
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
