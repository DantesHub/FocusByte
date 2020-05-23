import UIKit
import Firebase
import GoogleSignIn
import RealmSwift
let realmUser = User()
class LoginViewController: UIViewController {
    var goToTimerView = UIView()
    var goToTimerLabel = UILabel()
    var results: Results<User>!
    var email = UITextField()
    var password = UITextField()
    var loginTitle = UILabel()
    var loginButtonView = UIView()
    var loginButtonLabel = UILabel()
    var errorLabel: UILabel!
    var emailIsValid = false
    let db = Firestore.firestore()
    var passwordIsValid = false
    var forgotEmailField = UITextField()
    let container: UIView = UIView()
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    var forgotPassword: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loginTitle.frame.size.width = 300
        loginTitle.frame.size.height = 100
        loginTitle.center.x = view.center.x + 70
        loginTitle.center.y = view.center.y - 180
        loginTitle.text = "Login"
        loginTitle.font = UIFont(name: "Menlo-Bold", size: 55)
        loginTitle.textColor = brightPurple
        view.addSubview(loginTitle)
        
        loginButtonView =  UIView(frame: CGRect(x: 100, y: 400, width: 350, height: 60))
        loginButtonView.applyDesign(color: lightLavender)
        loginButtonView.center.x = view.center.x
        loginButtonView.center.y = view.center.y + 200
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedLogin))
        loginButtonView.addGestureRecognizer(tap)
        view.addSubview(loginButtonView)
        
        loginButtonLabel.applyDesign(text: "Sign in")
        loginButtonLabel.sizeToFit()
        loginButtonLabel.center.x = view.center.x
        loginButtonLabel.center.y = view.center.y + 200
        view.addSubview(loginButtonLabel)
        // Do any additional setup after loading the view.
        loadTextViews()
        loadForgotPassword()
    }
    
    @objc func forgotPasswordTapped() {
        let alert = UIAlertController(title: "Enter email you used to sign up with", message:nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "example@email.com"
        }
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            if let emailString = alert.textFields?.first?.text {
                Auth.auth().sendPasswordReset(withEmail: emailString) { error in
                    if error != nil {
                        self.errorLabel =  UILabel(frame: CGRect(x: self.view.center.x - 100, y: self.password.center.y + 50 , width: 350, height: 50))
                        self.errorLabel.text =  "Email does not exist"
                        self.errorLabel.textColor = .red
                        self.view.addSubview(self.errorLabel)
                    } else {
                        self.errorLabel.removeFromSuperview()
                    }
                }
            }
        }))
        
        self.present(alert, animated: true)
        
    }
    
    func showSpinner() {
        spinner.hidesWhenStopped = true
        container.frame = CGRect(x: 0, y: 0, width: 1000, height: 1000) // Set X and Y whatever you want
        container.backgroundColor = .clear
        spinner.center = self.view.center
        view.addSubview(container)
        container.addSubview(spinner)
        spinner.startAnimating()
    }
    
    
    
    @objc func tappedLogin() {
        // do something here
        showSpinner()
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { result, error in
            if error != nil {
                self.errorLabel =  UILabel(frame: CGRect(x: self.view.center.x - 130, y: self.password.center.y + 50 , width: 350, height: 50))
                self.errorLabel.text = "username or password is incorrect"
                self.errorLabel.textColor = .red
                self.view.addSubview(self.errorLabel)
                //                self.errorLabel.topAnchor.constraint(equalTo: self.password.bottomAnchor, constant: 30).isActive = true
                self.spinner.stopAnimating()
                self.container.removeFromSuperview()
            } else {
                let timerVC = ContainerController(center: TimerController())
                timerVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(timerVC, animated: true)
                self.saveToRealm()
            }
        }
    }
    
    
    func loadTextViews() {
        view.addSubview(email)
        email.addDoneButtonOnKeyboard()
        email.topAnchor.constraint(equalTo: loginTitle.bottomAnchor, constant: 25).isActive = true
        email.applyDesign(view, x: -165, y: -110)
        email.placeholder = "Email"
        password.addDoneButtonOnKeyboard()
        password.isSecureTextEntry = true
        view.addSubview(password)
        password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 30).isActive = true
        password.applyDesign(view, x: -165, y: -5)
        password.placeholder = "Password"   
        
    }
    
    
    func loadForgotPassword() {
        forgotPassword = UILabel(frame: CGRect(x: view.center.x - 100, y: loginButtonView.center.y + 30 , width: 350, height: 50))
        forgotPassword.attributedText = NSAttributedString(string: "Forgot my password", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        forgotPassword.textColor = .blue
        forgotPassword.font = UIFont(name: "Menlo", size: 18)
        view.addSubview(forgotPassword)
        
        let tapForgot = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordTapped))
        forgotPassword.isUserInteractionEnabled = true
        forgotPassword.addGestureRecognizer(tapForgot)
    }
    
    func saveToRealm() {
        results = uiRealm.objects(User.self)
        for result  in results {
            if result.email == Auth.auth().currentUser?.email {
                do {
                    try uiRealm.write {
                        print("saved")
                        loggedOut = false
                        result.setValue(true, forKey: "isLoggedIn")
                    }
                    
                } catch {
                    print(error)
                    
                }
              return
            }
        }
        createRealmData()
    }
    
    func createRealmData() {
        //did not find result
        //User logged into a new phone, so we have to recreate realm data
        if let email = Auth.auth().currentUser?.email {
            loggedOut = false
            var gender = ""
            var coins = -1
            var name = ""
            var tagDict:[String:String] = [:]
            let timeD = List<String>()
            let docRef = db.collection(K.FStore.collectionName).document(email)
            docRef.getDocument { (snapshot, error) in
                if let document = snapshot, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    if let g = document["gender"]  {
                        gender = g as! String
                    }
                    if let n = document["name"] {
                        name = n as! String
                    }
                    if let c = document["coins"] {
                        coins = c  as! Int
                    }
                    if let timeData = document["TimeData"] {
                        print(timeData)
                        let entries = timeData as! [String]
                        for entry in entries {
                            timeD.append(entry)
                        }
                    }
                    if let tags = document["tags"] {
                        tagDict = tags as! [String : String]
                        print(tagDict)
                    }
                } else {
                    print("Document does not exist")
                }
                let tagList = List<Tag>()
                for tag in tagDict {
                    let tagVar = Tag()
                    tagVar.name = tag.key
                    tagVar.color = tag.value
                    tagVar.selected = tag.key == "unset" ? true : false
                    tagList.append(tagVar)
                }
                //import preset tags
                realmUser.timeArray = timeD 
                realmUser.name = name
                realmUser.tagDictionary = tagList
                realmUser.email = Auth.auth().currentUser?.email
                realmUser.isLoggedIn = true
                realmUser.gender = gender
                realmUser.coins = coins
                realmUser.writeToRealm()
            }
        }
    }
    
}
