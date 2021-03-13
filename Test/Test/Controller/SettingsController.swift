
//  SettingsController.swift
//  Test
//
//  Created by Dante Kim on 4/9/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import MessageUI
import WidgetKit
import AppsFlyerLib
var loggedOut = false
var noLoginGlobal = false
class SettingsController: UIViewController, MFMailComposeViewControllerDelegate, NoLoginDelegate {
    struct Setting {
        var title: String
        var type: String
    }
    //MARK: - Properties
    var minutes: CGFloat = 0
    let db = Firestore.firestore()
    var warning:UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Menlo", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var data = [Setting(title: "Deep Focus Mode (Notifs)", type: "dfm"),Setting(title: "Quotes on home screen", type: "quotes"), Setting(title: "Set Default Time", type: "defaultTimer"),  Setting(title: "Save to other devices", type: "sync"), Setting(title: "Rate Us!", type: "rate"), Setting(title: "Go Pro!", type: "gopro"), Setting(title: "Restore Purchase", type: "restore"),Setting(title: "Join the Discord!", type: "discord"), Setting(title: "Email me! Feedback or Bugs :)", type: "email"),Setting(title: "⚠️❗️Non Pro user data is not saved to cloud", type: "warning")]
    let containerView = UIView()
    let window = UIApplication.shared.keyWindow
    var results: Results<User>!
    let logOutButton = UIButton()
    let parentView = UIView()
    let pickerView = UIPickerView()
    var set = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 80, y: 10, width: 75, height: 25))
    var delegate: ContainerControllerDelegate!
    var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.settingsCell)
        tv.isScrollEnabled = false
   
        return tv
    }()
    var noLogin = false

    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        configureUI()
}
    
    
    //MARK: - Helper functions
    func configureUI() {
        configureNavigationBar(color: backgroundColor, isTrans: false)
        view.backgroundColor = backgroundColor
        navigationController?.navigationBar.backgroundColor = backgroundColor
        navigationItem.title = "Settings"
         navigationItem.leftBarButtonItem =  UIBarButtonItem(image: resizedMenuImage?.withTintColor(.white), style: .plain, target: self, action: #selector(handleMenuToggle))
        
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        tableView.backgroundColor = backgroundColor
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.isScrollEnabled = true
        tableView.bottomToSuperview()
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = view.frame.height * 0.09
        DispatchQueue.main.async { [self] in
            self.tableView.scrollToRow(at: IndexPath(row: UserDefaults.standard.bool(forKey: "isPro") ? data.count - 2 : data.count - 1, section: 0), at: .bottom, animated: false)
        }
        updateLogoutButton()
    }

    //MARK: - Handlers
      @objc func handleMenuToggle() {
          if !isPlaying {
              delegate?.handleMenuToggle(forMenuOption: nil)
          }
      }
    
    @objc func logOutPressed() {
        if noLogin {
            AppsFlyerLib.shared().logEvent("tapped_login_settings", withValues: [AFEventParamContent: "true"])
            noLoginGlobal = true
            let controller = LoginViewController()
            controller.modalPresentationStyle = .fullScreen
            controller.delegate = self
            self.presentInFullScreen(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        } else {
         results = uiRealm.objects(User.self)
                  for result  in results {
                      if result.isLoggedIn == true {
                         UserDefaults.standard.setValue(true, forKey: "noLogin")
                          do {
                             try uiRealm.write {
                                 result.name = nil
                                 result.coins = 0
                                  result.gender = nil
                                 result.exp = 0
                                 result.deepFocusMode = true
                                 result.hair = nil
                                 result.eyes = nil
                                 result.skin = nil
                                 result.shirt = nil
                                 result.pet = nil
                                 result.pants = nil
                                 result.shoes = nil
                                 result.backpack = nil
                                 result.glasses = nil
                                result.inventoryArray.removeAll()
                                 result.timeArray.removeAll()
                                 result.tagDictionary.removeAll()
                                result.isLoggedIn = false
                             }
                          } catch {
                             print(error)
                         }
                  
                         
                     }
                  }
             do { try Auth.auth().signOut() }
             catch { print("already logged out") };
          UserDefaults.standard.set(false, forKey: "isPro")
            UserDefaults.standard.set(nil, forKey: "appleAuthorizedUserIdKey")
             expDate = ""
            enteredForeground = false
            noLoginGlobal = false
            petImageView.image = UIImage()
            backpackView.image = UIImage()
            let defaults = UserDefaults.standard
            let dictionary = defaults.dictionaryRepresentation()
            dictionary.keys.forEach { key in
                if !key.contains("com.revenuecat.userdefaults") {
                    defaults.removeObject(forKey: key)}
                }
             let controller = UINavigationController(rootViewController: WelcomeViewController())
             controller.modalPresentationStyle = .fullScreen
             self.presentInFullScreen(controller, animated: false, completion: nil)
        }
    }
    func updateLogoutButton() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        noLogin = UserDefaults.standard.bool(forKey: "noLogin")
        logOutButton.setTitle(!noLogin ? "Logout" : "Login", for: .normal)
        logOutButton.titleLabel?.font = UIFont(name: "Menlo-Bold", size: 20)
        logOutButton.titleLabel?.textAlignment = .center
        logOutButton.layer.cornerRadius = 25
        logOutButton.backgroundColor = !noLogin ? darkRed : brightPurple
        logOutButton.layoutSubviews()
        customView.addSubview(logOutButton)
        logOutButton.centerX(to: customView)
        logOutButton.centerY(to: customView)
        logOutButton.width(view.frame.width * 0.60)
        logOutButton.height(60)
        logOutButton.addTarget(self, action: #selector(logOutPressed), for: .touchUpInside)
        tableView.tableFooterView = customView
        

    }
    
}
//MARK: - extension
extension SettingsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserDefaults.standard.bool(forKey: "isPro") {
            return data.count - 1
        } else {
            return data.count
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.settingsCell, for: indexPath) as! SettingsCell
        cell.setTitle(title: self.data[indexPath.row].title, type: self.data[indexPath.row].type)
        cell.backgroundColor = backgroundColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 && !UserDefaults.standard.bool(forKey: "noLogin")  && UserDefaults.standard.bool(forKey: "isPro"){
            data[indexPath.row].title = "Syncing..."
            tableView.reloadData()
                if let _ = Auth.auth().currentUser?.email {
                    let email = Auth.auth().currentUser?.email
                    self.db.collection(K.userPreferenes).document(email!).updateData([
                        "coins": coins,
                        "inventoryArray": inventoryArray
                    ]) { (error) in
                        if let e = error {
                            print("There was a issue saving data to firestore \(e) ")
                        } else {
                            print("Succesfully saved new items")
                            self.data[indexPath.row].title = "Save to other devices"
                            tableView.reloadData()
                        }
                    }
                }
        } else if indexPath.row == 2 {
            let screenSize = UIScreen.main.bounds.size
            containerView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
            navigationController?.navigationBar.backgroundColor = UIColor.black.withAlphaComponent(0.9)
            navigationController?.navigationBar.isUserInteractionEnabled = false
            containerView.frame = self.view.frame
            window?.addSubview(containerView)
            pickerView.backgroundColor = backgroundColor
            pickerView.isUserInteractionEnabled = true
            set.setTitle("Done", for: .normal)
            set.titleLabel?.font = UIFont(name: "Menlo-Bold", size: 18)
            set.setTitleColor(.white, for: .normal)
            set.addTarget(self, action: #selector(setDefaultTime), for: .touchUpInside)
            set.isUserInteractionEnabled = true
            pickerView.dataSource = self
            pickerView.delegate = self
            parentView.frame = CGRect(x: 0, y: ((window?.frame.height)! + 80), width: screenSize.width, height: 270)
            pickerView.frame = CGRect(x: 0, y: 50, width: screenSize.width, height: 200)
            parentView.layer.cornerRadius = 15
            window?.isUserInteractionEnabled = true
            window?.addSubview(parentView)
            parentView.addSubview(pickerView)
            parentView.addSubview(set)
            parentView.backgroundColor = backgroundColor
            self.pickerView.selectRow(UserDefaults.standard.integer(forKey: "defaultTime") - 1, inComponent: 0, animated: true)
            UIView.animate(withDuration: 0.5,
                                 delay: 0, usingSpringWithDamping: 1.0,
                                 initialSpringVelocity: 1.0,
                                 options: .curveEaseOut, animations: { [self] in
                                  containerView.alpha = 0.8
                                    parentView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - 270, width: parentView.frame.width, height: 270)
                                 }, completion: {_ in
                              
                                 })
                                   
            let tapGesture = UITapGestureRecognizer(target: self,
                                                         action: #selector(tappedOutside))
                 tapGesture.cancelsTouchesInView = false
                 containerView.addGestureRecognizer(tapGesture)
        } else if indexPath.row == 7 { // join discord
            if let url = URL(string: "https://discord.gg/ZhfC6az") {
                UIApplication.shared.open(url)
            }
        } else if indexPath.row == 8 { //email
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["focusbyteteam@gmail.com"])
                mail.setMessageBody("<p>Hello,</p>", isHTML: true)
                present(mail, animated: true)
            } else {
                // show failure alert
            }
        }
    }

    
    @objc func setDefaultTime() {
        UserDefaults.standard.setValue(minutes, forKey: "defaultTime")
        if #available(iOS 14.0, *) {
            UserDefaults(suiteName: "group.co.byteteam.focusbyte")?.setValue(minutes, forKey: "defaultTime")
            WidgetCenter.shared.reloadAllTimelines()
        }
        tableView.reloadData()
        tappedOutside()
    }
    @objc func tappedOutside() {
        UIView.animate(withDuration: 0.4,
                                   delay: 0, usingSpringWithDamping: 1.0,
                                   initialSpringVelocity: 1.0,
                                   options: .curveEaseInOut, animations: { [self] in
                                    self.containerView.alpha = 0
                                    parentView.frame = CGRect(x: 0, y: (window?.frame.height)!, width: parentView.frame.width, height: parentView.frame.height
                                    )
                                   }, completion: nil)
        navigationController?.navigationBar.isUserInteractionEnabled = true
        parentView.removeFromSuperview()
        pickerView.removeFromSuperview()
        set.removeFromSuperview()
    }
}


extension SettingsController: UIPickerViewDelegate, UIPickerViewDataSource {

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 2
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            switch component {
            case 0:
                return 120
            case 1, 2:
                return 1
            default:
                return 0
            }
        }

        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return pickerView.frame.size.width/3
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            switch component {
            case 0:
                return "\(row + 1)"
            case 1:
                return "Minutes"
            default:
                return ""
            }
        }
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            switch component {
            case 0:
                minutes = CGFloat(row + 1)
            default:
                break;
            }
        }
    }
