
import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseAuth
import Validator
var userEmail = ""
class RegisterViewController: UIViewController, GIDSignInDelegate {
    var registerTitle = UILabel()
    var password = UITextField()
    var email = UITextField()
    var passwordConfirmation = UITextField()
    var signUpView = UIView()
    var signUpLabel = UILabel()
    var emailErrorLabel =  UILabel(frame: CGRect(x: 60, y: 305, width: 350, height: 40))
    var passwordErrorLabel = UILabel(frame: CGRect(x: 60, y: 405, width: 350, height: 40))
    var passwordConfirmationErrorLabel = UILabel(frame: CGRect(x: 60, y: 618, width: 350, height: 50))
    var registerErrorLabel = UILabel(frame: CGRect(x: 60, y: 620, width: 350, height: 45))
    var emailIsValid = false
    var passwordIsValid = false
    var passwordConfirmationIsValid = false
    let googleImage = UIImage(named: "googleButton")
    let facebookImage = UIImage(named: "facebookButton")
    
    var ValInput = ValidateInputs()
    let container: UIView = UIView()
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        registerTitle.text = "Sign up"
        registerTitle.textAlignment = .center
        registerTitle.font = UIFont(name:"Menlo-Bold", size: 55)
        registerTitle.textColor = brightPurple
        registerTitle.frame.size.width = 300
        registerTitle.frame.size.height = 100
        registerTitle.center.x = view.center.x
        registerTitle.center.y = view.center.y - 280
        view.addSubview(registerTitle)
        
        signUpView =  UIView(frame: CGRect(x: 100, y: view.center.y + 270, width: 350, height: 60))
        signUpView.applyDesign(color: lightLavender)
        signUpView.center.x = view.center.x
        signUpView.center.y = view.center.y + 270
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedRegister))
        signUpView.addGestureRecognizer(tap)
        view.addSubview(signUpView)
        
        signUpLabel.applyDesign(text: "Register")
        signUpLabel.sizeToFit()
        signUpLabel.center.x = view.center.x
        signUpLabel.center.y = view.center.y + 270
        view.addSubview(signUpLabel)
        
        configureNavigationBar()
        loadButtons()
        loadTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
       
    }
    
    @objc func tappedRegister() {
        showSpinner()
        if let constant = email.text {
            ValInput.email = constant
            emailIsValid = ValInput.isEmailValid()
            if emailIsValid {
                emailErrorLabel.removeFromSuperview()
            } else {
                emailErrorLabel.text = "Invalid Email"
                emailErrorLabel.textColor = .red
                self.spinner.stopAnimating()
                container.removeFromSuperview()
                view.addSubview(emailErrorLabel)
            }
        }
        
        if let constant = password.text {
            ValInput.password = constant
            passwordIsValid = ValInput.isPasswordLengthValid()
            let passwordIsNumeric = ValInput.doesPasswordHaveDigits()
            if passwordIsValid && passwordIsNumeric{
                passwordErrorLabel.removeFromSuperview()
            } else if !passwordIsValid {
                passwordErrorLabel.text = "password must be at least 5 characters"
                passwordErrorLabel.textColor = .red
                self.spinner.stopAnimating()
                container.removeFromSuperview()
                view.addSubview(passwordErrorLabel)
            } else if !passwordIsNumeric {
                passwordErrorLabel.text = "password must contain numbers"
                passwordErrorLabel.textColor = .red
                self.spinner.stopAnimating()
                container.removeFromSuperview()
                view.addSubview(passwordErrorLabel)
            }
            
        }
        
        if let constant = passwordConfirmation.text {
            ValInput.passwordConfirmation = constant
            passwordConfirmationIsValid = ValInput.isPasswordConfirmationValid()
            if passwordConfirmationIsValid {
                passwordConfirmationErrorLabel.removeFromSuperview()
            } else {
                passwordConfirmationErrorLabel.text = "passwords do not match"
                passwordConfirmationErrorLabel.textColor = .red
                self.spinner.stopAnimating()
                container.removeFromSuperview()
                view.addSubview(passwordConfirmationErrorLabel)
            }
        }
        
        
        if emailIsValid && passwordIsValid && passwordConfirmationIsValid {
            Auth.auth().createUser(withEmail: ValInput.email, password: ValInput.password) { result, error in
                // [START_EXCLUDE]
                if error != nil {
                    self.registerErrorLabel.numberOfLines = 2
                    self.registerErrorLabel.text = error!.localizedDescription
                    self.registerErrorLabel.textColor = .red
                    self.view.addSubview(self.registerErrorLabel)
                    self.container.removeFromSuperview()
                    self.spinner.stopAnimating()
                    return
                }
                userEmail = self.ValInput.email
                print(userEmail)
                self.spinner.stopAnimating()
                let genderVC = GenderViewController()
                self.navigationController?.pushViewController(genderVC, animated: true)
            }
        }
    }

    
    func loadTextFields() {
        
        email.placeholder = "Email"
        view.addSubview(email)
        email.topAnchor.constraint(equalTo: self.registerTitle.bottomAnchor, constant: 15).isActive = true
        email.applyDesign(view, x: -165, y: -220)
        
        
        password.isSecureTextEntry = true
        password.placeholder = "Password"
        view.addSubview(password)
        password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 28).isActive = true
        password.applyDesign(view, x: -165, y: -115)
        
        passwordConfirmation.isSecureTextEntry = true
        passwordConfirmation.placeholder = "Password Confirmation"
        view.addSubview(passwordConfirmation)
        passwordConfirmation.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 32).isActive = true
        passwordConfirmation.applyDesign(view, x: -165, y: -10)
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
    
    func loadButtons() {
        let googleImageView = GIDSignInButton(frame: CGRect(x: view.center.x - 150 , y: signUpView.center.y - 180, width: 130, height: 50))
        googleImageView.clipsToBounds = true
        let shadowView = UIView(frame: CGRect(x:view.center.x - 150 , y: signUpView.center.y - 180 , width: 130, height: 50))
        shadowView.backgroundColor = .white
        shadowView.dropShadow(superview: view)
        view.addSubview(shadowView)
        view.insertSubview(googleImageView, aboveSubview: shadowView)
        view.addSubview(googleImageView)
        
        
//        let facebookLoginButton = FBSDKLoginButton()
//        loginButton.delegate = self
        let facebookImageView = UIImageView(image: facebookImage)
        facebookImageView.frame = CGRect(x: view.center.x + 30, y: signUpView.center.y - 180  , width: 130, height: 58)
        facebookImageView.clipsToBounds = true
        let shadowView2 = UIView(frame: CGRect(x: view.center.x + 30 , y: signUpView.center.y - 180 , width: 130, height: 58))
        shadowView2.backgroundColor = .white
        shadowView2.dropShadow(superview: view)
        view.addSubview(shadowView2)
        view.insertSubview(facebookImageView, aboveSubview: shadowView2)
        view.addSubview(facebookImageView)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
         // ...
         if let error = error {
             print(error)
             return
         }
         
         guard let authentication = user.authentication else { return }
        
         let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
         Auth.auth().signIn(with: credential) { (authResult, error) in
             if let error = error {
                self.passwordConfirmationErrorLabel.text = "Something went wrong"
                self.passwordConfirmationErrorLabel.textColor = .red
                self.view.addSubview(self.passwordConfirmationErrorLabel)
                print(error)
             } else {
                self.passwordConfirmationErrorLabel.removeFromSuperview()
                 print("user is signed in")
                userEmail = String(signIn.currentUser.userID)
                let genderVC = GenderViewController()
                genderVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(genderVC, animated: true)
             }
         }
     }
    
    
    
    func firebaseFacebookLogin(accessToken: String) {
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                self.passwordConfirmationErrorLabel.text = "Something went wrong"
                self.passwordConfirmationErrorLabel.textColor = .red
                self.view.addSubview(self.passwordConfirmationErrorLabel)
                print(error)
            } else {
                self.passwordConfirmationErrorLabel.removeFromSuperview()
                let genderVC = GenderViewController()
                genderVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(genderVC, animated: true)
            }
        }
    }
}

