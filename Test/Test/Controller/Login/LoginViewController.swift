import UIKit
import Firebase
import GoogleSignIn
import RealmSwift
import AuthenticationServices
import Purchases
class LoginViewController: UIViewController,GIDSignInDelegate {
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
    fileprivate var currentNonce: String?
    var googleImage: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "googleButton")
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 25
        return iv
    }()
    let siwa = ASAuthorizationAppleIDButton()
    let siwaShadow = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.insertSubview(background, at: 0)
                NSLayoutConstraint.activate([
                    background.topAnchor.constraint(equalTo: view.topAnchor),
                    background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    background.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
        super.viewWillAppear(animated)
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
    
    }
    
    //MARK: - Helper Functions
    
    func configureUI() {
        view.backgroundColor = .white
        loginTitle.frame.size.width = 300
        loginTitle.frame.size.height = 100
        loginTitle.center.x = view.center.x + 70
        loginTitle.center.y = view.center.y - 230
        loginTitle.text = !isIpod ? "Login" : ""
        loginTitle.font = UIFont(name: "Menlo-Bold", size: CGFloat(titleSize))
        loginTitle.textColor = brightPurple
        view.addSubview(loginTitle)
        
        
        loginButtonView =  UIView(frame: CGRect(x: 100, y: 400, width: buttonWidth, height: 60))
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
        loadButtons()
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
                        self.errorLabel =  UILabel(frame: CGRect(x: self.view.center.x - 100, y: self.password.center.y + 50 , width: buttonWidth, height: 50))
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
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
            showSpinner()
             if let error = error {
                 print(error)
                 return
             }
             
             guard let authentication = user.authentication else { return }
            
             let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                            accessToken: authentication.accessToken)
             Auth.auth().signIn(with: credential) { (authResult, error) in
                 if let error = error {
                    print(error)
                    self.errorLabel.text = "Something went wrong"
                    self.errorLabel.textColor = .red
                    self.errorLabel.center.y = self.view.center.y + 220
                    self.view.addSubview(self.errorLabel)
                    self.spinner.stopAnimating()
                 } else {
                     self.saveToRealm()
                 }
             }
         }
    
    
    
    @objc func tappedLogin() {
        // do something here
        showSpinner()
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { result, error in
            if error != nil {
                self.errorLabel =  UILabel(frame: CGRect(x: self.view.center.x - 130, y: self.password.center.y + 20 , width: buttonWidth, height: 50))
                self.errorLabel.text = "username or password is incorrect"
                self.errorLabel.textColor = .red
                self.view.addSubview(self.errorLabel)
                //                self.errorLabel.topAnchor.constraint(equalTo: self.password.bottomAnchor, constant: 30).isActive = true
                self.spinner.stopAnimating()
                self.container.removeFromSuperview()
            } else {
                self.saveToRealm()
               
            }
        }
    }
    func loadButtons() {
        view.addSubview(googleImage)
        let tappedGoogle = UITapGestureRecognizer(target: self, action: #selector(googleTapped))
        googleImage.addGestureRecognizer(tappedGoogle)
        googleImage.centerX(to: view)
         googleImage.topToBottom(of: password, offset: 30)
         googleImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
         googleImage.widthAnchor.constraint(lessThanOrEqualToConstant: lessThanConstant).isActive = true
         googleImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: onPad ? 0.4 : 0.8).isActive = true
        googleImage.applyDesign(color: .white)
        
         view.addSubview(siwaShadow)
         siwaShadow.heightAnchor.constraint(equalToConstant: 50).isActive = true
         siwaShadow.widthAnchor.constraint(lessThanOrEqualToConstant: lessThanConstant).isActive = true
         siwaShadow.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: onPad ? 0.4 : 0.8).isActive = true
         siwaShadow.topToBottom(of: googleImage, offset: 20)
         siwaShadow.centerX(to: view)
         siwaShadow.applyDesign(color: .black)
    
         view.addSubview(siwa)
        siwa.translatesAutoresizingMaskIntoConstraints = false
         siwa.heightAnchor.constraint(equalToConstant: 50).isActive = true
         siwa.widthAnchor.constraint(lessThanOrEqualToConstant: lessThanConstant).isActive = true
         siwa.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: onPad ? 0.4 : 0.8).isActive = true
         siwa.topToBottom(of: googleImage, offset: 20)
         siwa.centerX(to: view)
         siwa.clipsToBounds = true
         siwa.layer.cornerRadius = 25
         siwa.addTarget(self, action: #selector(appleSignInTapped), for: .touchUpInside)
    }
    @objc func appleSignInTapped() {
             let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            // request full name and email from the user's Apple ID
            request.requestedScopes = [.fullName, .email]
           // Generate nonce for validation after authentication successful
           self.currentNonce = randomNonceString()
           // Set the SHA256 hashed nonce to ASAuthorizationAppleIDRequest
           request.nonce = sha256(currentNonce!)
            // pass the request to the initializer of the controller
            let authController = ASAuthorizationController(authorizationRequests: [request])
          
            // similar to delegate, this will ask the view controller
            // which window to present the ASAuthorizationController
            authController.presentationContextProvider = self
          
            // delegate functions will be called when user data is
            // successfully retrieved or error occured
            authController.delegate = self
            
            // show the Sign-in with Apple dialog
            authController.performRequests()
    }
    
    @objc func googleTapped() {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    
    func loadTextViews() {
        view.addSubview(email)
        email.addDoneButtonOnKeyboard()
        email.topAnchor.constraint(equalTo: loginTitle.bottomAnchor, constant: 5).isActive = true
        email.applyDesign(view, x: xPadding, y: -180)
        email.placeholder = "Email"
        password.addDoneButtonOnKeyboard()
        password.isSecureTextEntry = true
        view.addSubview(password)
        password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 30).isActive = true
        password.applyDesign(view, x: xPadding, y: -75)
        password.placeholder = "Password"   
        
    }
    
    
    func loadForgotPassword() {
        forgotPassword = UILabel(frame: CGRect(x: view.center.x - 100, y: loginButtonView.center.y + 30 , width: buttonWidth, height: 50))
        forgotPassword.attributedText = NSAttributedString(string: "Forgot my password", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        forgotPassword.textColor = .blue
        forgotPassword.font = UIFont(name: "Menlo", size: 18)
        view.addSubview(forgotPassword)
        
        let tapForgot = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordTapped))
        forgotPassword.isUserInteractionEnabled = true
        forgotPassword.addGestureRecognizer(tapForgot)
    }
    
    func saveToRealm() {
    
        createRealmData()
    }
    
    func createRealmData() {
        //did not find result
        //User logged into a new phone, so we have to recreate realm data
        let realmUser = User()
        if let email = Auth.auth().currentUser?.email {
            loggedOut = false
            var gender = ""
            var coins = -1
            var name = ""
            var tagDict:[String:String] = [:]
            var timeD = [String]()
            var inventoryArray = [String]()
            let docRef = db.collection(K.FStore.collectionName).document(email)
            var hair = ""
            var eyes = ""
            var skin = ""
            var xp = 0
            var isPro = false
            docRef.getDocument { (snapshot, error) in
                if let document = snapshot, document.exists {
                    _ = document.data().map(String.init(describing:)) ?? "nil"
                    if let g = document["gender"]  {
                        gender = g as! String
                    }
                    if let n = document["name"] {
                        name = n as! String
                    }
                    if let c = document["coins"] {
                        coins = c  as! Int
                    }
                    if let hairr = document["hair"] {
                        hair = hairr as! String
                    }
                    if let exp = document["exp"] {
                        xp = exp as! Int
                    }
                    if let eyess = document["eyes"] {
                        eyes = eyess as! String
                    }
                    if let skinn = document["skin"] {
                        skin = skinn as! String
                    }
                    if let isP = document["isPro"] {
                        isPro = isP as! Bool
                    }
                    if let timeData = document["TimeData"] {
                         timeD = timeData as! [String]
                       
                    }
                    if let tags = document["tags"] {
                        tagDict = tags as! [String : String]
                    }
                    if let itemArray = document["inventoryArray"] {
                        inventoryArray = itemArray as! [String]
                    }
                } else {
                    let genderVC = GenderViewController()
                    self.navigationController?.pushViewController(genderVC, animated: true)
                    return
                }
                let tagList = List<Tag>()
                for tag in tagDict {
                    let tagVar = Tag()
                    tagVar.name = tag.key
                    tagVar.color = tag.value
                    
                    tagVar.selected = tag.key == "unset" ? true : false
                    if tag.key == "unset" {
                        tagList.insert(tagVar, at: 0)
                    } else {
                        tagList.append(tagVar)
                    }
                }
                let doesExist = self.checkIfUserExists()
                
                if !doesExist {
                    realmUser.name = name
                    realmUser.email = Auth.auth().currentUser?.email
                    realmUser.isLoggedIn = true
                    realmUser.deepFocusMode = true
                    realmUser.skin = skin
                    realmUser.exp = xp
                    realmUser.hair = hair
                    for entry in timeD {
                        realmUser.timeArray.append(entry)
                    }
                    for item in inventoryArray {
                        realmUser.inventoryArray.append(item)
                    }
                    for tag in tagList {
                        realmUser.tagDictionary.append(tag)
                    }
                    realmUser.eyes = eyes
                    realmUser.gender = gender
                    realmUser.coins = coins
                    realmUser.writeToRealm()
                } else {
                    for result  in self.results {
                      //same phone
                        if result.email == Auth.auth().currentUser?.email {
                            do {
                           try uiRealm.write {
                            for entry in timeD {
                                result.timeArray.append(entry)
                            }
                                result.name = name
                            for item in inventoryArray {
                                result.inventoryArray.append(item)
                            }
                            for tag in tagList {
                                result.tagDictionary.append(tag)
                            }
                                result.isLoggedIn = true
                                result.deepFocusMode = true
                                result.skin = skin
                                result.exp = xp
                                result.hair = hair
                                result.eyes = eyes
                                result.gender = gender
                                result.coins = coins
                            
                                }
                            } catch {
                                print(error)
                            }
                            
                        }
                    }
                }
                UserDefaults.standard.set(true, forKey: "quotes")
                UserDefaults.standard.set(isPro, forKey: "isPro")
                let timerVC = ContainerController(center: TimerController())
                timerVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(timerVC, animated: true)
            }
        } else {
            print("firebase error")
        }
    }
    
    func checkIfUserExists() -> Bool{
        results = uiRealm.objects(User.self)
        for result  in results {
            //same phone
             if result.email == Auth.auth().currentUser?.email {
                return true
             }
         }
        return false
    }
    
}
extension LoginViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // return the current view window
        return self.view.window!
    }
}
extension LoginViewController : ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("authorization error")
        guard let error = error as? ASAuthorizationError else {
            return
        }

        switch error.code {
        case .canceled:
            // user press "cancel" during the login prompt
            print("Canceled")
        case .unknown:
            // user didn't login their Apple ID on the device
            print("Unknown")
        case .invalidResponse:
            // invalid response received from the login
            print("Invalid Respone")
        case .notHandled:
            // authorization request not handled, maybe internet failure during login
            print("Not handled")
        case .failed:
            // authorization failed
            print("Failed")
        @unknown default:
            print("Default")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            UserDefaults.standard.set(appleIDCredential.user, forKey: "appleAuthorizedUserIdKey")
            // Retrieve the secure nonce generated during Apple sign in
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }

            // Retrieve Apple identity token
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Failed to fetch identity token")
                return
            }

            // Convert Apple identity token to string
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Failed to decode identity token")
                return
            }

            // Initialize a Firebase credential using secure nonce and Apple identity token
            let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                              idToken: idTokenString,
                                                              rawNonce: nonce)
            guard let _ = appleIDCredential.email else {
                // User already signed in with this appleId once
                Auth.auth().signIn(with: firebaseCredential) { [weak self] (authResult, error) in
                    // Do something after Firebase sign in completed
                    if let error = error {
                        print(error.localizedDescription)
                        self?.errorLabel.text = "Something went wrong"
                        self?.errorLabel.textColor = .red
                        self?.errorLabel.center.y = self!.view.center.y + 220
                        self?.view.addSubview(self!.errorLabel)
                    } else {
                        self!.spinner.stopAnimating()
                        self!.createRealmData()
                    }
                }
                return
            }
            //User never signed in with this email before
            Auth.auth().signIn(with: firebaseCredential) { [weak self] (authResult, error) in
                // Do something after Firebase sign in completed
                if let error = error {
                    print(error.localizedDescription)
                    self?.errorLabel.text = "Something went wrong"
                    self?.errorLabel.textColor = .red
                    self?.errorLabel.center.y = self!.view.center.y + 220
                    self?.view.addSubview(self!.errorLabel)
                } else {
                    self!.spinner.stopAnimating()
                    let genderVC = GenderViewController()
                    self?.navigationController?.pushViewController(genderVC, animated: true)
                }
            }
        
        }
    }
}
