//
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
var loggedOut = false
class SettingsController: UIViewController, MFMailComposeViewControllerDelegate {
    struct Setting {
        var title: String
        var type: String
    }
    //MARK: - Properties
    let db = Firestore.firestore()
    var warning:UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Menlo", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var data = [Setting(title: "Deep Focus Mode (Notifs)", type: "dfm"),Setting(title: "Quotes on home screen", type: "quotes"), Setting(title: "Save to other devices", type: "sync"), Setting(title: "Rate Us!", type: "rate"), Setting(title: "Go Pro!", type: "gopro"), Setting(title: "Restore Purchase", type: "restore"),Setting(title: "Join the Discord!", type: "discord"), Setting(title: "Email me! Feedback or Bugs :)", type: "email"),Setting(title: "⚠️❗️Non Pro users will lose all data if logged out", type: "warning")]
    var results: Results<User>!
    let logOutButton = UIButton()
    var delegate: ContainerControllerDelegate!
    var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.settingsCell)
        tv.isScrollEnabled = false
   
        return tv
    }()
    
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
        tableView.height(view.frame.height * 0.72)
        tableView.rowHeight = view.frame.height * 0.09
        logOutButton.setTitle("Log out", for: .normal)
        logOutButton.titleLabel?.font = UIFont(name: "Menlo-Bold", size: 20)
        logOutButton.titleLabel?.textAlignment = .center
        logOutButton.layer.cornerRadius = 25
        logOutButton.backgroundColor = darkRed
        logOutButton.layoutSubviews()
        view.addSubview(logOutButton)
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logOutButton.width(view.frame.width * 0.60)
        logOutButton.topToBottom(of: tableView, offset: 10)
        logOutButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        logOutButton.addTarget(self, action: #selector(logOutPressed), for: .touchUpInside)
    }

    //MARK: - Handlers
      @objc func handleMenuToggle() {
          if !isPlaying {
              delegate?.handleMenuToggle(forMenuOption: nil)
          }
      }
    
    @objc func logOutPressed() {
         results = uiRealm.objects(User.self)
                  for result  in results {
                      if result.isLoggedIn == true {
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
//MARK: - extension
extension SettingsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.settingsCell, for: indexPath) as! SettingsCell
        cell.setTitle(title: self.data[indexPath.row].title, type: self.data[indexPath.row].type)
        cell.backgroundColor = backgroundColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
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
        } else if indexPath.row == 6 { // join discord
            if let url = URL(string: "https://discord.gg/ZhfC6az") {
                UIApplication.shared.open(url)
            }
        } else if indexPath.row == 7 { //email
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
}



