
import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseAuth
import Validator
import AuthenticationServices
import Foundation
import CryptoKit
import AppsFlyerLib

var userEmail = ""
protocol NoLoginDelegate {
    func updateLogoutButton()
}
class RegisterViewController: UIViewController, GIDSignInDelegate {
    
    //MARK: - properties
    fileprivate var currentNonce: String?
    var registerTitle = UILabel()
    var password = UITextField()
    var email = UITextField()
    var passwordConfirmation = UITextField()
    var signUpView = UIView()
    var signUpLabel = UILabel()
    var registerErrorLabel = UILabel(frame: CGRect(x: 100, y: 620, width: buttonWidth, height: 45))
    var emailIsValid = false
    var passwordIsValid = false
    var passwordConfirmationIsValid = false
    var googleImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "googleButton")
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 25
        return iv
    }()
    let db = Firestore.firestore()
    var noLoginDelegate: NoLoginDelegate? 
    var ValInput = ValidateInputs()
    let container: UIView = UIView()
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    let siwa = ASAuthorizationAppleIDButton()
    var signUpButton = UIButton()
    let siwaShadow = UIView()
    var backButton = UIButton()

    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
        if UserDefaults.standard.bool(forKey: "noLogin") {
            view.addSubview(backButton)
            backButton.setTitle("Back", for: .normal)
            backButton.leadingToSuperview(offset: 20)
            backButton.setTitleColor(.systemBlue, for: .normal)
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -15).isActive = true

            //            backButton.isUserInteractionEnabled = true
            backButton.addTarget(self, action: #selector(tappedBackLogin), for: .touchUpInside)
        }
    }
    
    //MARK: - Handlers
    @objc func tappedBackLogin() {
        self.dismiss(animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print(error)
            return
        }
        Auth.auth().fetchSignInMethods(forEmail: user.profile.email, completion: {
            (providers, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let providers = providers {
                if providers.count != 0 {
                    self.registerErrorLabel.text = "Please use the login page"
                    self.registerErrorLabel.textColor = .red
                    self.registerErrorLabel.center.y = self.view.center.y + 220
                    self.view.addSubview(self.registerErrorLabel)
                    return
                }
            }
            guard let authentication = user.authentication else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                           accessToken: authentication.accessToken)
            
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    self.registerErrorLabel.text = "Something went wrong"
                    self.registerErrorLabel.textColor = .red
                    self.registerErrorLabel.center.y = self.view.center.y + 220
                    self.view.addSubview(self.registerErrorLabel)
                    print(error)
                } else {
                    self.registerErrorLabel.removeFromSuperview()
                    userEmail = String(signIn.currentUser.userID)
                    let genderVC = GenderViewController()
                    genderVC.modalPresentationStyle = .fullScreen
                    signUpTapped = true
                    if noLoginGlobal {
                        self.saveToFirebase()
                    } else {
                        AppsFlyerLib.shared().logEvent("tapped_signup_google_onboarding", withValues: [AFEventParamContent: "true"])
                        self.navigationController?.pushViewController(genderVC, animated: true)
                    }
                }
            }
            
        })
        
    }
    
    @objc func tappedRegister() {
        showSpinner()
        if let constant = email.text {
            ValInput.email = constant
            emailIsValid = ValInput.isEmailValid()
            if emailIsValid {
                let color = UIColor.placeholderGray
                let placeholder = "Email" //There should be a placeholder set in storyboard or elsewhere string or pass empty
                email.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
            } else {
                email.text = ""
                let color = UIColor.red
                let placeholder = "Invalid Email" //There should be a placeholder set in storyboard or elsewhere string or pass empty
                email.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
                self.spinner.stopAnimating()
                container.removeFromSuperview()
            }
        }
        if let constant = password.text {
            ValInput.password = constant
            passwordIsValid = ValInput.isPasswordLengthValid()
            let passwordIsNumeric = ValInput.doesPasswordHaveDigits()
            if passwordIsValid && passwordIsNumeric{
                let color = UIColor.placeholderGray
                let placeholder = "Password" //There should be a placeholder set in storyboard or elsewhere string or pass empty
                password.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
            } else if !passwordIsValid {
                password.text = ""
                let color = UIColor.red
                let placeholder = "At least 6 characters" //There should be a placeholder set in storyboard or elsewhere string or pass empty
                password.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
                self.spinner.stopAnimating()
                container.removeFromSuperview()
            } else if !passwordIsNumeric {
                password.text = ""
                passwordIsValid = false
                let color = UIColor.red
                let placeholder = "Must contain numbers"
                password.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
                self.spinner.stopAnimating()
                container.removeFromSuperview()
            }
            
        }
        
        if let constant = passwordConfirmation.text {
            ValInput.passwordConfirmation = constant
            passwordConfirmationIsValid = ValInput.isPasswordConfirmationValid()
            if passwordConfirmationIsValid {
                let color = UIColor.placeholderGray
                let placeholder = "Password Confirmation" //There should be a placeholder set in storyboard or elsewhere string or pass empty
                passwordConfirmation.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
            } else {
                passwordConfirmation.text = ""
                let color = UIColor.red
                let placeholder = "Passwords do not match"
                passwordConfirmation.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
                self.spinner.stopAnimating()
                container.removeFromSuperview()
            }
        }
        if emailIsValid && passwordIsValid && passwordConfirmationIsValid {
            Auth.auth().createUser(withEmail: ValInput.email, password: ValInput.password) { [self] result, error in
                if error != nil {
                    print(error.debugDescription)
                    self.registerErrorLabel.text = "Something went wrong"
                    self.registerErrorLabel.textColor = .red
                    self.registerErrorLabel.center.y = self.view.center.y + 220
                    self.view.addSubview(self.registerErrorLabel)
                    self.container.removeFromSuperview()
                    self.spinner.stopAnimating()
                    return
                }
                userEmail = self.ValInput.email
                self.spinner.stopAnimating()
                let genderVC = GenderViewController()
                signUpTapped = true
                if noLoginGlobal {
                    saveToFirebase()
                } else {
                    AppsFlyerLib.shared().logEvent("tapped_signup_regular_onboarding", withValues: [AFEventParamContent: "true"])
                    self.navigationController?.pushViewController(genderVC, animated: true)
                }
            }
        }
    }
    
    //MARK: - Helper functions
    func saveToFirebase() {
    
        let email = Auth.auth().currentUser?.email
        let results = uiRealm.objects(User.self)
        for result in results {
            if result.isLoggedIn == true {
                let inventory: [String] = result.inventoryArray.map { $0  }
                var tags: [String: String] = [String:String]()
                for tag in result.tagDictionary {
                    tags[tag.name] = tag.color
                }
                if let _ = Auth.auth().currentUser?.email {
                db.collection(K.userPreferenes).document(email!).setData([
                        "gender": result.gender ?? "male",
                        "name": result.name ?? "blank",
                       "inventoryArray": inventory,
                        "exp": result.exp,
                        "coins": result.coins,
                        "hair": result.hair ?? "blonde",
                        "eyes": result.eyes ?? "black",
                        "skin": result.skin ?? "tan",
                        "tags": tags,
                        "isPro": UserDefaults.standard.bool(forKey: "isPro")
                    ]) { (error) in
                        if let e = error {
                            print("There was a issue saving data to firestore \(e) ")
                        } else {
                            print("Succesfully saved")
                        }
                    }
                    AppsFlyerLib.shared().logEvent("signup_from_settings", withValues: [AFEventParamContent: "true"])
                    UserDefaults.standard.setValue(false, forKey: "noLogin")
                    noLoginGlobal = false
                    noLoginDelegate?.updateLogoutButton()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
     
    }
    func configureUI() {
        registerTitle.text = "Sign Up"
        registerTitle.textAlignment = .center
        registerTitle.font = UIFont(name:"Menlo-Bold", size: CGFloat(titleSize))
        registerTitle.textColor = brightPurple
        registerTitle.frame.size.width = 300
        registerTitle.frame.size.height = 100
        registerTitle.center.x = view.center.x
        registerTitle.center.y = view.center.y - 275
        view.addSubview(registerTitle)
        
        signUpView =  UIView(frame: CGRect(x: 100, y: view.center.y + 270, width: buttonWidth, height: 60))
        signUpView.applyDesign(color: lightLavender)
        signUpView.center.x = view.center.x
        signUpView.center.y = view.center.y + registerPadding
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedRegister))
        signUpView.addGestureRecognizer(tap)
        view.addSubview(signUpView)
        
        signUpLabel.applyDesign(text: "Register")
        signUpLabel.sizeToFit()
        signUpLabel.center.x = view.center.x
        signUpLabel.center.y = view.center.y + registerPadding
        view.addSubview(signUpLabel)
        
        configureNavigationBar(color: .white, isTrans: true)
        loadTextFields()
        loadButtons()
    }
    
    func loadTextFields() {
        view.addSubview(email)
        email.topAnchor.constraint(equalTo: self.registerTitle.bottomAnchor, constant: 5).isActive = true
        email.addDoneButtonOnKeyboard()
        email.applyDesign(view, x: xPadding, y: -225)
        email.placeholder = "Email"
        email.autocorrectionType = .no
        email.autocapitalizationType = .none
        
        password.isSecureTextEntry = true
        view.addSubview(password)
        password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 18).isActive = true
        password.addDoneButtonOnKeyboard()
        password.applyDesign(view, x: xPadding, y: -130)
        password.placeholder = "Password"
        password.autocorrectionType = .no
        password.autocapitalizationType = .none
        
        
        passwordConfirmation.isSecureTextEntry = true
        passwordConfirmation.addDoneButtonOnKeyboard()
        view.addSubview(passwordConfirmation)
        passwordConfirmation.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 22).isActive = true
        passwordConfirmation.applyDesign(view, x: xPadding, y: -35)
        passwordConfirmation.placeholder = "Password Confirmation"
        passwordConfirmation.autocorrectionType = .no
         passwordConfirmation.autocapitalizationType = .none
        
    }
    
    func showSpinner() {
        spinner.hidesWhenStopped = true
        container.frame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
        container.backgroundColor = .clear
        spinner.center = self.view.center
        view.addSubview(container)
        container.addSubview(spinner)
        spinner.startAnimating()
    }
    
    func loadButtons() {
        view.addSubview(googleImage)
        let tappedGoogle = UITapGestureRecognizer(target: self, action: #selector(googleTapped))
        googleImage.addGestureRecognizer(tappedGoogle)
        googleImage.centerX(to: view)
        googleImage.topToBottom(of: passwordConfirmation, offset: 20)
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
        
        view.addSubview(signUpButton)
        signUpButton.centerXToSuperview()
        signUpButton.width(buttonWidth)
        signUpButton.height(60)
        signUpButton.topToBottom(of: signUpView, offset: 15)
        signUpButton.backgroundColor = brightPurple
        signUpButton.setTitle("Have an Account? Login", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: "Menlo", size: 18)
        signUpButton.titleLabel?.adjustsFontSizeToFitWidth = true
        signUpButton.layer.cornerRadius = 25
        signUpButton.layer.shadowColor = UIColor.black.cgColor
        signUpButton.layer.shadowOpacity = 0.5
        signUpButton.layer.shadowOffset = .zero
        signUpButton.layer.shadowRadius = 10
        signUpButton.addTarget(self, action: #selector(tappedLogin), for: .touchUpInside)
    }
    @objc func tappedLogin() {
        AppsFlyerLib.shared().logEvent("tapped_login_onboarding", withValues: [AFEventParamContent: "true"])
        let loginVC = LoginViewController()
        self.navigationController?.pushViewController(loginVC, animated: true)
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
}

extension RegisterViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // return the current view window
        return self.view.window!
    }
}
extension RegisterViewController : ASAuthorizationControllerDelegate {
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
                self.registerErrorLabel.text = "Please use login page"
                self.registerErrorLabel.textColor = .red
                self.registerErrorLabel.center.y = self.view.center.y + 220
                self.view.addSubview(self.registerErrorLabel)
                return
            }

            Auth.auth().signIn(with: firebaseCredential) { [weak self] (authResult, error) in
                // Do something after Firebase si®gn in completed
                if let error = error {
                    print(error.localizedDescription)
                    self?.registerErrorLabel.text = "Something went wrong"
                    self?.registerErrorLabel.textColor = .red
                    self?.registerErrorLabel.center.y = self!.view.center.y + 220
                    self?.view.addSubview(self!.registerErrorLabel)
                } else {
                    self!.spinner.stopAnimating()
                    let genderVC = GenderViewController()
                    signUpTapped = true
                    if noLoginGlobal {
                        self!.saveToFirebase()
                    } else {
                        AppsFlyerLib.shared().logEvent("tapped_signup_apple_onboarding", withValues: [AFEventParamContent: "true"])
                        self?.navigationController?.pushViewController(genderVC, animated: true)
                    }
                }
            }
       
        }
    }
}
